//
//  KPDChatMessage.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDChatMessage.h"
#import "KupidumDBSingleton.h"


@implementation KPDChatMessage

@synthesize fromUser, toUser, message, dateMessage;

- (id)initWithFromUser:(KPDUser *)_fromUser toUser:(KPDUser *)_toUser message:(NSString *)_message date:(NSDate *)_dateMessage
{
    if(self = [super init])
    {
        fromUser = _fromUser;
        toUser = _toUser;
        message = _message;
        dateMessage = _dateMessage;
    }

    return self;
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    NSLog(@"INSERT message | from: %@ to: %@ msg: %@ date: %@", [fromUser username], [toUser username], message, dateMessage);
    [db beginTransaction];
    [db executeUpdate:@"insert into conversation (from_username, to_username, message, date_message) values (?, ?, ?, ?)" , [fromUser username], [toUser username], message, dateMessage];
    [db commit];

}

@end
