//
//  KPDUserProfile.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUserCandidateProfile.h"
#import "KPDUser.h"

@protocol KPDUserProfileDelegate;

@interface KPDUserProfile : NSObject
{
    // Delegate
    id<KPDUserProfileDelegate> delegate;

    // Username
    NSString *username;

    // Basic information
    NSNumber *gender;
    NSDate *dateOfBirth;
    NSString *city;

    // User presentation
    NSString *presentation;

    // Candidate profile
    KPDUserCandidateProfile *candidateProfile;

    // Pictures
    NSString *faceFrontImageURL;
    UIImage *faceFrontImage;
    NSString *faceProfileImageURL;
    UIImage *faceProfileImage;
    NSString *bodyImageURL;
    UIImage *bodyImage;

    // *** Profile ***
    // My physical appearance
    NSNumber *height;
    NSNumber *weight;
    NSNumber *hairColorId;
    NSNumber *hairSizeId;
    NSNumber *eyeColorId;
    NSNumber *personalityId;
    NSNumber *appearanceId;
    NSNumber *silhouetteId;
    NSNumber *bodyHighlightId;

    // My personal situation
    NSNumber *maritalStatusId;
    NSNumber *hasChildrensId;
    NSNumber *liveWithId;

    // My values
    NSNumber *citizenshipId;
    NSNumber *ethnicalOriginId;
    NSNumber *religionId;
    NSNumber *religionLevelId;
    NSNumber *marriageOpinionId;
    NSNumber *romanticismId;
    NSNumber *wantChildrensId;

    // My professional status
    NSNumber *studiesId;
    NSSet *languagesId;
    NSNumber *professionId;
    NSNumber *salaryId;

    // My lifestyle
    NSNumber *styleId;
    NSNumber *dietId;
    NSNumber *smokeId;
    NSSet *animalsId;

    // My interests
    NSSet *hobbiesId;
    NSSet *sportsId;
    NSSet *sparetimeId;

    // My cultural interests
    NSSet *musicId;
    NSSet *moviesId;
}

@property (nonatomic, retain) id<KPDUserProfileDelegate> delegate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSNumber *gender;
@property (nonatomic, retain) NSDate *dateOfBirth;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *presentation;
@property (nonatomic, retain) KPDUserCandidateProfile *candidateProfile;
@property (nonatomic, retain) NSString *faceFrontImageURL;
@property (nonatomic, retain) UIImage *faceFrontImage;
@property (nonatomic, retain) NSString *faceProfileImageURL;
@property (nonatomic, retain) UIImage *faceProfileImage;
@property (nonatomic, retain) NSString *bodyImageURL;
@property (nonatomic, retain) UIImage *bodyImage;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSNumber *hairColorId;
@property (nonatomic, retain) NSNumber *hairSizeId;
@property (nonatomic, retain) NSNumber *eyeColorId;
@property (nonatomic, retain) NSNumber *personalityId;
@property (nonatomic, retain) NSNumber *appearanceId;
@property (nonatomic, retain) NSNumber *silhouetteId;
@property (nonatomic, retain) NSNumber *bodyHighlightId;
@property (nonatomic, retain) NSNumber *maritalStatusId;
@property (nonatomic, retain) NSNumber *hasChildrensId;
@property (nonatomic, retain) NSNumber *liveWithId;
@property (nonatomic, retain) NSNumber *citizenshipId;
@property (nonatomic, retain) NSNumber *ethnicalOriginId;
@property (nonatomic, retain) NSNumber *religionId;
@property (nonatomic, retain) NSNumber *religionLevelId;
@property (nonatomic, retain) NSNumber *marriageOpinionId;
@property (nonatomic, retain) NSNumber *romanticismId;
@property (nonatomic, retain) NSNumber *wantChildrensId;
@property (nonatomic, retain) NSNumber *studiesId;
@property (nonatomic, retain) NSSet *languagesId;
@property (nonatomic, retain) NSNumber *professionId;
@property (nonatomic, retain) NSNumber *salaryId;
@property (nonatomic, retain) NSNumber *styleId;
@property (nonatomic, retain) NSNumber *dietId;
@property (nonatomic, retain) NSNumber *smokeId;
@property (nonatomic, retain) NSSet *animalsId;
@property (nonatomic, retain) NSSet *hobbiesId;
@property (nonatomic, retain) NSSet *sportsId;
@property (nonatomic, retain) NSSet *sparetimeId;
@property (nonatomic, retain) NSSet *musicId;
@property (nonatomic, retain) NSSet *moviesId;

- (id)initWithUsername:(NSString *)_username andDelegate:(id<KPDUserProfileDelegate>)theDelegate;
- (bool)usernameIsInDatabase:(NSString *)_username;
- (void)retrieveDataFromWebService;
- (void)retrieveDataFromDatabase;
- (void)saveToDatabase;
- (NSSet *)retrieveNSSetFromString:(NSString *)string_;

@end

@protocol KPDUserProfileDelegate

@optional

- (void)userProfile:(KPDUserProfile *)profile didRetrievedFrontFaceImage:(UIImage *)image;
- (void)userProfile:(KPDUserProfile *)profile didRetrievedFaceProfileImage:(UIImage *)image;
- (void)userProfile:(KPDUserProfile *)profile didRetrievedBodyImage:(UIImage *)image;

@end
