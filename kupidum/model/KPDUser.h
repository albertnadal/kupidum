//
//  KPDUser.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPDUser : NSObject
{
    NSString *username;
    NSString *avatarURL;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *avatarURL;

- (id)initWithUsername:(NSString *)_username;

@end
