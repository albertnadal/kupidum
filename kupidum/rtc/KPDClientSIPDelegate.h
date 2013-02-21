//
//  KPDClientSIPDelegate.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 24/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"

@class KPDClientSIP;

@protocol KPDClientSIPDelegate <NSObject>

- (void)clientDidReceivedVideocall:(KPDClientSIP *)client fromUser:(NSString *)theUser;
- (void)videoconferenceDidBegan:(KPDClientSIP *)client;
- (void)clientDidReceivedInstantMessage:(KPDClientSIP *)client fromUser:(KPDUser *)fromUser withContent:(NSString *)textMessage;

@end
