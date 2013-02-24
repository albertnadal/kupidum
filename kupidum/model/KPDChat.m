//
//  KPDChat.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDChat.h"
#import "KupidumDBSingleton.h"


@implementation KPDChat

@synthesize usernameA, usernameB, lastMessage, dateLastMessage, conversation;

- (id)initWithUser:(KPDUser *)usera andUser:(KPDUser *)userb andMessage:(NSString *)msg andDateLastMessage:(NSDate *)date_msg
{
    if(self = [super init])
    {
        usernameA = usera;
        usernameB = userb;
        lastMessage = msg;
        dateLastMessage = date_msg;

        NSLog(@"Message: %@", msg);

        [self retrieveDataFromWebService];
        [self saveToDatabase];
    }

    return self;
}

- (void)retrieveDataFromWebService
{
    //warning Implement this function!
    usernameA = [[KPDUser alloc] initWithUsername:[usernameA username]];
    usernameB = [[KPDUser alloc] initWithUsername:[usernameB username]];
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    if([self chatIsInDatabaseWithUser:usernameA andUser:usernameB])
    {
        // Update chat data
        [db beginTransaction];
        [db executeUpdate:@"update chat set last_message = ?, date_last_message = ? where username_a IN (?, ?) AND username_b IN (?, ?)", lastMessage, dateLastMessage, [usernameA username], [usernameB username], [usernameA username], [usernameB username]];
        [db commit];
    }
    else
    {
        // Insert chat into db
        NSLog(@"INSERT KPDChat | username a: %@ | username b: %@ | last message: %@ | date last message: %@", [usernameA username], [usernameB username], lastMessage, dateLastMessage);
        [db beginTransaction];
        [db executeUpdate:@"insert into chat (username_a, username_b, last_message, date_last_message) values (?, ?, ?, ?)" , [usernameA username], [usernameB username], lastMessage, dateLastMessage];
        [db commit];
    }

}

- (bool)chatIsInDatabaseWithUser:(KPDUser *)usera andUser:(KPDUser *)userb
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from chat where username_a IN (?, ?) AND username_b IN (?, ?)", [usera username], [userb username], [usera username], [userb username]];

    bool has_rows = false;


    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

- (void)reloadConversation
{
    // First check who is the remote and local users before call the next class method
    conversation = [KPDChatConversation retrieveConversationBetweenRemoteUser:usernameA andLocalUser:usernameB];

    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select last_message, date_last_message from chat where username_a IN (?, ?) AND username_b IN (?, ?)", [usernameA username], [usernameB username], [usernameA username], [usernameB username]];

    while ([rs next])
    {
        lastMessage = [rs stringForColumn:@"last_message"];
        dateLastMessage = [rs dateForColumn:@"date_last_message"];
    }

    [rs close];
}

+ (NSArray *)retrieveChatsOfUser:(KPDUser *)user
{
    // Returns a list of chats from user
    NSMutableArray *listOfChats = [[NSMutableArray alloc] init];

    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"SELECT username_a, username_b, last_message, date_last_message FROM chat WHERE username_a = ? OR username_b = ?", [user username], [user username]];

    while ([rs next])
    {
        NSLog(@"username_a: (%@)", [rs stringForColumn:@"username_a"]);
        NSLog(@"username_b: (%@)", [rs stringForColumn:@"username_b"]);
        NSLog(@"last_message: (%@)", [rs stringForColumn:@"last_message"]);

        KPDUser *userA = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"username_a"]];
        KPDUser *userB = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"username_b"]];

        KPDChat *chat = [[KPDChat alloc] initWithUser:userA andUser:userB andMessage:[rs stringForColumn:@"last_message"] andDateLastMessage:[rs dateForColumn:@"date_last_message"]];
        [chat reloadConversation];

        [listOfChats addObject:chat];
    }

    [rs close];

    return [[NSArray alloc] initWithArray:listOfChats];
}

@end
