//
//  KPDUserSingleton.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"

@interface KPDUserSingleton : NSObject
{
    KPDUser *user;
    NSString *username;
}

@property (nonatomic, retain) KPDUser *user;

// Class methods
+ (KPDUserSingleton *)sharedInstance;
- (void)setUsername:(NSString *)u;
- (NSString *)username;

@end
