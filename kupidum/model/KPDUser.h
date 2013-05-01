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
    NSString *genderString;
    NSNumber *genderCandidate;
    NSString *genderCandidateString;
    NSDate *dateOfBirth;
    NSString *city;
    NSNumber *professionId;
    NSString *professionString;
    NSNumber *minAgeCandidate;
    NSNumber *maxAgeCandidate;
    NSNumber *minHeightCandidate;
    NSNumber *maxHeightCandidate;

    // User presentation
    NSString *presentation;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) UIImage *avatar;
@property (nonatomic, retain) NSNumber *gender;
@property (nonatomic, retain) NSString *genderString;
@property (nonatomic, retain) NSNumber *genderCandidate;
@property (nonatomic, retain) NSString *genderCandidateString;
@property (nonatomic, retain) NSDate *dateOfBirth;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSNumber *professionId;
@property (nonatomic, retain) NSString *professionString;
@property (nonatomic, retain) NSString *presentation;
@property (nonatomic, retain) NSNumber *minAgeCandidate;
@property (nonatomic, retain) NSNumber *maxAgeCandidate;
@property (nonatomic, retain) NSNumber *minHeightCandidate;
@property (nonatomic, retain) NSNumber *maxHeightCandidate;

- (id)initWithUsername:(NSString *)_username;
- (id)initWithUsername:(NSString *)_username avatarUrl:(NSString *)avatar_url avatar:(UIImage *)avatar_image gender:(int)the_gender genderCandidate:(int)gender_candidate_ dateOfBirth:(NSDate *)date_of_birth city:(NSString *)city_ professionId:(int)profession_id presentation:(NSString *)presentation_ minAgeCandidate:(int)minAgeCand maxAgeCandidate:(int)maxAgeCand minLenghtCandidate:(int)minLenghtCand maxLenghtCandidate:(int)maxLenghtCand;
- (bool)usernameIsInDatabase:(NSString *)_username;
- (void)retrieveDataFromWebService;
- (void)retrieveDataFromDatabase;
- (void)saveToDatabase;
- (NSString *)professionStringFromIdentifier:(int)profession_id;
- (NSString *)genderStringFromIdentifier:(int)gender_id;

@end
