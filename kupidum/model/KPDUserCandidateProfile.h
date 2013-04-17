//
//  KPDUserCandidateProfile.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 15/04/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPDUserCandidateProfile : NSObject
{
    // Username
    NSString *username;

    // *** Candidate profile ***
    NSNumber *minAge;
    NSNumber *maxAge;
    NSNumber *minHeight;
    NSNumber *maxHeight;
    NSNumber *minWeight;
    NSNumber *maxWeight;
    NSSet *maritalStatusId;
    NSSet *whereIsLivingId;
    NSSet *wantChildrensId;
    NSSet *hasChildrensId;
    NSSet *silhouetteID;
    NSSet *mainCharacteristicId;
    NSSet *isRomanticId;
    NSSet *marriageIsId;
    NSSet *smokesId;
    NSSet *dietId;
    NSSet *nationId;
    NSSet *ethnicalOriginId;
    NSSet *bodyLookId;
    NSSet *hairSizeId;
    NSSet *hairColorId;
    NSSet *eyeColorId;
    NSSet *styleId;
    NSSet *highlightId;
    NSNumber *studiesMinLevelId;
    NSNumber *studiesMaxLevelId;
    NSSet *languagesId;
    NSSet *religionId;
    NSSet *religionLevelId;
    NSSet *hobbiesId;
    NSSet *sparetimeId;
    NSSet *musicId;
    NSSet *moviesId;
    NSSet *animalsId;
    NSSet *sportsId;
    NSSet *businessId;
    NSNumber *minSalaryId;
    NSNumber *maxSalaryId;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSNumber *minAge;
@property (nonatomic, retain) NSNumber *maxAge;
@property (nonatomic, retain) NSNumber *minHeight;
@property (nonatomic, retain) NSNumber *maxHeight;
@property (nonatomic, retain) NSNumber *minWeight;
@property (nonatomic, retain) NSNumber *maxWeight;
@property (nonatomic, retain) NSSet *maritalStatusId;
@property (nonatomic, retain) NSSet *whereIsLivingId;
@property (nonatomic, retain) NSSet *wantChildrensId;
@property (nonatomic, retain) NSSet *hasChildrensId;
@property (nonatomic, retain) NSSet *silhouetteID;
@property (nonatomic, retain) NSSet *mainCharacteristicId;
@property (nonatomic, retain) NSSet *isRomanticId;
@property (nonatomic, retain) NSSet *marriageIsId;
@property (nonatomic, retain) NSSet *smokesId;
@property (nonatomic, retain) NSSet *dietId;
@property (nonatomic, retain) NSSet *nationId;
@property (nonatomic, retain) NSSet *ethnicalOriginId;
@property (nonatomic, retain) NSSet *bodyLookId;
@property (nonatomic, retain) NSSet *hairSizeId;
@property (nonatomic, retain) NSSet *hairColorId;
@property (nonatomic, retain) NSSet *eyeColorId;
@property (nonatomic, retain) NSSet *styleId;
@property (nonatomic, retain) NSSet *highlightId;
@property (nonatomic, retain) NSNumber *studiesMinLevelId;
@property (nonatomic, retain) NSNumber *studiesMaxLevelId;
@property (nonatomic, retain) NSSet *languagesId;
@property (nonatomic, retain) NSSet *religionId;
@property (nonatomic, retain) NSSet *religionLevelId;
@property (nonatomic, retain) NSSet *hobbiesId;
@property (nonatomic, retain) NSSet *sparetimeId;
@property (nonatomic, retain) NSSet *musicId;
@property (nonatomic, retain) NSSet *moviesId;
@property (nonatomic, retain) NSSet *animalsId;
@property (nonatomic, retain) NSSet *sportsId;
@property (nonatomic, retain) NSSet *businessId;
@property (nonatomic, retain) NSNumber *minSalaryId;
@property (nonatomic, retain) NSNumber *maxSalaryId;

- (id)initWithUsername:(NSString *)_username;
- (bool)usernameIsInDatabase:(NSString *)_username;
- (void)retrieveDataFromDatabase;
- (void)saveToDatabase;
- (NSSet *)retrieveNSSetFromString:(NSString *)string_;

@end
