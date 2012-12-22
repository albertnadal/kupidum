//
//  pjsip_wrapper.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#ifndef pjsobj_pjsip_wrapper_h
#define pjsobj_pjsip_wrapper_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KPDVideoDevice.h"
#import "KPDVideoDeviceView.h"
#import "KPDClientSIP.h"
//#import "SIPUri.h"
#include "pjsua.h"
#include "pjsip.h"

#define KEEPALIVE_MESSAGE "\r\n\r\n"
#define KEEPALIVE_MESSAGE_SIZE 4

enum {
    PJ_OK,
    PJ_ERROR = -1
};


void main_pjsip(KPDClientSIP *clientSip, const char* user, const char* password, const char* userAgent);
/*
int call(const char* callId, RTCEventOptions * options, bool isVideoCall);
int acc_add(const char* regUriString, const char* proxyString, const char * userUriString,
                  const char* userString, const char* passwordString, int *accountId);
*/


// VIDEO FUNCTIONS

// stream views setup
bool setOutgoingVideoStreamViewFrame(CGRect rect);
bool setIngoingVideoStreamViewFrame(CGRect rect);
void setVideoStreamViewFrame(CGRect rect);

// getting stream views
UIView* getOutgoingVideoStreamView(void);
UIView* getIngoingVideoStreamView(void);
UIView* getVideoStreamView(void);

// show/hide stream views
bool setOutgoingVideoStreamViewHidden(bool v);
bool setIngoingVideoStreamViewHidden(bool v);

// Enable or disable ingoing or outgoing video streams during call RE-INVITE.
bool setEnableOutgoingVideoStream(pjsua_call_id call_id, bool v);
bool getStateOutgoingVideoStream(pjsua_call_id call_id);

// Pause or unpause video stream.
bool setOnHoldVideoStream(int call_id, bool isOnHold);
bool getOnHoldVideoStatefromCall(int call_id);

// retrieve/set devices
NSArray * getVideoDevices(void);
int getVideoDevicesCount(void);

KPDVideoDevice* getDefaultFrontVideoDevice(void);
KPDVideoDevice* getDefaultBackVideoDevice(void);
bool setOutgoingVideoStreamDevice(KPDVideoDevice *yvd);

// enable/disable video/audio before start call
bool setEnableVideoCall(bool v);
bool setEnableAudioCall(bool v);

// start/stop video streams after call stablished
bool startVideoStream(void);
bool stopVideoStream(void);
bool setVideoStreamOperationOnCurrentCall(pjsua_call_vid_strm_op op);

// User accept sending video on the current video call
bool acceptVideoCallRequest(void);
bool rejectVideoCallRequest(void); // Only for testing purposes

// enable/disable video driver features
bool setEnableVideoDriver(bool v);
bool setEnableReceiveNotificationsFromVideoDriver(bool v);


void printMachineStatesLogs(void);

//private

// setup codec params for video operation
void setup_video_codec_params(void);
static bool is_video_active(pjsua_call_id call_id);
static pjmedia_dir get_video_direction(pjsua_call_id call_id);

// END VIDEO

#pragma mark YARN API

//Connection functions
int acc_del();
BOOL is_connected();
void reset_connection();
int get_registration_expiration();
void set_online_status(bool status);
void set_registration_status(bool status);
void send_registration_message();
pj_status_t update_screen_name(const char *newUserUriString);

// Messaging
/*pj_status_t send_message_mime_type(const char *toString, const char *messageId,
                                   const char *messageBody, const char *mimeType, RTCEventOptions * options);
pj_status_t send_message(const char *toString, const char *messageId,
                         const char *messageBody, RTCEventOptions * options);
void notify_start_typing(const char *toString, RTCEventOptions * options);
void notify_stop_typing(const char *toString, RTCEventOptions * options);
*/
// Session functions
void accept_call(int call_id);
void reject_call(int call_id);
void busy_call(int call_id);
void hangup_call(int call_id);
void destroy_client();
bool is_call_active(int call_id);

// Audio Control
void mute(int call_id, bool enable);
void loudspeaker(int call_id, bool enable);

// Audio Call Management 

static bool is_audio_active(pjsua_call_id call_id);

// Keep Alive
void keepalive_send_data_callback(pjsip_transport *tp, void *token, pj_ssize_t bytes_sent);
void keepalive_resolve_callback(pj_status_t status, void *token, const struct pjsip_server_addresses *addr);
int keep_alive(const char* server, unsigned int port);

// Presence
PJ_DEF(pj_status_t)
send_request(pjsua_acc_id acc_id, 
             const pj_str_t *method,
             const pj_str_t *to,
             const pj_str_t *mime_type,
             const pj_str_t *content,
             const pjsua_msg_data *msg_data,
             void *user_data);
pj_status_t send_presence_message(const char *tostr);
void on_presence(int status_code, pj_str_t *status_text, pj_str_t *mime_type, pj_str_t *body);

#endif
