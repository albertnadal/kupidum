//
//  KPDChatConversation.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"
#import "KPDChatMessage.h"

@interface KPDChatConversation : NSObject
{
    KPDUser *remoteUser;
    KPDUser *localUser;
    NSArray *chatMessages;
}

@property (nonatomic, retain) KPDUser *remoteUser;
@property (nonatomic, retain) KPDUser *localUser;
@property (nonatomic, retain) NSArray *chatMessages;

- (id)initWithRemoteUser:(KPDUser *)ruser andLocalUser:(KPDUser *)luser;
+ (KPDChatConversation *)retrieveConversationBetweenRemoteUser:(KPDUser *)usera andLocalUser:(KPDUser *)userb;

@end
