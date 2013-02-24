//
//  KPDChat.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"
#import "KPDChatConversation.h"

@interface KPDChat : NSObject
{
    KPDUser *usernameA;
    KPDUser *usernameB;
    NSString *lastMessage;
    NSDate *dateLastMessage;
    KPDChatConversation *conversation;
}

@property (nonatomic, retain) KPDUser* usernameA;
@property (nonatomic, retain) KPDUser* usernameB;
@property (nonatomic, retain) NSString *lastMessage;
@property (nonatomic, retain) NSDate *dateLastMessage;
@property (nonatomic, retain) KPDChatConversation *conversation;

- (id)initWithUser:(KPDUser *)usera andUser:(KPDUser *)userb andMessage:(NSString *)msg andDateLastMessage:(NSDate *)date_msg;
+ (NSArray *)retrieveChatsOfUser:(KPDUser *)user;
- (void)reloadConversation;
- (bool)chatIsInDatabaseWithUser:(KPDUser *)usera andUser:(KPDUser *)userb;
- (void)retrieveDataFromWebService;
- (void)saveToDatabase;


@end
