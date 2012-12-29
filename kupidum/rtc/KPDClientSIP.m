//
//  KPDClientSIP.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import "KPDClientSIP.h"
#import "pjsip_wrapper.h"

@implementation KPDClientSIP

@synthesize delegate;

- (id)init
{
    self = [super init];

    return self;
}

+ (KPDClientSIP *)sharedInstance
{
    static dispatch_once_t onceToken;
    static KPDClientSIP *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[KPDClientSIP alloc] init];
    });
    
    return _instance;
}

+ (NSString *)userAgent
{
    NSDictionary * bundleDictionary = [[NSBundle mainBundle] infoDictionary];
    
    return [NSString stringWithFormat:@"%@/%@ (P; Apple; %@; %@; %@;)",
            [bundleDictionary objectForKey:(NSString *)kCFBundleNameKey],
            [bundleDictionary objectForKey:(NSString *)kCFBundleVersionKey],
            [[UIDevice currentDevice] model],
            [[UIDevice currentDevice] systemName],
            [[UIDevice currentDevice] systemVersion]];
}

// Public methods for SIP register signaling

- (void)registerToServerWithUser:(NSString *)theUser password:(NSString *)thePassword
{
    const char *userAgent = [[KPDClientSIP userAgent] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *user = [theUser cStringUsingEncoding:NSUTF8StringEncoding];
    const char *password = [thePassword cStringUsingEncoding:NSUTF8StringEncoding];

    main_pjsip(self, (char*)user, (char*)password, (char*)userAgent); //Creates pjsip instance and register user to SIP server

    setEnableVideoDriver(true);
}

// Public methods called from VideoconferenceViewController

- (void)receivedIncomingCall:(int)callId
{
    currentCallId = callId;
    [delegate clientDidReceivedVideocall:self fromUser:@"Sílvia"];
}

- (void)videoStreamStartTransmiting:(int)callId
{
    currentCallId = callId;
    [delegate videoconferenceDidBegan:self];
}

- (void)hangUp
{
    hangup_call(currentCallId);
}

- (void)acceptCall
{
    accept_call(currentCallId);
}

- (void)rejectCall
{
    reject_call(currentCallId);
}

- (void) setIngoingVideoStreamViewHidden:(BOOL) isHidden{
    setIngoingVideoStreamViewHidden(isHidden);
}

- (void) setOutgoingVideoStreamViewHidden:(BOOL) isHidden{
    setOutgoingVideoStreamViewHidden(isHidden);
}

- (void) setIngoingVideoStreamViewFrame:(CGRect) remoteCgrect{
    setIngoingVideoStreamViewFrame(remoteCgrect);
}

- (void) setOutgoingVideoStreamViewFrame:(CGRect) localCgrect{
    setOutgoingVideoStreamViewFrame(localCgrect);
}

- (UIView *) getIngoingVideoStreamView{
    return getIngoingVideoStreamView();
}

- (UIView *) getOutgoingVideoStreamView{
    return getOutgoingVideoStreamView();
}

- (UIView *) getVideoStreamView{
    return getVideoStreamView();
}

- (void)callUser:(NSString *)theUser withVideo:(BOOL)videoFlag
{
    const char *user = [theUser cStringUsingEncoding:NSUTF8StringEncoding];
    int status;

    if(videoFlag)   status = videocall((char*)user);
    else            { /*Nothing to do now*/ }
}

// Public methods called from ChatViewController

- (void)sendInstantMessageToUser:(NSString *)toUser withContent:(NSString *)textMessage
{
    const char *user = [toUser cStringUsingEncoding:NSUTF8StringEncoding];
    const char *messageBody = [textMessage cStringUsingEncoding:NSUTF8StringEncoding];

    send_message((char *)user, (char *)messageBody);
}

@end