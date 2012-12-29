//
//  KPDClientSIP.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDClientSIPDelegate.h"

@interface KPDClientSIP : NSObject
{
    int currentCallId;
    id<KPDClientSIPDelegate> delegate;
}

@property (retain, nonatomic) id<KPDClientSIPDelegate> delegate;

/*@property (retain, nonatomic) NSString* deviceId;
@property (retain, nonatomic) NSString* deviceName;
@property (nonatomic) video_device_type deviceType;*/

// Class methods
+ (KPDClientSIP *)sharedInstance;
+ (NSString *)userAgent;

// Methods called from pjsip_wrapper
- (void)receivedIncomingCall:(int)callId;
- (void)videoStreamStartTransmiting:(int)callId;

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

// Public methods called from ChatViewController
- (void)sendInstantMessageToUser:(NSString *)toUser withContent:(NSString *)textMessage;

@end