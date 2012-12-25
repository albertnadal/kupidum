//
//  pjsip_wrapper.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#include <stdio.h>
#include "pjsip_wrapper.h"
#include "pjsua-lib/pjsua_internal.h"
#include "pjmedia/session.h"
//#import "RTCAccountConfig.h"
//#import "Base64Utilities.h"
//#import "XMLParser.h"
//#import "CNCMessageParser.h"
#import <AudioToolbox/AudioToolbox.h>

#define PJSIP_LOG_LEVEL 4
#define PJSIP_LOG_ENABLED true

static pjsua_acc_id acc_id;
static pjsua_acc_config acc_cfg;
static pjsua_call_setting call_setting;

static pjsua_transport_config tp_cfg;
static pjsua_transport_id tp_id = -1;
static pjsip_transport *the_transport = 0;


// Enable/disable UA audio and video calls (should be always True if possible)
bool current_call_has_video = false;
bool call_is_active = false;
pjmedia_dir current_call_video_dir = PJMEDIA_DIR_NONE;          //SDP a=inactive
pjmedia_dir current_call_remote_video_dir = PJMEDIA_DIR_NONE;   //SDP a=inactive

// Forward declarations

// Callbacks -----------------------------
static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id,pjsip_rx_data *rdata);
static void on_reg_state(pjsua_acc_id acc_id);
static void on_call_state (pjsua_call_id call_id, pjsip_event *e);
static void on_call_media_state(pjsua_call_id call_id);
static void on_call_rx_offer(pjsua_call_id call_id, const pjmedia_sdp_session *offer, void *reserved, pjsip_status_code *code, pjsua_call_setting *opt);
static void on_pager2(pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, 
                      const pj_str_t *contact, const pj_str_t *mime_type, const pj_str_t *body, 
                      pjsip_rx_data *rdata, pjsua_acc_id acc_id);

static void on_pager_status2 (pjsua_call_id call_id, const pj_str_t *to, const pj_str_t *body, 
                              void *user_data, pjsip_status_code status, const pj_str_t *reason, 
                              pjsip_tx_data *tdata, pjsip_rx_data *rdata, pjsua_acc_id acc_id);

static void on_typing (pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, 
                       const pj_str_t *contact, pj_bool_t is_typing);

static void on_reg_state2(pjsua_acc_id reg_acc_id, pjsua_reg_info *info);
// ----------------------------------------

// Transport functions --------------------
static pj_status_t create_transport();
// ----------------------------------------

// Header functions -----------------------
/*static RTCEventOptions * RTCEventOptions_from_header(const pjsip_hdr *header);
static void add_optional_headers(pjsua_msg_data * messageData, RTCEventOptions * options);*/
static void add_header(pjsua_msg_data * messageData, const char * headerKey, const char *headerValue);
// ----------------------------------------

// String functions -----------------------
static NSString* to_NSString(const pj_str_t* s, NSStringEncoding e);
static pj_str_t strdup_in_pool(pj_pool_t* pool, const char* srcstr);
static const char * get_charstr_from_value(id value);
// ----------------------------------------

KPDClientSIP *client;
KPDVideoDeviceView *videoDeviceView;
KPDVideoDeviceView *outgoingVideoDeviceView;

static NSString* to_NSString(const pj_str_t* s, NSStringEncoding e)
{
    return [[NSString alloc] initWithBytes:s->ptr length:s->slen encoding:e];
}

static bool is_video_possible(pjsua_call_id call_id)
{
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    return callInfo.setting.vid_cnt>0 && callInfo.rem_vid_cnt>0;
}

static bool is_audio_active(pjsua_call_id call_id)
{
    int mi = 0;
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    for (mi=0; mi<callInfo.media_cnt; ++mi)
        switch (callInfo.media[mi].type)
        {
            case PJMEDIA_TYPE_AUDIO:
                if(callInfo.media[mi].status == PJSUA_CALL_MEDIA_ACTIVE)
                    return true;
                break;
            default:
                /* Make gcc happy about enum not handled by switch/case */
                break;
        }

    return false;
}

static bool is_video_active(pjsua_call_id call_id)
{
    bool result=false;
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    int index = pjsua_call_get_vid_stream_idx(call_id);
    if(index<callInfo.media_cnt) {
        result = (callInfo.media[index].status == PJSUA_CALL_MEDIA_ACTIVE);
    }
    return result;
}

static bool remote_sdp_video_offer_accepted(pjsua_call_id call_id)
{
    return (call_setting.vid_cnt);
}

static bool is_remote_video_active(pjsua_call_id call_id)
{
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    return (callInfo.rem_vid_cnt>0);
}

static pjmedia_dir get_video_direction(pjsua_call_id call_id)
{
    pjmedia_dir dir = PJMEDIA_DIR_NONE;
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    int index = pjsua_call_get_vid_stream_idx(call_id);
    if(index<callInfo.media_cnt)
        if(callInfo.media[index].status == PJSUA_CALL_MEDIA_ACTIVE)
            dir = callInfo.media[index].dir;

    return dir;
}

static void log_audio_devices() {
    NSLog(@"Audio devices:");
    for(int i=0; i<pjmedia_aud_dev_count(); i++) {
        pjmedia_aud_dev_info info;
        if(pjmedia_aud_dev_get_info(i, &info) == PJ_SUCCESS) {
            NSLog(@"%d: %s (%s) (%d/%d)", i,  info.name, info.driver, info.input_count, info.output_count);
        }
    }
}

static void log_video_devices() {
    NSLog(@"Video devices:");
    for(int i=0; i<pjmedia_vid_dev_count(); i++) {
        pjmedia_vid_dev_info info;
        if(pjmedia_vid_dev_get_info(i, &info) == PJ_SUCCESS) {
            NSLog(@"%d: %s (%s) - %d", i, info.name, info.driver, info.dir);
            NSLog(@"Formats:");
            for (int j=0; j<info.fmt_cnt; ++j) {
                const pjmedia_video_format_info *vfi = pjmedia_get_video_format_info(NULL, info.fmt[j].id);
                NSLog(@"%d: %s [%d, %d]", j, vfi->name, vfi->bpp, vfi->plane_cnt);
            }
        }
    }
}

static void log_codec_params(int index, const char* name, pjmedia_vid_codec_param* params)
{
    NSLog(@"Codec name is %s", name);
    NSLog(@"MTU VALUE for codec #%d is %d", index, params->enc_mtu);
    NSLog(@"FrameSize for codec #%d is w:%d h:%d", index, params->enc_fmt.det.vid.size.w, params->enc_fmt.det.vid.size.h);
    NSLog(@"FPS for codec #%d is %d/%d", index, params->enc_fmt.det.vid.fps.num, params->enc_fmt.det.vid.fps.denum);
    NSLog(@"BandWidth VALUE for codec #%d is avg:%d max:%d", index, params->enc_fmt.det.vid.avg_bps, params->enc_fmt.det.vid.max_bps);
}

static pj_status_t search_first_active_call(pjsua_call_id* pcall_id)
{
    pj_status_t result = PJ_ERROR;
    static const int MAX_CALLS = 20;
    pjsua_call_id call_ids[MAX_CALLS];
    unsigned int num_calls = MAX_CALLS;
    if (pjsua_enum_calls(call_ids, &num_calls) == PJ_SUCCESS)
    {
        for(int i=0; i < num_calls && result != PJ_SUCCESS; i++)
        {
            pjsua_call_id call = call_ids[i];
            if(pjsua_call_is_active(call))
            {
                *pcall_id = call;
                result = PJ_SUCCESS;
            }
        }
    }
    return result;
}

static void stop_all_vid_previews()
{
    static const int MAX_DEVS = 10;
    pjmedia_vid_dev_info info_devs[MAX_DEVS];
    unsigned int num_devs = MAX_DEVS;
    if(pjsua_vid_enum_devs(info_devs, &num_devs) == PJ_SUCCESS)
    {
        for(int i=0; i<num_devs; i++)
        {
            pjmedia_vid_dev_info dev_info = info_devs[i];
            {
                pjsua_vid_preview_param vid_preview_param;
                pjsua_vid_preview_param_default(&vid_preview_param);
                //pjsua_vid_preview_start(dev_info.id, &vid_preview_param);
                pjsua_vid_preview_stop(dev_info.id);
            }
        }
    }
}

static pj_status_t set_video_stream(pjsua_call_id call_id, pjsua_call_vid_strm_op op, pjmedia_dir dir)
{
    pjsua_call_vid_strm_op_param param;
    pjsua_call_vid_strm_op_param_default(&param);

    param.med_idx = pjsua_call_get_vid_stream_idx(call_id);
    param.dir = dir;
    param.cap_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV;
     
    return pjsua_call_set_vid_strm(call_id, op, &param);
}

// HOOKED.

static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata)
{
    pjsua_call_answer2(call_id, &call_setting, 180, NULL, NULL);
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
/*
    RTCEventOptions *options = nil;
    if (rdata->msg_info.msg != NULL)
        options = RTCEventOptions_from_header(&rdata->msg_info.msg->hdr);
    RTCUser *from = [RTCUser userFromString:to_NSString(&callInfo.remote_info, NSASCIIStringEncoding)];
    [instance onIncomingSession:call_id 
                       fromUser:from
                    withOptions:options
                    isVideoCall:(current_call_has_video)? 1:0];*/
}


static void on_reg_state(pjsua_acc_id acc_id)
{
	pjsua_acc_info info;
    pjsua_acc_get_info(acc_id, &info);
//    [instance onRegStatus:info.status expires:info.expires];
}

static void on_reg_state2(pjsua_acc_id reg_acc_id, pjsua_reg_info *info)
{
    
}

static void on_call_state (pjsua_call_id call_id, pjsip_event *e)
{
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    
/*    RTCEventOptions *options = nil;
    if (e &&
        e->body.tsx_state.type == PJSIP_EVENT_RX_MSG &&
        e->body.tsx_state.src.rdata &&
        e->body.tsx_state.src.rdata->msg_info.len > 0 &&
        e->body.tsx_state.src.rdata->msg_info.msg)
    {
        options = RTCEventOptions_from_header(&e->body.tsx_state.src.rdata->msg_info.msg->hdr);
    }*/

    if(callInfo.state == PJSIP_INV_STATE_CALLING)
    {
        NSLog(@"Calling...");
        // Nothing to do
    }
    else if(callInfo.state == PJSIP_INV_STATE_INCOMING)
    {
        // Case when this is the user agent that receives an INVITE from another user agent
        NSLog(@"Receiving an INVITE...");

        current_call_has_video = is_video_possible(call_id);
        [client receivedIncomingCall:call_id];
    }
    else if(callInfo.state == PJSIP_INV_STATE_CONFIRMED)
    {
        NSLog(@"Call confirmed...");

        call_is_active = true;
        current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;

        //Every call has only audio media available until is stablished. At this point, both endpoints must enable the video media for possible video media request during call.
        setEnableVideoCall(true);
    }

    if(callInfo.state == PJSIP_INV_STATE_DISCONNECTED)
    {
/*        [instance onChangeSession:call_id
                        withState:[NSString stringWithCString:callInfo.state_text.ptr encoding:NSASCIIStringEncoding]
                          stateId:callInfo.state
                      isVideoCall:true
            startVideoImmediately:false
                       lastStatus:callInfo.last_status
                       andOptions:options];
*/
        // If call has been disconnected from remote part then the video flag (and others) must be set to false
        current_call_has_video = false;
        call_is_active = false;
        current_call_remote_video_dir = PJMEDIA_DIR_NONE;
        current_call_video_dir = PJMEDIA_DIR_NONE;

        setEnableVideoCall(false);

        // Print call stats
        char stats_string[5000];
        const char *indent_char = " ";

        pjsua_call_dump(call_id, PJ_TRUE, stats_string, 5000, indent_char);
        NSLog(@"STATS: (%s)", stats_string);
    }
    else
    {
/*        [instance onChangeSession:call_id
                        withState:[NSString stringWithCString:callInfo.state_text.ptr encoding:NSASCIIStringEncoding]
                          stateId:callInfo.state
                      isVideoCall:(current_call_has_video && this_client_started_direct_video_call)
            startVideoImmediately:false
                       lastStatus:callInfo.last_status
                       andOptions:options];*/
    }
}

static void on_call_media_state(pjsua_call_id call_id)
{
    pjsua_call_id current_call_id;
    pj_status_t status = search_first_active_call(&current_call_id);

    if(status != PJ_SUCCESS) {
        NSLog(@"Error searching first active call!");
        return;
    }

/*    if(call_id != current_call_id) {
        NSLog(@"Different call identifier detected!");
        return;
    }*/
    
    // When media is active, connect call to sound device.
    pjsua_call_info callInfo;
    pjsua_call_get_info(call_id, &callInfo);
    if (callInfo.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        
        pjsua_conf_connect(callInfo.conf_slot, 0);
        pjsua_conf_connect(0, callInfo.conf_slot);
    }

    // if the call request is launched with video and the call state is confirmed then media state procedure can be checked
/*    if((callInfo.state != PJSIP_INV_STATE_CONFIRMED))
        return;*/

    if(is_video_active(call_id) || is_remote_video_active(call_id))
    {
        // Setup the current h.263+ configuration
        setup_video_codec_params();

        // Start video stream
        set_video_stream(call_id, PJSUA_CALL_VID_STRM_START_TRANSMIT, PJMEDIA_DIR_NONE);

        [client videoStreamStartTransmiting:call_id];
    }
    else
    {
        stop_all_vid_previews();
    }
}

void on_call_rx_offer(pjsua_call_id call_id, const pjmedia_sdp_session *offer, void *reserved, pjsip_status_code *code, pjsua_call_setting *opt)
{
    bool sdp_video_offer_accepted = false;

    // We will accept only video codec H263+
    int accepted_fmt_video_codec_id = 96; // Accepted video codec | 96 => H263-1998/90000

    //By default video media is disabled
    opt->vid_cnt = 0; //Video must be disabled until the offer received is accepted
    opt->aud_cnt = 1; //Audio is allways enabled

    pj_str_t video_media_type = {"video", 5};
    pj_str_t video_transport_type = {"RTP/AVP", 7};

    // At this point we received an sdp offer from the remote call endpoint
    // So, we have to check every media in the sdp and determine if we are able to run the media with the apropiate specs
    int i=0;
    for(i=0; i<offer->media_count; i++)
    {
        pjmedia_sdp_media *media = offer->media[i];

        // If media offer has video
        if((pj_strcmp(&media->desc.media, &video_media_type) == 0) && (media->desc.port > 0) && (pj_strcmp(&media->desc.transport, &video_transport_type) == 0))
        {
            //At this point we have to check if the video media specs in the offer are compatible with our specs
            int fmt_index=0;
            char fmt_string[150];

            for(fmt_index=0; fmt_index < media->desc.fmt_count; fmt_index++)
            {
                strncpy(fmt_string, media->desc.fmt[fmt_index].ptr, media->desc.fmt[fmt_index].slen);
                fmt_string[media->desc.fmt[fmt_index].slen] = '\0';

                // If our app supports h263+ codec and the app is active then we have to accept the sdp offer
                if(([[NSString stringWithCString:fmt_string encoding:NSASCIIStringEncoding] intValue] == accepted_fmt_video_codec_id)
                    && ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive))
                {
                    NSLog(@"*** SDP video offer accepted ***");
                    sdp_video_offer_accepted = true; // Remote client is sending us a valid video media offer and app is active, so we accept it
                }

                if(sdp_video_offer_accepted)
                    break;
            }

            // If the video offer has been accepted then the next step is to get the video direction to setup the local machine state
            if(sdp_video_offer_accepted)
            {
                NSLog(@"*** SDP video offer accepted. Checking media direction. ***");

                //At this point we have to check the attributes assigned to the video media. Basicaly the media direction of the remote client
                int attr_index=0;
                char attr_name_string[255];
                char attr_value_string[255];
                bool video_direction_in_sdp = false; //There are cases when there are no video direction described in the SDP

                for(attr_index=0; (attr_index < media->attr_count) && (sdp_video_offer_accepted); attr_index++)
                {
                    strncpy(attr_name_string, media->attr[attr_index]->name.ptr, media->attr[attr_index]->name.slen);
                    attr_name_string[media->attr[attr_index]->name.slen] = '\0';
                    strncpy(attr_value_string, media->attr[attr_index]->value.ptr, media->attr[attr_index]->value.slen);
                    attr_value_string[media->attr[attr_index]->value.slen] = '\0';

                    NSString *attr_name_nsstring = [NSString stringWithCString:attr_name_string encoding:NSASCIIStringEncoding];

                    video_direction_in_sdp = true;

                    if([attr_name_nsstring isEqualToString:@"sendonly"])
                    {
                        current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                        current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                    }
                    else if([attr_name_nsstring isEqualToString:@"sendonly"])
                    {
                        // The requester only wants to send video
                        current_call_remote_video_dir = PJMEDIA_DIR_ENCODING;
                        current_call_video_dir = PJMEDIA_DIR_DECODING;
                    }
                    else if([attr_name_nsstring isEqualToString:@"recvonly"])
                    {
                        // The requester only wants to receive video
                        current_call_remote_video_dir = PJMEDIA_DIR_DECODING;
                        current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                    }
                    else    video_direction_in_sdp = false;

                    //NSLog(@"Attribute name (%s) | Value (%s)", attr_name_string, attr_value_string);
                }
            }
            else
            {
                // If video SDP offer is rejected then both video directions must be set to PJMEDIA_DIR_NONE
                current_call_remote_video_dir = PJMEDIA_DIR_NONE;
                current_call_video_dir = PJMEDIA_DIR_NONE;
                current_call_has_video = false;
            }

        }
    }

    // The video media will be accepted if sdp video offer was accepted
    opt->vid_cnt = sdp_video_offer_accepted ? 1 : 0;

    // Case when we are in video call mode and the remote user wants to switch to audio mode
    if((current_call_has_video) && (!sdp_video_offer_accepted))
    {
        // Disable video mode
        setEnableVideoCall(false);
        current_call_video_dir = PJMEDIA_DIR_NONE; /* PJMEDIA_DIR_ENCODING; */
        current_call_remote_video_dir = PJMEDIA_DIR_NONE; /* PJMEDIA_DIR_DECODING; */
        current_call_has_video = false;
    }
}

void setup_video_codec_params(void)
{
    //Set Video Codec Parameters before this starts transmitting

    pj_str_t h263_codec_id = {"H263-1998/96", 12};      //pj_str("H263-1998/96");
    pjsua_vid_codec_set_priority(&h263_codec_id, 2);

    pjsua_codec_info vid_codec_ids[32];
    unsigned int vid_codec_count=PJ_ARRAY_SIZE(vid_codec_ids);

    pjsua_vid_enum_codecs(vid_codec_ids, &vid_codec_count);
    
    //For every codec
    for(int i=0;i<vid_codec_count; i++){
        
        pjmedia_vid_codec_param codec_param;
        
        //Get Configuration from codec in codecs list
        pj_status_t status_codec_get_params = pjsua_vid_codec_get_param(&(vid_codec_ids[i].codec_id), &codec_param);
        if(status_codec_get_params != PJ_SUCCESS)
        {
            NSLog(@"pjsua_vid_codec_get_param Failed!");
        }

        //MTU max value needs to be controlled to TEF router limits.
        codec_param.enc_mtu=1200;
        
        //Set Size
        codec_param.enc_fmt.det.vid.size.w = 352; //176; //352;
        codec_param.enc_fmt.det.vid.size.h = 288; //144; //288;

        codec_param.dec_fmt.det.vid.size.w = 352; //176; //352;
        codec_param.dec_fmt.det.vid.size.h = 288; //144; //288;

        codec_param.dec_fmtp.cnt = 2;
        codec_param.dec_fmtp.param[0].name = pj_str("CIF");     //pj_str("QCIF");    // 1st preference: 176 x 144 (QCIF)
        codec_param.dec_fmtp.param[0].val = pj_str("2");        // 30000/(1.001*3) fps for QCIF

        codec_param.dec_fmtp.param[1].name = pj_str("MaxBR");
        codec_param.dec_fmtp.param[1].val = pj_str("5120");     //5120 // 2560 //1920 // = max_bps / 100

/*        codec_param.dec_fmtp.param[2].name = pj_str("BPP");
        codec_param.dec_fmtp.param[2].val = pj_str("6554");     //65536*/

        // Set FPS.
        codec_param.enc_fmt.det.vid.fps.num   = 15000; //15000;
        codec_param.enc_fmt.det.vid.fps.denum = 1001; //1001;
        codec_param.dec_fmt.det.vid.fps.num   = 15000; //15000;
        codec_param.dec_fmt.det.vid.fps.denum = 1001; //1001;

        // Set Bandwidth.
        codec_param.enc_fmt.det.vid.avg_bps = 256000; //144000; //192000; //144000
        codec_param.enc_fmt.det.vid.max_bps = 512000; //256000; //192000
        codec_param.dec_fmt.det.vid.avg_bps = 256000; //144000; //192000; //144000
        codec_param.dec_fmt.det.vid.max_bps = 512000; //192000; //X256000; //192000

        // Set Configuration to codec in codecs list.
        pj_status_t status_codec_set_params = pjsua_vid_codec_set_param(&(vid_codec_ids[i].codec_id), &codec_param);
        if(status_codec_set_params != PJ_SUCCESS)
        {
            NSLog(@"pjsua_vid_codec_set_param Failed!");
        }
    }
}

static void on_pager_status2 (pjsua_call_id call_id, const pj_str_t *to, const pj_str_t *body, 
                              void *user_data, pjsip_status_code status, const pj_str_t *reason, 
                              pjsip_tx_data *tdata, pjsip_rx_data *rdata, pjsua_acc_id acc_id)
{
/*
    @autoreleasepool {
        RTCUser *toUser = [RTCUser userFromString:to_NSString(to, NSASCIIStringEncoding)];
        RTCEventOptions *options = nil;
        if (rdata != NULL &&
            rdata->msg_info.msg != NULL)
            options = RTCEventOptions_from_header(&rdata->msg_info.msg->hdr);
        NSString *messageId = [NSString stringWithCString:(const char*)user_data encoding:NSASCIIStringEncoding];
        free(user_data);

        [instance onMessageStatus:status ofMessageId:messageId to:toUser withOptions:options];
    }
*/
}
/*
static RTCEventOptions *RTCEventOptions_from_header(const pjsip_hdr *header)
{
    if (header == NULL) return nil;
    
    RTCEventOptions * retValue = [[RTCEventOptions alloc] init];
    pjsip_generic_string_hdr *string_hdr = (pjsip_generic_string_hdr*) header;
    do {
        if (string_hdr->type == PJSIP_H_OTHER) {
            NSString * header_key = to_NSString(&string_hdr->name, NSUTF8StringEncoding);
            if (header_key != nil && [RTCEventOptions knownHeaderString:header_key]) {
                NSString * header_value = to_NSString(&string_hdr->hvalue, NSUTF8StringEncoding);

                if (header_value != nil)
                {
                    [retValue setValue:header_value forKey:header_key];
                }
            }
        }
        string_hdr = string_hdr->next;
    } while ((pjsip_hdr*)string_hdr != header && 
             string_hdr != NULL);
    
    return retValue;
}
*/
static void on_pager2(pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, const pj_str_t *contact, const pj_str_t *mime_type, const pj_str_t *body, pjsip_rx_data *rdata, pjsua_acc_id acc_id)
{
/*
    @autoreleasepool {   
        NSString *fromString = to_NSString(from, NSUTF8StringEncoding);
        NSString *toString = to_NSString(to, NSUTF8StringEncoding);
        NSString *mimeTypeString = to_NSString(mime_type, NSUTF8StringEncoding);
        NSString *bodyString = to_NSString(body, NSUTF8StringEncoding);
        
        RTCUser *fromUser = [RTCUser userFromString:fromString];
        RTCUser *toUser = [RTCUser userFromString:toString];
        RTCEventOptions *options = nil;
        if (rdata->msg_info.msg != NULL)
            options = RTCEventOptions_from_header(&rdata->msg_info.msg->hdr);

        CNCMessageParser *parser = [[CNCMessageParser alloc] init];        
        CNCMessageType type = [parser messageTypeFromContentString:mimeTypeString];

        if (type == kMessageTypeMedia)
        {
            if ([options.type isEqualToString:@"image"])
            {
                CNCMessagePhotoInfo *photoInfo = [parser parsePhotoMessage:bodyString];
                if (photoInfo)
                {
                    [instance onPhotoFrom:fromUser 
                                       to:toUser 
                                photoSize:[photoInfo.size intValue] 
                            photoMimeType:photoInfo.mimetype 
                             photoCaption:photoInfo.caption 
                           photoThumbnail:photoInfo.thumbnail 
                              withOptions:options 
                             andRemoteUri:photoInfo.uri];
                }
            }
            else if ([options.type isEqualToString:@"audio"])
            {
                CNCMessageRecordingInfo *recInfo = [parser parseRecordingMessage:bodyString];
                
                if (recInfo)
                {                
                    [instance onRecordingFrom:fromUser 
                                           to:toUser 
                            recordingMimeType:recInfo.mimetype 
                                     duration:recInfo.duration 
                                  withOptions:options 
                                 andRemoteUri:recInfo.uri];
                }
            }
        }
        else if (type == kMessageTypeLocation)
        {
            CNCMessageLocationInfo *locInfo = [parser parseLocationMessage:bodyString];
            
            if(locInfo)
            {
                RTCGeoPosition * geoposition = [RTCGeoPosition geoPositionWithString:locInfo.coordinates];
                geoposition.address = locInfo.address;
                [instance onLocationFrom:fromUser to:toUser geoPosition:geoposition withOptions:options];
            }
        }
        else if (type == kMessageTypeContact)
        {
            [instance onContactFrom:fromUser to:toUser contactInfo:bodyString withOptions:options];
        }
        else if (type == kMessageTypeDelivery)
        {
            CNCMessageDeliveryStatusInfo *dInfo = [parser parseDeliveryStatusMessage:bodyString];
            if (dInfo)
            {                
                options.remoteId = dInfo.uri;
                [instance onDeliveryStatusFrom:fromUser 
                                            to:toUser 
                                       eventId:nil 
                                     delivered:dInfo.delivered 
                                     displayed:dInfo.displayed 
                                   withOptions:options];
            }
        }
        else if (type == kMessageTypeMessage)
        {            
            [instance onMessageFrom:fromUser to:toUser messageBody:bodyString withOptions:options];
        }
        else
        {   
            NSString *mimeType = to_NSString(mime_type, NSUTF8StringEncoding);
            DLog(@"Unknown message type received: %@",  mimeType);
        }
        
    }
*/
}

void on_typing (pjsua_call_id call_id, const pj_str_t *from, const pj_str_t *to, const pj_str_t *contact, pj_bool_t is_typing)
{
/*
    RTCUser *fromUser = [RTCUser userFromString:to_NSString(from, NSASCIIStringEncoding)];
    if (is_typing)
    {
        [instance onTypingStart:fromUser];
    }
    else
    {
        [instance onTypingStop:fromUser];
    }
*/
}

int videocall(char* user)
{
    char sip_uri[255];
    sprintf(sip_uri, "<sip:%s@smsturmix.com>", user);

    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
    pj_str_t callee = pj_str((char*)sip_uri);
    pjsua_call_id call_id;
    pj_status_t status;

    current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
    current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;

    setEnableVideoCall(true);

    call_setting.vid_cnt = 1;
    call_setting.aud_cnt = 1;

    status = pjsua_call_make_call(acc_id, &callee, &call_setting, NULL, &messageData, &call_id);

    return (status == PJ_SUCCESS)? call_id: PJ_ERROR;
}

/*
//int call(const char* callId, RTCEventOptions * options, bool isVideoCall)
int call(const char* callId, bool isVideoCall)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
//    add_optional_headers(&messageData, options);
    pj_str_t callee = pj_str((char*)callId);
    pjsua_call_id call_id;
    pj_status_t status;


    // The following flag only indicates if the current call has direct video
    call_request_started_with_video = isVideoCall;

    // If this client wants to make a call with direct video then the following flag must be set to True
    this_client_started_direct_video_call = isVideoCall;

    if(isVideoCall)
    {
        current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
        current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;

        setEnableVideoCall(true);
    }

    call_setting.vid_cnt = video_call_enabled ? 1 : 0; //video_call_enabled;
    call_setting.aud_cnt = audio_call_enabled;

    status = pjsua_call_make_call(acc_id, &callee, &call_setting, NULL, &messageData, &call_id);

    return (status == PJ_SUCCESS)? call_id: PJ_ERROR;
}
*/
static pj_status_t create_transport()
{
    return pjsua_transport_create(PJSIP_TRANSPORT_TCP, &tp_cfg, &tp_id);

/*
    pj_status_t status = PJ_ERROR;
    
    pjsua_transport_config_default(&tp_cfg);

    if (instance.accountConfiguration.transportType == accountConfigTransportTLS)
        status = pjsua_transport_create(PJSIP_TRANSPORT_TLS, &tp_cfg, &tp_id);
    else if (instance.accountConfiguration.transportType == accountConfigTransportTCP)
        status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &tp_cfg, &tp_id);
    else
        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &tp_cfg, &tp_id);


    if(status != PJ_SUCCESS) {
        printf("Error assignant el tipus de transport!");
    }

    return status;
*/
}

static void log_cb(int level, const char *data, int len)
{
    NSLog(@"pj_log %@", [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding]);
}

void main_pjsip(KPDClientSIP *clientSip, char* user, char* password, char* userAgent)
{
    pj_status_t status;    
    status = pjsua_create();

    client = clientSip;

    videoDeviceView = [[KPDVideoDeviceView alloc] init];

    if( status != PJ_SUCCESS) {
        printf("Error initializing pjsua");
        return;
    }

    pjsua_config cfg;
    pjsua_logging_config log_cfg;

    pjsua_config_default(&cfg);
    cfg.cb.on_incoming_call = &on_incoming_call;
    cfg.cb.on_reg_state = &on_reg_state;
    cfg.cb.on_call_state = &on_call_state;
    cfg.cb.on_call_media_state = &on_call_media_state;
    cfg.cb.on_call_rx_offer = &on_call_rx_offer;
    cfg.cb.on_pager2 = &on_pager2;
    cfg.cb.on_pager_status2 = &on_pager_status2;
    cfg.cb.on_typing = &on_typing;
    cfg.cb.on_reg_state2 = &on_reg_state2;

    if (userAgent != NULL) {
        cfg.user_agent = pj_str((char*) userAgent);
    }

    pjsua_logging_config_default(&log_cfg);
    log_cfg.level = PJSIP_LOG_LEVEL;
    log_cfg.console_level = PJSIP_LOG_LEVEL;
    log_cfg.cb = &log_cb;
    log_cfg.msg_logging = PJSIP_LOG_ENABLED;

    pjsua_media_config media_config;
    pjsua_media_config_default(&media_config);
    media_config.vid_preview_enable_native = PJ_TRUE;

    //media_config.jb_max = -1; //this should be able to set the máximum jitter buffer size (max jb) Could help reduce chopiness on video -> Current default (with -1 value) is 500 ms, we should test 750 in troubled network conditions in order to see if there is improvement.
    //media_config.jb_max_pre = -1;   //this should be able to set the máximum prefetch for jitter buffer (max num of frames) Could help reduce chopiness on video. Automatic default if not set is jb_max * 4 / 5

    //Set the STUN server
/*    cfg.stun_host = pj_str("stunserver.org");
    cfg.stun_srv[0] = pj_str("stun.l.google.com:19302");
    cfg.stun_srv[1] = pj_str("stun.ipns.com");
    cfg.stun_srv[2] = pj_str("stun.endigovoip.com");
    cfg.stun_srv[3] = pj_str("stun.rnktel.com");
    cfg.stun_srv[4] = pj_str("stun.voip.aebc.com");
    cfg.stun_srv[5] = pj_str("stun.callwithus.com");
    cfg.stun_srv_cnt = 6;*/

    status = pjsua_init(&cfg, &log_cfg, &media_config);

    if(status != PJ_SUCCESS) {
        printf("Error pjsua_init()"); return;
    }

    pjsua_transport_config_default(&tp_cfg);
    tp_cfg.port = 0;

    status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &tp_cfg, NULL);
    if (status != PJ_SUCCESS) {
        NSLog(@"Error creant transport TCP");
    }

    pjsua_acc_config_default(&acc_cfg);
    pjsua_call_setting_default(&call_setting);

    char sip_uri[255];
    sprintf(sip_uri, "<sip:%s@smsturmix.com>", user);

    acc_cfg.id = pj_str((char*)sip_uri);
    acc_cfg.reg_uri = pj_str((char*) ("sip:smsturmix.com"));
    acc_cfg.cred_count = 1;
    acc_cfg.cred_info[0].realm = pj_str((char*)"*");
    acc_cfg.cred_info[0].scheme = pj_str((char*)"digest");
    acc_cfg.cred_info[0].username = pj_str((char*)user);
    acc_cfg.cred_info[0].data = pj_str((char*)password);

    acc_cfg.proxy[acc_cfg.proxy_cnt++] = pj_str((char*)"<sip:smsturmix.com;transport=tcp>");

    pj_str_t h263_codec_id = {"H263-1998/96", 12};
    pjsua_vid_codec_set_priority(&h263_codec_id, 2);

    setup_video_codec_params();

    acc_cfg.vid_in_auto_show = PJ_FALSE;
    acc_cfg.vid_out_auto_transmit = PJ_FALSE;
    acc_cfg.vid_rend_dev = PJMEDIA_VID_DEFAULT_RENDER_DEV;

    call_setting.vid_cnt = 1; //1 => hasVideo | 0 => hasNoVideo
    call_setting.aud_cnt = 1; //1 => hasAudio | 0 => hasNoAudio

    status = pjsua_acc_add(&acc_cfg, PJ_TRUE, &acc_id);
    if ( status != PJ_SUCCESS ) {
        pj_perror(3, "pjsip", status, "Error Registering");
    }

    status = pjsua_start();
    if(status != PJ_SUCCESS) {
        printf("Error pjsua_start()"); return;
    }
}

// stream views setup
bool setOutgoingVideoStreamViewFrame(CGRect rect)
{
    [videoDeviceView setPreviewFrame:rect];

    return true;
}

bool setIngoingVideoStreamViewFrame(CGRect rect)
{
    [videoDeviceView setFrame:rect];

    return true;
}

void setVideoStreamViewFrame(CGRect rect)
{
    [videoDeviceView.view setFrame:rect];
}

// getting stream views
UIView* getOutgoingVideoStreamView(void)
{
    return [videoDeviceView getPreviewView];
}

UIView* getIngoingVideoStreamView(void)
{
    return [videoDeviceView videoView];
}

UIView* getVideoStreamView(void)
{
    return [videoDeviceView view];
}

bool acceptVideoCallRequest(void)
{
    // The following flag indicates that the user agent will send and receive video frames (it will cause to show the videocall views window)
    current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
    current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;

    // Lets begin start encode and send frames
    startVideoStream();

    return true;
}

bool rejectVideoCallRequest(void)
{
    bool result = false;

    pjsua_call_id current_call_id;
    search_first_active_call(&current_call_id);

    // We received a video call request but we want still continue with audio call mode and receive and show remote video.
    if(set_video_stream(current_call_id, PJSUA_CALL_VID_STRM_CHANGE_DIR, PJMEDIA_DIR_DECODING) == PJ_SUCCESS)
    {
        current_call_has_video = true;
        current_call_video_dir = PJMEDIA_DIR_DECODING;
        current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
        result = true;
    }

    return result;
}

// enable/disable capture notifications from video driver
bool setEnableVideoDriver(bool v)
{
    // Enable/Disable capture notifications from driver
    setEnableReceiveNotificationsFromVideoDriver(v);

    // Hide/init video views
    if(v)
    {
         [videoDeviceView initializeView];
    }
    else
    {
         [videoDeviceView releaseDeviceView];
    }

    return true;
}

bool setEnableReceiveNotificationsFromVideoDriver(bool v)
{
    if(v)
    {
        [videoDeviceView startNotificationListeners];
    }
    else
    {
        [videoDeviceView stopNotificationListeners];
    }

    return true;
}

// Show/hide out stream views.
bool setOutgoingVideoStreamViewHidden(bool v)
{
    NSMutableDictionary *userInfoOutgoingVideoStreamViewHidden = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:v], @"hidden", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setOutgoingVideoStreamViewHidden" object:nil userInfo:userInfoOutgoingVideoStreamViewHidden];

    return true;
}

// Show/hide in stream views.
bool setIngoingVideoStreamViewHidden(bool v)
{
    NSMutableDictionary *userInfoIngoingVideoStreamViewHidden = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:v], @"hidden", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setIngoingVideoStreamViewHidden" object:nil userInfo:userInfoIngoingVideoStreamViewHidden];

    return true;
}

// Enable/disable outgoing video streams, causing streams renegotiation through RE-INVITEs.
bool setEnableOutgoingVideoStream(pjsua_call_id call_id, bool v)
{
    bool result = false;
    if((call_id>=0) || (search_first_active_call(&call_id) == PJ_SUCCESS))
    {
        // Check if a video stream is present in the call.
        if (pjsua_call_get_vid_stream_idx(call_id) < 0) {
            return false;
        }

        // Get video state.
        pj_bool_t running = pjsua_call_vid_stream_is_running(call_id, -1, PJMEDIA_DIR_ENCODING_DECODING);
        running = running || pjsua_call_vid_stream_is_running(call_id, -1, PJMEDIA_DIR_ENCODING);
        running = running || pjsua_call_vid_stream_is_running(call_id, -1, PJMEDIA_DIR_DECODING);

        // Already enabled or disabled.
        if(v && running == PJ_TRUE)
        {
            // We are participating in a videocall (as an ENCODER or DECODER or ENCODER_DECODER)
            // If we are in DECODER mode (only audio) then we have to set our video direction to ENCODER_DECODER and START sending frames
    
            if(current_call_video_dir == PJMEDIA_DIR_DECODING)
            {
                    current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                    result = set_video_stream(call_id, PJSUA_CALL_VID_STRM_CHANGE_DIR, current_call_video_dir) == PJ_SUCCESS;
            }else   result = true;
        }
        else if(!v && running == PJ_FALSE)
        {
            // We want to disable video but there is no video streaming.
            result = true;
        }
        else
        {
            // First of all video media must be enabled
            setEnableVideoCall(true);

            // Set direction as needed.
            pjmedia_dir dir = v? PJMEDIA_DIR_ENCODING_DECODING: PJMEDIA_DIR_NONE;

            if((!v) && (current_call_remote_video_dir == PJMEDIA_DIR_DECODING))
            {
                // We are in a video call and we want to switch to audio.
                // If the remote part is already in audio mode (m=video a=recvonly) then the video stream must be removed
                set_video_stream(call_id, PJSUA_CALL_VID_STRM_REMOVE, PJMEDIA_DIR_NONE);
                current_call_video_dir = PJMEDIA_DIR_NONE;
                current_call_remote_video_dir = PJMEDIA_DIR_NONE;
                current_call_has_video = false; // Call session will have only audio media, then the current_call_has_video flag must be disabled

                result = true;
            }
            else if((!v) && (set_video_stream(call_id, PJSUA_CALL_VID_STRM_CHANGE_DIR, PJMEDIA_DIR_DECODING) == PJ_SUCCESS))
            {
                // We are in a video call and we want to switch to audio (SEND request to remote user)
                current_call_video_dir = PJMEDIA_DIR_DECODING; /*PJMEDIA_DIR_NONE*/;

                result = true;
            }
            else if((v) && (set_video_stream(call_id, PJSUA_CALL_VID_STRM_CHANGE_DIR, dir) == PJ_SUCCESS))
            {
                // Change from audio call to video call request (SEND request to remote user)
                current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                current_call_has_video = true;

                result = true;
            }
            else if(v)
            {
                // Received an incoming video call request
                current_call_video_dir = PJMEDIA_DIR_DECODING;

                result = true;
            }
        }
    }
    return result;
}

// Get state of the outgoing video stream.
bool getStateOutgoingVideoStream(pjsua_call_id call_id)
{
    bool result = false;
    if((call_id>=0) || (search_first_active_call(&call_id) == PJ_SUCCESS)) {
        // Return video state.
        result = pjsua_call_vid_stream_is_running(call_id, -1, PJMEDIA_DIR_ENCODING_DECODING);
    }
    return result;
}

// Set local video paused.
// Not tested: use with caution.
bool setOnHoldVideoStream(int call_id, bool isOnHold)
{
    /* marina: PJSUA_CALL_VID_STRM_STOP_TRANSMIT and PJSUA_CALL_VID_STRM_START_TRANSMIT: only operate in local stream (tx)
     PJ_DECL(pj_status_t) pjmedia_vid_stream_pause(pjmedia_vid_stream *stream, pjmedia_dir dir); and
     pjmedia_vid_stream_resume(pjmedia_vid_stream *stream, pjmedia_dir dir)
    */
    bool result=false;
    if(isOnHold)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pausePreview" object:nil userInfo:nil];
        result = set_video_stream(call_id, PJSUA_CALL_VID_STRM_STOP_TRANSMIT, PJMEDIA_DIR_NONE) == PJ_SUCCESS;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumePreview" object:nil userInfo:nil];
        result = set_video_stream(call_id, PJSUA_CALL_VID_STRM_START_TRANSMIT, PJMEDIA_DIR_NONE) == PJ_SUCCESS;
    }
    return result;

}

// Get paused video state.
bool getOnHoldVideoStatefromCall(int call_id)
{
    // Looking at the pjsua/pjmedia API, it is not clear if there is a method to check if stream is paused.
    // pjsua_call_vid_stream_is_running seems to return if stream is created and started,and not being paused
    
    // so using PJSUA_CALL_VID_STRM_STOP_TRANSMIT to pause stream may break setEnableOutgoingVideoStream.
    // This needs to be researched performing tests.
    return pjsua_call_vid_stream_is_running(call_id, -1, PJMEDIA_DIR_ENCODING_DECODING) == false;

}

// retrieve/set devices
NSArray * getVideoDevices(void)
{
    NSMutableArray *tmp_video_devices = [[NSMutableArray alloc] init];

    NSArray *devices = [AVCaptureDevice devices];

    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            KPDVideoDevice *yarn_video_device = [[KPDVideoDevice alloc] init];

            [yarn_video_device setDeviceId:[device uniqueID]];
            [yarn_video_device setDeviceName:[device localizedName]];

            if([device position] == AVCaptureDevicePositionFront)       [yarn_video_device setDeviceType:YARN_FRONT_VIDEO_DEVICE];
            else if([device position] == AVCaptureDevicePositionBack)   [yarn_video_device setDeviceType:YARN_BACK_VIDEO_DEVICE];
            else                                                        [yarn_video_device setDeviceType:YARN_UNKNOWN_VIDEO_DEVICE];

            //If video device ID has content then we store it
            if(![[yarn_video_device deviceId] isEqualToString:@""])
                [tmp_video_devices addObject:yarn_video_device];
        }
    }

    return [[NSArray alloc] initWithArray:tmp_video_devices];
}

int getVideoDevicesCount(void)
{
    int video_devices_count = 0;
    NSArray *devices = [AVCaptureDevice devices];

    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            //If video device ID has content then we count it
            if(![[device uniqueID] isEqualToString:@""])
                video_devices_count++;
        }
    }

    return video_devices_count;
}

KPDVideoDevice* getDefaultFrontVideoDevice(void)
{
    NSArray *video_devices = getVideoDevices();
    for(int i=0; i<[video_devices count]; i++)
        if([[video_devices objectAtIndex:i] deviceType] == YARN_FRONT_VIDEO_DEVICE)
            return [video_devices objectAtIndex:i];
    return nil;
}

KPDVideoDevice* getDefaultBackVideoDevice(void)
{
    NSArray *video_devices = getVideoDevices();
    for(int i=0; i<[video_devices count]; i++)
        if([[video_devices objectAtIndex:i] deviceType] == YARN_BACK_VIDEO_DEVICE)
            return [video_devices objectAtIndex:i];
    return nil;
}

bool setOutgoingVideoStreamDevice(KPDVideoDevice *yvd)
{
    NSMutableDictionary *userInfoOutgoingVideoStreamDevice = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[yvd deviceId], @"deviceUniqueID", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setOutgoingVideoStreamDevice" object:nil userInfo:userInfoOutgoingVideoStreamDevice];

    return true;
}

// enable/disable video/audio before start call
bool setEnableVideoCall(bool v)
{
    pjsua_call_setting_default(&call_setting);
    call_setting.vid_cnt = v ? 1 : 0; // 1 => hasVideo | 0 => hasNoVideo

//    instance.video_call_enable = video_call_enabled ? 1 : 0; //video_call_enabled;

    return true;
}

bool setEnableAudioCall(bool v)
{
    pjsua_call_setting_default(&call_setting);
    call_setting.aud_cnt = v ? 1 : 0; //1 => hasAudio | 0 => hasNoAudio

    return true;
}

// start/stop video streams after call stablished
bool startVideoStream(void)
{
    pjsua_call_id current_call_id;
    search_first_active_call(&current_call_id);

    return (set_video_stream(current_call_id, PJSUA_CALL_VID_STRM_START_TRANSMIT, PJMEDIA_DIR_NONE) == PJ_SUCCESS);
}

BOOL is_connected()
{
    pjsua_acc_info info;
    if (pjsua_acc_is_valid(acc_id))
    {
        pjsua_acc_get_info(acc_id, &info);
        if (info.status >= 200 && info.status <= 200)
            return true;
    }
    return false;
}

pj_str_t strdup_in_pool(pj_pool_t* pool, const char* srcstr)
{
    pj_str_t temp_str = pj_str((char*)srcstr);    
    pj_str_t dup_str;
    pj_strdup(pool, &dup_str, &temp_str);
    return dup_str;
}

int acc_add(const char* regUriString, const char* proxyString, const char * userUriString,
                  const char* userString, const char* passwordString, int *accountId)
{
    return PJ_OK;

    pj_status_t status;
    pjsua_acc_config_default(&acc_cfg);
    
    pjsua_call_setting_default(&call_setting);

    pjsua_acc_config acc_cfg;
    pjsua_acc_config_default(&acc_cfg);
    acc_cfg.id = pj_str( (char*)"<sip:silvia@smsturmix.com>");
    acc_cfg.reg_uri = pj_str((char*) ("sip:smsturmix.com"));
    acc_cfg.cred_count = 1;
    acc_cfg.cred_info[0].realm = pj_str((char*)"*");
    acc_cfg.cred_info[0].scheme = pj_str((char*)"digest");
    acc_cfg.cred_info[0].username = pj_str((char*)"silvia");
    acc_cfg.cred_info[0].data = pj_str((char*)"silvia");
    
    acc_cfg.proxy[acc_cfg.proxy_cnt++] = pj_str((char*) "<sip:smsturmix.com;transport=tcp>");

    pj_str_t h263_codec_id = {"H263-1998/96", 12};      //pj_str("H263-1998/96");
    pjsua_vid_codec_set_priority(&h263_codec_id, 2);

    setup_video_codec_params();

    acc_cfg.vid_in_auto_show = PJ_FALSE;
    acc_cfg.vid_out_auto_transmit = PJ_FALSE;
    acc_cfg.vid_rend_dev = PJMEDIA_VID_DEFAULT_RENDER_DEV;

    call_setting.vid_cnt = 1; // 1 => hasVideo | 0 => hasNoVideo
    call_setting.aud_cnt = 1; // 1 => hasAudio | 0 => hasNoAudio

    status = pjsua_acc_add(&acc_cfg, PJ_TRUE, &acc_id);
    if ( status != PJ_SUCCESS ) { 
        pj_perror(3, "pjsip", status, "Error Registering");
        return PJ_ERROR;    
    }

    return PJ_OK;
}

int acc_del() 
{
    int status = pjsua_acc_del(acc_id);
    if ( status != PJ_SUCCESS ) { 
        pj_perror(3, "pjsip", status, "Error Registering");
        return PJ_ERROR;    
    }
    
    return PJ_OK;
}

void add_header(pjsua_msg_data * messageData, const char * headerKey, const char *headerValue)
{
    pjsip_endpoint *endpt = pjsua_get_pjsip_endpt();
    if (endpt != NULL)
    {
        pj_pool_t *pool = pjsip_endpt_create_pool(endpt, "Location Header", 100, 100);
        if (pool != NULL)
        {
            pj_str_t hname = strdup_in_pool(pool, headerKey);
            pj_str_t hvalue = strdup_in_pool(pool, headerValue);
            pjsip_generic_string_hdr * locationHeader = pjsip_generic_string_hdr_create(pool, &hname, &hvalue);
            if (locationHeader != NULL && messageData != NULL) 
                pj_list_push_back(&messageData->hdr_list, locationHeader);
        }
    }
}

const char * get_charstr_from_value(id value)
{
    if (CFGetTypeID((__bridge CFBooleanRef)value) == CFBooleanGetTypeID())
    {
        if (CFBooleanGetValue((__bridge CFBooleanRef)value))
            return "on";
        return "off";
    }
    return [[value description] cStringUsingEncoding:NSUTF8StringEncoding];
}
/*
void add_optional_headers(pjsua_msg_data * messageData, RTCEventOptions * options)
{
    if (options == nil) return;
    
    for (NSString * key in [options allKeys])
    {
        id value = [options valueForKey:key];
        if (value != nil)
        {
            const char * headerKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
            const char * headerValue = get_charstr_from_value(value);
            add_header(messageData, headerKey, headerValue);
        }
    }
}

pj_status_t send_message_mime_type(const char *toString, const char *messageId, 
                                   const char *messageBody, const char *mimeType, RTCEventOptions * options)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
    pjsip_endpoint * endpt = pjsua_get_pjsip_endpt();
    pj_pool_t * pool = pjsip_endpt_create_pool(endpt, "Location Header", 100, 100);
    messageData.msg_body = strdup_in_pool(pool, messageBody);
    pj_str_t content = strdup_in_pool(pool, messageBody);
    pj_str_t to = strdup_in_pool(pool, toString);
    pj_str_t pjmimeType = strdup_in_pool(pool, mimeType);
    add_optional_headers(&messageData, options);
    
    if (messageBody == NULL)
        return PJ_ERROR;
    
    char *dupMessageId = strdup(messageId);
    return pjsua_im_send(acc_id, &to, &pjmimeType, &content, &messageData, (void*)dupMessageId);
}

pj_status_t send_message(const char *toString, const char *messageId,
                         const char *messageBody, RTCEventOptions * options)
{
    return send_message_mime_type(toString, messageId, messageBody, "text/plain; charset=UTF-8", options);
}

void notify_start_typing(const char *toString, RTCEventOptions * options)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
    add_optional_headers(&messageData, options);
    pj_str_t to = pj_str((char*)toString);
    pjsua_im_typing(acc_id, &to, true, &messageData);
}

void notify_stop_typing(const char *toString, RTCEventOptions * options)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
    add_optional_headers(&messageData, options);
    pj_str_t to = pj_str((char*)toString);
    pjsua_im_typing(acc_id, &to, false, &messageData);
}
*/

/* General processing for media state. "mi" is the media index */
static void on_call_generic_media_state(pjsua_call_info *ci, unsigned mi,
                                        pj_bool_t *has_error)
{
    const char *status_name[] = {
        "None",
        "Active",
        "Local hold",
        "Remote hold",
        "Error"
    };
    
    PJ_UNUSED_ARG(has_error);
    
    pj_assert(ci->media[mi].status <= PJ_ARRAY_SIZE(status_name));
    pj_assert(PJSUA_CALL_MEDIA_ERROR == 4);
}

//void accept_call(int call_id, RTCEventOptions * options)
void accept_call(int call_id)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
    //add_optional_headers(&messageData, options);

    int mi = 0;
    pjsua_call_info call_info;
    pjsua_call_get_info(call_id, &call_info);
    pj_bool_t has_error = PJ_FALSE;

    call_setting.vid_cnt = 0;
    call_setting.aud_cnt = 1;

    for (mi=0; mi<call_info.media_cnt; ++mi)
    {
        on_call_generic_media_state(&call_info, mi, &has_error);

        switch (call_info.media[mi].type)
        {
            case PJMEDIA_TYPE_AUDIO:
                break;
            case PJMEDIA_TYPE_VIDEO:
                if(call_info.rem_vid_cnt)
                {
                    current_call_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                    current_call_remote_video_dir = PJMEDIA_DIR_ENCODING_DECODING;
                    current_call_has_video = false;
                }

                setEnableVideoCall(true);
                break;
            default:
                // Make gcc happy about enum not handled by switch/case
                break;
        }
    }

    pjsua_call_answer2(call_id, &call_setting, 200, NULL, &messageData);
}

//void reject_call(int call_id, RTCEventOptions * options)
void reject_call(int call_id)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
//    add_optional_headers(&messageData, options);
   
    pjsua_call_answer2(call_id, &call_setting, 603, NULL, &messageData);
}

//void hangup_call(int call_id, RTCEventOptions * options)
void hangup_call(int call_id)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
//    add_optional_headers(&messageData, options);
    pjsua_call_hangup(call_id, 0, NULL, &messageData);
}

//void busy_call(int call_id, RTCEventOptions * options)
void busy_call(int call_id)
{
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
//    add_optional_headers(&messageData, options);
 
    pjsua_call_answer2(call_id, &call_setting, 486, NULL, &messageData);
}

void destroy_client()
{
    pjsua_destroy();
}

bool is_call_active(int call_id)
{
    return pjsua_call_is_active(call_id);
}

void mute(int call_id, bool enable)
{

    pjsua_conf_adjust_rx_level(0, enable ? 0 : 1);
}
    
void loudspeaker(int call_id, bool enable)
{
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof sessionCategory, &sessionCategory);
    UInt32 audioRouteOverride = enable ? 1 : 0;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof audioRouteOverride, &audioRouteOverride);
}

void set_online_status(bool status)
{
    if (pjsua_var.acc[acc_id].valid)
        pjsua_acc_set_online_status(acc_id, status);
}

void set_registration_status(bool status)
{
    if (pjsua_var.acc[acc_id].valid)
        pjsua_acc_set_registration(acc_id, status);
}

pj_status_t update_screen_name(const char *newUserUriString)
{
    pjsip_endpoint *endpt = pjsua_get_pjsip_endpt();
    if (endpt == NULL) return PJ_ERROR;
    
    pj_pool_t *pool = pjsip_endpt_create_pool(endpt, "Update Screen Name", 100, 100);    
    if (!pool) return PJ_ERROR;
    
    acc_cfg.id = strdup_in_pool(pool, newUserUriString);
    pj_status_t retValue = pjsua_acc_modify(acc_id, &acc_cfg);
    return retValue;
}

int get_registration_expiration()
{
    pjsua_acc_info info;
    if (pjsua_var.acc[acc_id].valid)
        pjsua_acc_get_info(acc_id, &info);
    if (info.status != 200)
        return 0;
    return info.expires;
}

void send_registration_message()
{
    set_registration_status(true);
}

#pragma mark - Keep Alive

void keepalive_send_data_callback(pjsip_transport *tp, void *token, pj_ssize_t bytes_sent)
{
    pjsip_tx_data *tdata = (pjsip_tx_data*) token;
    if (tdata->ref_cnt)
    {
        pj_atomic_value_t ref_count = pj_atomic_get(tdata->ref_cnt);
        if (ref_count > 0)
            pjsip_tx_data_dec_ref(tdata);
    }
}

/*
int keep_alive(const char* server, unsigned int port)
{
    pjsip_endpoint *endpt = pjsua_get_pjsip_endpt();
    pjsip_tx_data *tdata = 0;
    pjsip_transport *tp = 0;
    pj_status_t status;
    pj_sockaddr_in dst;
    char *server_copy = strdup(server);
    pj_str_t server_str = pj_str(server_copy);
    
    pj_sockaddr_in_init(&dst, &server_str, port);
    
    if ([instance.accountConfiguration isTransportSSL])
        pjsip_endpt_acquire_transport(endpt, 
                                      PJSIP_TRANSPORT_TLS,
                                      &dst,
                                      pj_sockaddr_get_len(&dst),
                                      NULL,
                                      &tp);
    else
        pjsip_endpt_acquire_transport(endpt, 
                                      PJSIP_TRANSPORT_TCP,
                                      &dst,
                                      pj_sockaddr_get_len(&dst),
                                      NULL,
                                      &tp);
        
    if (tp== NULL)
        return PJ_ERROR;
    
    
    pjsip_endpt_create_tdata(endpt, &tdata);
    
    tdata->buf.start = pj_pool_alloc(tdata->pool, KEEPALIVE_MESSAGE_SIZE);
    tdata->buf.end = tdata->buf.start + KEEPALIVE_MESSAGE_SIZE;
    
    pj_memcpy(tdata->buf.start, KEEPALIVE_MESSAGE, KEEPALIVE_MESSAGE_SIZE);
    tdata->buf.cur = tdata->buf.start + KEEPALIVE_MESSAGE_SIZE;
    
    status = tp->send_msg(tp, tdata, &dst, sizeof(dst), tdata, &keepalive_send_data_callback);
    
    pjsip_transport_dec_ref(tp);
    free(server_copy);
    
    return status;
//    return PJ_OK;
}

#pragma mark - Presence
void on_presence(int status_code, pj_str_t *status_text, pj_str_t *mime_type, pj_str_t *body)
{    
    if (status_code > 300) return;

    NSString *xmlString = to_NSString(body, NSUTF8StringEncoding);
    XMLParser *parser = [[XMLParser alloc] init];
    [instance onPresence:[parser parsePresenceXML:xmlString]];
}

static void send_request_status(void *token, pjsip_event *e) {
    
    if (e->type != PJSIP_EVENT_TSX_STATE)
        return;
    
    pjsip_transaction *tsx = e->body.tsx_state.tsx;
    pjsip_endpoint *endpt = pjsua_get_pjsip_endpt();
    
    //Ignore provisional response, if any
    DLog(@"%d", tsx->status_code);
    
    
    // Handle authentication challenges
    if (e->body.tsx_state.type == PJSIP_EVENT_RX_MSG &&
        (tsx->status_code == 401 || tsx->status_code == 407)) 
    {
        pjsip_rx_data *rdata = e->body.tsx_state.src.rdata;
        pjsip_tx_data *tdata;
        pjsip_auth_clt_sess auth;
        pj_status_t status;
        
        //PJ_LOG(4,(THIS_FILE, "Resending Request with authentication"));
        
        // Create temporary authentication session
        pjsip_auth_clt_init(&auth, endpt,rdata->tp_info.pool, 0);
        
        //TID: Assuming just one account
        int acc_id = 0;
        pjsip_auth_clt_set_credentials(&auth, acc_cfg.cred_count, &acc_cfg.cred_info[acc_id]);
        
        pjsip_auth_clt_set_prefs(&auth, &acc_cfg.auth_pref);
        
        status = pjsip_auth_clt_reinit_req(&auth, rdata, tsx->last_tx,
                                           &tdata);
        if (status == PJ_SUCCESS) {
            
            // Increment CSeq
            PJSIP_MSG_CSEQ_HDR(tdata->msg)->cseq++;
            
            // Re-send request
            status = pjsip_endpt_send_request( endpt, tdata, -1,
                                              NULL, &send_request_status);
            if (status == PJ_SUCCESS) {
                return;
            }
        }
    }
    
    pjsip_rx_data *rdata;
    
    pj_str_t mime_type;
    pj_str_t body;
    
    if (tsx->status_code < 200 ||
        tsx->status_code >= 300)
        return;
    
    if (e->body.tsx_state.src.rdata->msg_info.msg == NULL)
        return;
    
    if (e->body.tsx_state.type == PJSIP_EVENT_RX_MSG) {
        rdata = e->body.tsx_state.src.rdata;
        pjsip_msg_body *msg_body = rdata->msg_info.msg->body;
        if (msg_body != NULL) {
            char buf[256];
            mime_type.ptr = buf;
            pjsip_media_type * m = &msg_body->content_type;
            mime_type.slen = pj_ansi_snprintf(buf, sizeof(buf),
                                              "%.*s/%.*s",
                                              (int)m->type.slen,
                                              m->type.ptr,
                                              (int)m->subtype.slen,
                                              m->subtype.ptr);
            if (mime_type.slen < 1)
                mime_type.slen = 0;
            
            body.ptr = (char*)msg_body->data;
            body.slen = msg_body->len;
        }
    }
    else {
    }
    
    on_presence(tsx->status_code, &tsx->status_text, &mime_type, &body);
}*/

void reset_connection()
{
    pj_status_t status;
    
    if (the_transport) 
    {
        status = pjsip_transport_shutdown(the_transport);
        pjsip_transport_dec_ref(the_transport);
        the_transport = NULL;
    }
    
    if (tp_id >= 0)
    {
        pjsua_transport_close(tp_id, PJ_TRUE);
        tp_id = -1;
    }
    
    if (pjsua_acc_is_valid(acc_id))
    {
        pjsua_acc_del(acc_id);
    }
    
    status = create_transport();
    
    if (status == PJ_ERROR)
    {
        tp_id = -1;
        return;
    }
    
    pjsua_acc_add(&acc_cfg, PJ_TRUE, &acc_id);
}

pj_status_t send_presence_message(const char *tostr)
{
    pjsip_endpoint *endpt = pjsua_get_pjsip_endpt();
    if (endpt == NULL) return PJ_ERROR;
    
    pj_pool_t *pool = pjsip_endpt_create_pool(endpt, "Presence Message", 100, 100);
    
    if (!pool) return PJ_ERROR;
    
    pj_str_t message = pj_str("SUBSCRIBE");
    pj_str_t to = strdup_in_pool(pool, tostr); 
    pj_str_t mime_type = pj_str("text/plain");
    pj_str_t other = pj_str("");
    
    pjsua_msg_data messageData;
    pjsua_msg_data_init(&messageData);
    messageData.msg_body = pj_str("");
    pj_str_t contact;
    pj_status_t status = pjsua_acc_create_uac_contact(pool, &contact, acc_id, &to);
    if (status == PJ_ERROR) 
    {
        pj_pool_release(pool);
        return PJ_ERROR;
    }
    pj_str_t contactstr = pj_str("Contact");
    pjsip_generic_string_hdr *contacthdr = pjsip_generic_string_hdr_create(pool, &contactstr,&contact);
    
    if (contacthdr)
    {
        pj_list_insert_after(&messageData.hdr_list, contacthdr);
    }
    
    pjsip_accept_hdr *accept_hdr = pjsip_accept_hdr_create(pool);
    if (accept_hdr)
    {
        accept_hdr->values[0] = pj_str("application/jj-presence+xml");
        accept_hdr->count = 1;
        pj_list_insert_after(&messageData.hdr_list, accept_hdr);
    }
    
    pjsip_expires_hdr *expires_hdr = pjsip_expires_hdr_create(pool, 0);
    if (expires_hdr)
    {
        pj_list_insert_after(&messageData.hdr_list, expires_hdr);
    }
    
    pjsip_event_hdr *event_hdr = pjsip_event_hdr_create(pool);
    if (event_hdr)
    {
        event_hdr->event_type = pj_str("presence");
        pj_list_insert_after(&messageData.hdr_list, event_hdr);
    }
     
    return send_request(0, &message, &to, &mime_type, &other, &messageData, pool);
}
/*
PJ_DEF(pj_status_t)
send_request(pjsua_acc_id acc_id, 
             const pj_str_t *method,
             const pj_str_t *to,
             const pj_str_t *mime_type,
             const pj_str_t *content,
             const pjsua_msg_data *msg_data,
             void *user_data) {
    pjsip_tx_data *tdata;
    pjsip_media_type media_type;
    pjsip_endpoint *endpt = pjsua_get_pjsip_endpt();
    pj_status_t status;
    struct pjsua_data * pjsua_var = pjsua_get_var();
    pjsua_acc * acc = &pjsua_var->acc[acc_id];
    
    if (endpt == NULL) return PJ_ERROR;
    
    pjsip_method pj_method;
    pj_pool_t *pool = pjsua_pool_create("subscribe_pool", 1000, 1000);
    pjsip_method_init(&pj_method, pool, method);
    
    // Create request
    status = pjsip_endpt_create_request(endpt, 
                                        &pj_method, to,
                                        &acc_cfg.id,
                                        to, NULL, NULL, -1, NULL, &tdata);
    if (status != PJ_SUCCESS) {
        pj_pool_release(pool);
        return status;
    }

    if (acc->cfg.transport_id != PJSUA_INVALID_ID) {
        pjsip_tpselector tp_sel;
        
        pjsua_init_tpselector(tp_id, &tp_sel);
        pjsip_tx_data_set_transport(tdata, &tp_sel);
    }
    
    if (mime_type != NULL && content != NULL) {
        // Parse MIME type
        pjsua_parse_media_type(tdata->pool, mime_type, &media_type);
        // Add message body
        tdata->msg->body = pjsip_msg_body_create( tdata->pool, &media_type.type,
                                                 &media_type.subtype, 
                                                 content);
        if (tdata->msg->body == NULL) {
            //pjsua_perror(THIS_FILE, "Unable to create msg body", PJ_ENOMEM);
            pjsip_tx_data_dec_ref(tdata);
            pj_pool_release(pool);
            return PJ_ENOMEM;
        }
    }
    // Add additional headers etc.
    pjsua_process_msg_data(tdata, msg_data);

    // Add route set
    pjsua_set_msg_route_set(tdata, &acc->route_set);
    status = pjsip_endpt_send_request(endpt, tdata, -1, NULL, &send_request_status);
    pj_pool_t *presencepool = (pj_pool_t *) user_data;
    pj_pool_release(presencepool);
    pj_pool_release(pool); 
    return status;
}*/
