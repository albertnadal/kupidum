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
    UIImage *avatar;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) UIImage *avatar;

- (id)initWithUsername:(NSString *)_username;
- (bool)usernameIsInDatabase:(NSString *)_username;
- (void)retrieveDataFromWebService;
- (void)saveToDatabase;

@end
