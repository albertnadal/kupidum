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


- (id)init
{
    self = [super init];
    delegates = [[NSMutableArray alloc] init];

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

- (void)addDelegate:(id<KPDClientSIPDelegate>)theDelegate
{
    if([delegates indexOfObject:theDelegate] == NSNotFound)
        [delegates addObject:theDelegate];
}

- (void)removeDelegate:(id<KPDClientSIPDelegate>)theDelegate
{
    [delegates removeObject:theDelegate];
}

// Public methods for SIP register signaling

- (void)registerToServerWithUser:(NSString *)theUser password:(NSString *)thePassword
{
    const char *userAgent = [[KPDClientSIP userAgent] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *user = [theUser cStringUsingEncoding:NSUTF8StringEncoding];
    const char *password = [thePassword cStringUsingEncoding:NSUTF8StringEncoding];

    main_pjsip(self, (char*)user, (char*)password, (char*)userAgent); //Creates pjsip instance and register user to SIP server

    KPDUserSingleton *user_singleton = [KPDUserSingleton sharedInstance];
    [user_singleton setUsername:theUser];

    setEnableVideoDriver(true);
}

// Public methods called from pjsip_wrapper

- (void)receivedIncomingCall:(int)callId fromUser:(NSString *)fromSIPUser
{
    NSString *localUsername = [[KPDUserSingleton sharedInstance] username];
    KPDUser *toUser = [[KPDUser alloc] initWithUsername:localUsername];
    KPDUser *fromUser = [[KPDUser alloc] initWithUsername:fromSIPUser];

    KPDVideocall *videocall = [[KPDVideocall alloc] initWithFromUser:fromUser andToUser:toUser andIsIncoming:true andDate:[NSDate date]];
#pragma unused(videocall)

    currentCallId = callId;

    for(id<KPDClientSIPDelegate> delegate in delegates)
        if([delegate respondsToSelector:@selector(clientDidReceivedVideocall:fromUser:)])
            [delegate clientDidReceivedVideocall:self fromUser:fromSIPUser];
}

- (void)videoStreamStartTransmiting:(int)callId toUser:(NSString *)user
{
    KPDUser *_user = [[KPDUser alloc] initWithUsername:user];

    currentCallId = callId;

    for(id<KPDClientSIPDelegate> delegate in delegates)
        if([delegate respondsToSelector:@selector(videoconferenceDidBegan:withRemoteUser:)])
            [delegate videoconferenceDidBegan:self withRemoteUser:_user];
}

- (void)videocallEnded:(int)callId WithUser:(NSString *)user
{
    KPDUser *_user = [[KPDUser alloc] initWithUsername:user];

    currentCallId = callId;

    for(id<KPDClientSIPDelegate> delegate in delegates)
        if([delegate respondsToSelector:@selector(videoconferenceDidEnd:withRemoteUser:)])
            [delegate videoconferenceDidEnd:self withRemoteUser:_user];
}

- (void)instantMessageReceivedFromUser:(NSString *)fromSIPUser withContent:(NSString *)textMessage
{
    NSString *localUsername = [[KPDUserSingleton sharedInstance] username];

    KPDUser *fromUser = [[KPDUser alloc] initWithUsername:fromSIPUser];
    KPDUser *toUser = [[KPDUser alloc] initWithUsername:localUsername];

    KPDChat *chat = [[KPDChat alloc] initWithUser:fromUser andUser:toUser andMessage:textMessage andDateLastMessage:[NSDate date]];
    #pragma unused(chat)

    KPDChatMessage *message = [[KPDChatMessage alloc] initWithFromUser:fromUser toUser:toUser message:textMessage date:[NSDate date]];
    [message saveToDatabase];

    NSLog(@"Text message: %@", textMessage);

    for(id<KPDClientSIPDelegate> delegate in delegates)
        if([delegate respondsToSelector:@selector(clientDidReceivedInstantMessage:fromUser:withContent:)])
            [delegate clientDidReceivedInstantMessage:self fromUser:fromUser withContent:textMessage];
}


// Public methods called from VideoconferenceViewController

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

- (void) setVideoStreamViewFrame:(CGRect) remoteCgrect{
    setVideoStreamViewFrame(remoteCgrect);
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

    if(videoFlag)
    {
        NSString *localUsername = [[KPDUserSingleton sharedInstance] username];
        KPDUser *toUser = [[KPDUser alloc] initWithUsername:theUser];
        KPDUser *fromUser = [[KPDUser alloc] initWithUsername:localUsername];

        KPDVideocall *_videocall = [[KPDVideocall alloc] initWithFromUser:fromUser andToUser:toUser andIsIncoming:false andDate:[NSDate date]];
#pragma unused(_videocall)

        // Send videocall request to remote user
        status = videocall((char*)user);

        for(id<KPDClientSIPDelegate> delegate in delegates)
            if([delegate respondsToSelector:@selector(clientDidSendVideocallRequestToUser:)])
                [delegate clientDidSendVideocallRequestToUser:toUser];
    }
    else            { /*Nothing to do now with only audio calls*/ }
}

- (void)useFrontalCamera
{
    KPDVideoDevice *frontDevice = getDefaultFrontVideoDevice();
    setOutgoingVideoStreamDevice(frontDevice);
}

- (void)useBackCamera
{
    KPDVideoDevice *backDevice = getDefaultBackVideoDevice();
    setOutgoingVideoStreamDevice(backDevice);
}

// Public methods called from ConversationViewController.h

- (void)sendInstantMessageToUser:(KPDUser *)toUser withContent:(NSString *)textMessage
{
    NSString *localUsername = [[KPDUserSingleton sharedInstance] username];

    KPDUser *fromUser = [[KPDUser alloc] initWithUsername:localUsername];

    KPDChat *chat = [[KPDChat alloc] initWithUser:fromUser andUser:toUser andMessage:textMessage andDateLastMessage:[NSDate date]];
    #pragma unused(chat)

    KPDChatMessage *message = [[KPDChatMessage alloc] initWithFromUser:fromUser toUser:toUser message:textMessage date:[NSDate date]];
    [message saveToDatabase];


    const char *user = [[toUser username] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *messageBody = [textMessage cStringUsingEncoding:NSUTF8StringEncoding];

    send_message((char *)user, (char *)messageBody);
}

@end