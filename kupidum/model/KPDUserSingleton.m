//
//  KPDUserSingleton.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDUserSingleton.h"

@implementation KPDUserSingleton

@synthesize user;

- (id)init
{
    if(self = [super init])
    {
        username = nil;
        user = nil;
    }

    return self;
}

- (void)setUsername:(NSString *)u
{
    username = u;
    user = [[KPDUser alloc] initWithUsername:username];
}

- (NSString *)username
{
    return username;
}

+ (KPDUserSingleton *)sharedInstance
{
    static dispatch_once_t onceToken;
    static KPDUserSingleton *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[KPDUserSingleton alloc] init];
    });
    
    return _instance;
}

@end
