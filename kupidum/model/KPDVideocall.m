//
//  KPDChat.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDVideocall.h"
#import "KupidumDBSingleton.h"


@implementation KPDVideocall

@synthesize fromUser, toUser, isIncomingCall, dateCall, missed, firstIncomingFrame, length;

- (id)initWithFromUser:(KPDUser *)fuser andToUser:(KPDUser *)tuser andIsIncoming:(bool)isIncoming andDate:(NSDate *)date
{
    if(self = [super init])
    {
        fromUser = fuser;
        toUser = tuser;
        dateCall = date;
        isIncomingCall = isIncoming;
        length = 0;
        missed = true;
        firstIncomingFrame = nil;

        if([self videcallIsInDatabaseWithUser:fromUser andUser:toUser])
            [self reloadVideocall];

        [self retrieveDataFromWebService];
        [self saveToDatabase];
    }

    return self;
}

- (void)retrieveDataFromWebService
{
    //warning Implement this function!
    [fromUser retrieveDataFromWebService];
    [toUser retrieveDataFromWebService];
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    if([self videcallIsInDatabaseWithUser:fromUser andUser:toUser])
    {
        // Update videocall data
        [db beginTransaction];
        [db executeUpdate:@"update videocall set length = ?, first_incoming_frame = ?, is_incoming_call = ?, missed = ?, date_call = ? where from_username = ? AND to_username = ?",[NSNumber numberWithInt:length], UIImagePNGRepresentation(firstIncomingFrame), [NSNumber numberWithBool:isIncomingCall], [NSNumber numberWithBool:missed], dateCall, [fromUser username], [toUser username]];
        [db commit];
    }
    else
    {
        // Insert videocall into db
        [db beginTransaction];
        [db executeUpdate:@"insert into videocall (from_username, to_username, length, first_incoming_frame, is_incoming_call, missed, date_call) values (?, ?, ?, ?, ?, ?, ?)" , [fromUser username], [toUser username], [NSNumber numberWithInt:length], UIImagePNGRepresentation(firstIncomingFrame), [NSNumber numberWithBool:isIncomingCall], [NSNumber numberWithBool:missed], dateCall];
        [db commit];
    }
}

- (bool)videcallIsInDatabaseWithUser:(KPDUser *)usera andUser:(KPDUser *)userb
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from videocall where from_username = ? AND to_username = ?", [usera username], [userb username]];

    bool has_rows = false;

    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

- (void)reloadVideocall
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select length, first_incoming_frame, is_incoming_call, missed, date_call from videocall where from_username = ? AND to_username = ?", [fromUser username], [toUser username]];

    while ([rs next])
    {
        length = [rs intForColumn:@"length"];
        firstIncomingFrame = [UIImage imageWithData:[rs dataForColumn:@"first_incoming_frame"]];
        isIncomingCall = [rs boolForColumn:@"is_incoming_call"];
        missed = [rs boolForColumn:@"missed"];
        dateCall = [rs dateForColumn:@"date_call"];
    }

    [rs close];
}

+ (NSArray *)retrieveVideocallsOfUser:(KPDUser *)user
{
    // Returns a list of chats from user
    NSMutableArray *listOfVideocalls = [[NSMutableArray alloc] init];

    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"SELECT from_username, to_username, is_incoming_call, date_call FROM videocall WHERE from_username = ? OR to_username = ?", [user username], [user username]];

    while ([rs next])
    {
        NSLog(@"from_username: (%@)", [rs stringForColumn:@"from_username"]);
        NSLog(@"to_username: (%@)", [rs stringForColumn:@"to_username"]);
        NSLog(@"last_message: (%@)", [rs stringForColumn:@"last_message"]);

        KPDUser *fuser = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"from_username"]];
        KPDUser *tuser = [[KPDUser alloc] initWithUsername:[rs stringForColumn:@"to_username"]];
        bool _isIncomingCall = [rs boolForColumn:@"is_incoming_call"];
        NSDate *_dateCall = [rs dateForColumn:@"date_call"];

        KPDVideocall *videocall = [[KPDVideocall alloc] initWithFromUser:fuser andToUser:tuser andIsIncoming:_isIncomingCall andDate:_dateCall];
        [videocall reloadVideocall];

        [listOfVideocalls addObject:videocall];
    }

    [rs close];

    return [[NSArray alloc] initWithArray:listOfVideocalls];
}

@end
