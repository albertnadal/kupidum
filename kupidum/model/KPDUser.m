//
//  KPDUser.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDUser.h"
#import "KupidumDBSingleton.h"

@implementation KPDUser

@synthesize username, avatarURL, avatar;

- (id)init
{
    if(self = [super init])
    {
        username = nil;
    }

    return self;
}

- (id)initWithUsername:(NSString *)_username
{
    if(self = [super init])
    {
        username = _username;

        // If the user is not in the database then we have to retrieve the full data from web service and save to database
        if(![self usernameIsInDatabase:_username])
        {
            [self retrieveDataFromWebService];
            [self saveToDatabase];
        }
    }

    return self;
}

- (void)retrieveDataFromWebService
{
    //warning Implement this function!
    avatar = [[UIImage alloc] init];
    avatarURL = @"https://twimg0-a.akamaihd.net/profile_images/3070674028/9f2af264ad0fa725337701afe41dbcab.jpeg";
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    if([self usernameIsInDatabase:username])
    {
        // Update user data
        [db beginTransaction];
        [db executeUpdate:@"update user set avatar_url = ?, avatar = ? where username = ?", avatarURL, UIImagePNGRepresentation(avatar), username];
        [db commit];
    }
    else
    {
        // Insert user to db
        [db beginTransaction];
        [db executeUpdate:@"insert into user (username, avatar_url, avatar) values (?, ?, ?)", username, avatarURL, UIImagePNGRepresentation(avatar)];
        [db commit];
    }
}

- (bool)usernameIsInDatabase:(NSString *)_username
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from user where username = ?", _username];

    bool has_rows = false;

    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

@end
