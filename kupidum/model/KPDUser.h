//
//  KPDUser.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum UserGender
{
    kMale = 0,
    kFemale = 1
}UserGender;

@interface KPDUser : NSObject
{
    NSString *username;
    NSString *avatarURL;
    UIImage *avatar;

    // Basic information
    NSNumber *gender;
    NSNumber *genderCandidate;
    NSDate *dateOfBirth;
    NSString *city;
    NSNumber *professionId;
    NSString *profession;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) UIImage *avatar;
@property (nonatomic, retain) NSNumber *gender;
@property (nonatomic, retain) NSNumber *genderCandidate;
@property (nonatomic, retain) NSDate *dateOfBirth;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSNumber *professionId;
@property (nonatomic, retain) NSString *profession;

- (id)initWithUsername:(NSString *)_username;
- (id)initWithUsername:(NSString *)_username avatarUrl:(NSString *)avatar_url gender:(int)the_gender genderCandidate:(int)gender_candidate_ dateOfBirth:(NSDate *)date_of_birth city:(NSString *)city_ professionId:(int)profession_id;
- (bool)usernameIsInDatabase:(NSString *)_username;
- (void)retrieveDataFromWebService;
- (void)saveToDatabase;
- (NSString *)professionStringFromIdentifier:(int)profession_id;

@end
