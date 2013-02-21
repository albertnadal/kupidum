//
//  KPDUser.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDUser.h"

@implementation KPDUser

@synthesize username, avatarURL;

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
    }

    return self;
}

@end
