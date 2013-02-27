//
//  KPDChatMessage.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDMessage.h"
#import "KupidumDBSingleton.h"


@implementation KPDMessage

@synthesize fromUser, toUser, subject, message, read, dateMessage;

- (id)initWithFromUser:(KPDUser *)_fromUser toUser:(KPDUser *)_toUser subject:(NSString *)_subject message:(NSString *)_message read:(bool)_read date:(NSDate *)_dateMessage
{
    if(self = [super init])
    {
        fromUser = _fromUser;
        toUser = _toUser;
        subject = _subject;
        message = _message;
        read = _read;
        dateMessage = _dateMessage;

        [self retrieveDataFromWebService];
        [self saveToDatabase];
    }

    return self;
}

- (void)retrieveDataFromWebService
{
    //warning Implement this function!
    fromUser = [[KPDUser alloc] initWithUsername:[fromUser username]];
    toUser = [[KPDUser alloc] initWithUsername:[toUser username]];
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    if([self messageIsInDatabaseWithUser:fromUser andUser:toUser withDate:dateMessage])
    {
        // Update chat data
        [db beginTransaction];
        [db executeUpdate:@"update message set subject = ?, message = ?, read = ? where from_username = ? AND to_username = ? AND date_message = ?", subject, message, [NSNumber numberWithBool:read], [fromUser username], [toUser username], dateMessage];
        [db commit];
    }
    else
    {
        // Insert chat into db
        NSLog(@"INSERT message | from: %@ to: %@ subject: %@ msg: %@ read: %d date: %@", [fromUser username], [toUser username], subject, message, read, dateMessage);
        [db beginTransaction];
        [db executeUpdate:@"insert into message (from_username, to_username, subject, message, read, date_message) values (?, ?, ?, ?, ?, ?)" , [fromUser username], [toUser username], subject, message, [NSNumber numberWithBool:read] , dateMessage];
        [db commit];
    }
}

+ (NSArray *)retrieveMessagesOfUser:(KPDUser *)user;
{
    // Returns a list of chats from user
    NSMutableArray *listOfMessages = [[NSMutableArray alloc] init];

    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"SELECT from_username, to_username, subject, message, read, date_message FROM message WHERE from_username = ? OR to_username = ?", [user username], [user username]];

    while ([rs next])
    {
        NSLog(@"from_username: (%@)", [rs stringForColumn:@"from_username"]);
        NSLog(@"to_username: (%@)", [rs stringForColumn:@"to_username"]);
        NSLog(@"subject: (%@)", [rs stringForColumn:@"subject"]);
        NSLog(@"message: (%@)", [rs stringForColumn:@"message"]);
        NSLog(@"read: (%d)", [rs boolForColumn:@"read"]);
        NSLog(@"date: (%@)", [rs dateForColumn:@"date_message"]);

        KPDUser *fuser = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"from_username"]];
        KPDUser *tuser = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"to_username"]];
        NSString *_subject = [rs stringForColumn:@"subject"];
        NSString *_message = [rs stringForColumn:@"message"];
        bool _read = [rs boolForColumn:@"read"];
        NSDate *_dateMessage = [rs dateForColumn:@"date_message"];

        KPDMessage *msg = [[KPDMessage alloc] initWithFromUser:fuser toUser:tuser subject:_subject message:_message read:_read date:_dateMessage];

        [listOfMessages addObject:msg];
    }

    [rs close];

    return [[NSArray alloc] initWithArray:listOfMessages];
}

- (bool)messageIsInDatabaseWithUser:(KPDUser *)usera andUser:(KPDUser *)userb withDate:(NSDate *)msgdate
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from message where from_username = ? AND to_username = ? AND date_message = ?", [fromUser username], [toUser username], dateMessage];

    bool has_rows = false;

    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

@end
