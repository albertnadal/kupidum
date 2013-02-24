//
//  KPDChatConversation.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDChatConversation.h"
#import "KPDChatMessage.h"
#import "KupidumDBSingleton.h"


@implementation KPDChatConversation

@synthesize remoteUser, localUser, chatMessages;

- (id)initWithRemoteUser:(KPDUser *)ruser andLocalUser:(KPDUser *)luser
{
    if(self = [super init])
    {
        remoteUser = ruser;
        localUser = luser;
        chatMessages = nil;
    }

    return self;
}

+ (KPDChatConversation *)retrieveConversationBetweenRemoteUser:(KPDUser *)usera andLocalUser:(KPDUser *)userb
{
    // Returns the conversation between two users
    NSMutableArray *listOfMessages = [[NSMutableArray alloc] init];

    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select from_username, to_username, message, date_message from conversation where from_username IN (?, ?) AND to_username IN (?, ?) ORDER BY date_message DESC", [usera username], [userb username], [usera username], [userb username]];
    while ([rs next])
    {
        NSLog(@"from username: (%@)", [rs stringForColumn:@"from_username"]);
        NSLog(@"to username: (%@)", [rs stringForColumn:@"to_username"]);
        NSLog(@"message: (%@)", [rs stringForColumn:@"message"]);

        KPDUser *from_username = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"from_username"]];
        KPDUser *to_username = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"to_username"]];
        NSString *message = [rs stringForColumn:@"message"];
        NSDate *date_message = [rs dateForColumn:@"date_message"];

        KPDChatMessage *chat_message = [[KPDChatMessage alloc] init];
        [chat_message setFromUser:from_username];
        [chat_message setToUser:to_username];
        [chat_message setMessage:message];
        [chat_message setDateMessage:date_message];

        [listOfMessages addObject:chat_message];
    }

    [rs close];

    KPDChatConversation *conversation = [[KPDChatConversation alloc] initWithRemoteUser:usera andLocalUser:userb];
    [conversation setChatMessages:[[NSArray alloc] initWithArray:listOfMessages]];

    return conversation;
}

@end
