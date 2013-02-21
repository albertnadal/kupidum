//
//  KPDClientSIP.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDClientSIPDelegate.h"
#import "KPDUser.h"

@interface KPDClientSIP : NSObject
{
    int currentCallId;
    NSMutableArray *delegates;
}

// Class methods
+ (KPDClientSIP *)sharedInstance;
+ (NSString *)userAgent;

// General instance methods
- (void)addDelegate:(id<KPDClientSIPDelegate>)theDelegate;
- (void)removeDelegate:(id<KPDClientSIPDelegate>)theDelegate;

// Methods called from pjsip_wrapper
- (void)receivedIncomingCall:(int)callId;
- (void)videoStreamStartTransmiting:(int)callId;
- (void)instantMessageReceivedFromUser:(NSString *)fromSIPUser withContent:(NSString *)textMessage;

// Public methods for SIP register signaling
- (void)registerToServerWithUser:(NSString *)theUser password:(NSString *)thePassword;

// Public methods called from VideoconferenceViewController
- (void)callUser:(NSString *)theUser withVideo:(BOOL)videoFlag;
- (void)hangUp;
- (void)acceptCall;
- (void)rejectCall;
- (void)setIngoingVideoStreamViewHidden:(BOOL) isHidden;
- (void)setOutgoingVideoStreamViewHidden:(BOOL) isHidden;
- (void)setIngoingVideoStreamViewFrame:(CGRect) remoteCgrect;
- (void)setOutgoingVideoStreamViewFrame:(CGRect) localCgrect;
- (UIView *)getIngoingVideoStreamView;
- (UIView *)getOutgoingVideoStreamView;
- (UIView *)getVideoStreamView;

// Public methods called from ConversationViewController.h
- (void)sendInstantMessageToUser:(KPDUser *)toUser withContent:(NSString *)textMessage;

@end