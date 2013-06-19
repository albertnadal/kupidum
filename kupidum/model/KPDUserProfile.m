//
//  KPDUserProfile.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDUserProfile.h"
#import "KupidumDBSingleton.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileFormDataSource.h"

@implementation KPDUserProfile

@synthesize delegate, username, candidateProfile;
@synthesize city, gender, dateOfBirth, presentation;
@synthesize faceFrontImageURL, faceFrontImage, faceProfileImageURL, faceProfileImage, bodyImageURL, bodyImage;
@synthesize height, weight, hairColorId, hairSizeId, eyeColorId, personalityId, appearanceId, silhouetteId, bodyHighlightId;
@synthesize maritalStatusId, hasChildrensId, liveWithId, citizenshipId, ethnicalOriginId, religionId, religionLevelId;
@synthesize marriageOpinionId, romanticismId, wantChildrensId;
@synthesize studiesId, languagesId, professionId, salaryId;
@synthesize styleId, dietId, smokeId, animalsId;
@synthesize hobbiesId, sportsId, sparetimeId;
@synthesize musicId, moviesId;

- (id)init
{
    if(self = [super init])
    {
        username = nil;
        candidateProfile = nil;
    }

    return self;
}

- (id)initWithUsername:(NSString *)_username andDelegate:(id<KPDUserProfileDelegate>)theDelegate
{
    if(self = [super init])
    {
        self.username = _username;
        self.delegate = theDelegate;

        self.gender = nil;
        self.city = nil;
        self.dateOfBirth = nil;
        self.presentation = nil;
        self.candidateProfile = [[KPDUserCandidateProfile alloc] initWithUsername:username];
        self.faceFrontImageURL = nil;
        self.faceFrontImage = nil;
        self.faceProfileImageURL = nil;
        self.faceProfileImage = nil;
        self.bodyImageURL = nil;
        self.bodyImage = nil;
        self.height = nil;
        self.weight = nil;
        self.hairColorId = nil;
        self.hairSizeId = nil;
        self.eyeColorId = nil;
        self.personalityId = nil;
        self.appearanceId = nil;
        self.silhouetteId = nil;
        self.bodyHighlightId = nil;
        self.maritalStatusId = nil;
        self.hasChildrensId = nil;
        self.liveWithId = nil;
        self.citizenshipId = nil;
        self.ethnicalOriginId = nil;
        self.religionId = nil;
        self.religionLevelId = nil;
        self.marriageOpinionId = nil;
        self.romanticismId = nil;
        self.wantChildrensId = nil;
        self.studiesId = nil;
        self.languagesId = nil;
        self.professionId = nil;
        self.salaryId = nil;
        self.styleId = nil;
        self.dietId = nil;
        self.smokeId = nil;
        self.animalsId = nil;
        self.hobbiesId = nil;
        self.sportsId = nil;
        self.sparetimeId = nil;
        self.musicId = nil;
        self.moviesId = nil;

        // If the user is not in the database then we have to retrieve the full data from web service and save to database
        if(![self usernameIsInDatabase:_username])
        {
            [self retrieveDataFromWebService];
            [self saveToDatabase];
        }
        else
        {
            [self retrieveDataFromDatabase];
        }
    }

    return self;
}

- (NSSet *)retrieveNSSetFromString:(NSString *)string_
{
    NSArray *splitStringValues = [string_ componentsSeparatedByString:@","];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSString *stringValue;
    for(stringValue in splitStringValues)
        [resultArray addObject:[NSNumber numberWithInt:[stringValue integerValue]]];

    return [NSSet setWithArray:resultArray];
}

- (void)retrieveDataFromDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select * from user_profile where username = ?", self.username];

    while ([rs next])
    {
        self.gender = [NSNumber numberWithInt:[rs intForColumn:@"gender"]];
        self.dateOfBirth = [rs dateForColumn:@"date_of_birth"];
        self.presentation = [rs stringForColumn:@"presentation"];
        self.city = [rs stringForColumn:@"city"];

        self.faceFrontImageURL = [rs stringForColumn:@"face_front_image_url"];
        NSData *faceFrontImageData = [rs dataForColumn:@"face_front_image"];
        if([faceFrontImageData length])
            self.faceFrontImage = [[UIImage alloc] initWithData:faceFrontImageData];

        self.faceProfileImageURL = [rs stringForColumn:@"face_profile_image_url"];
        NSData *faceProfileImageData = [rs dataForColumn:@"face_profile_image"];
        if([faceProfileImageData length])
            self.faceProfileImage = [[UIImage alloc] initWithData:faceProfileImageData];

        self.bodyImageURL = [rs stringForColumn:@"body_image_url"];
        NSData *faceBodyImageData = [rs dataForColumn:@"body_image"];
        if([faceBodyImageData length])
            self.bodyImage = [[UIImage alloc] initWithData:faceBodyImageData];

        self.height = [NSNumber numberWithInt:[rs intForColumn:@"height"]];
        self.weight = [NSNumber numberWithInt:[rs intForColumn:@"weight"]];
        self.hairColorId = [NSNumber numberWithInt:[rs intForColumn:@"hair_color_id"]];
        self.hairSizeId = [NSNumber numberWithInt:[rs intForColumn:@"hair_size_id"]];
        self.eyeColorId = [NSNumber numberWithInt:[rs intForColumn:@"eye_color_id"]];
        self.personalityId = [NSNumber numberWithInt:[rs intForColumn:@"personality_id"]];
        self.appearanceId = [NSNumber numberWithInt:[rs intForColumn:@"appearance_id"]];
        self.silhouetteId = [NSNumber numberWithInt:[rs intForColumn:@"silhouette_id"]];
        self.bodyHighlightId = [NSNumber numberWithInt:[rs intForColumn:@"body_highlight_id"]];
        self.maritalStatusId = [NSNumber numberWithInt:[rs intForColumn:@"marital_status_id"]];
        self.hasChildrensId = [NSNumber numberWithInt:[rs intForColumn:@"has_childrens_id"]];
        self.liveWithId = [NSNumber numberWithInt:[rs intForColumn:@"live_with_id"]];
        self.citizenshipId = [NSNumber numberWithInt:[rs intForColumn:@"citizenship_id"]];
        self.ethnicalOriginId = [NSNumber numberWithInt:[rs intForColumn:@"ethnical_origin_id"]];
        self.religionId = [NSNumber numberWithInt:[rs intForColumn:@"religion_id"]];
        self.religionLevelId = [NSNumber numberWithInt:[rs intForColumn:@"religion_level_id"]];
        self.marriageOpinionId = [NSNumber numberWithInt:[rs intForColumn:@"marriage_opinion_id"]];
        self.romanticismId = [NSNumber numberWithInt:[rs intForColumn:@"romanticism_id"]];
        self.wantChildrensId = [NSNumber numberWithInt:[rs intForColumn:@"want_childrens_id"]];
        self.studiesId = [NSNumber numberWithInt:[rs intForColumn:@"studies_id"]];
        self.languagesId = [self retrieveNSSetFromString:[rs stringForColumn:@"languages_id"]];
        self.professionId = [NSNumber numberWithInt:[rs intForColumn:@"profession_id"]];
        self.salaryId = [NSNumber numberWithInt:[rs intForColumn:@"salary_id"]];
        self.styleId = [NSNumber numberWithInt:[rs intForColumn:@"style_id"]];
        self.dietId = [NSNumber numberWithInt:[rs intForColumn:@"diet_id"]];
        self.smokeId = [NSNumber numberWithInt:[rs intForColumn:@"smoke_id"]];
        self.animalsId = [self retrieveNSSetFromString:[rs stringForColumn:@"animals_id"]];
        self.hobbiesId = [self retrieveNSSetFromString:[rs stringForColumn:@"hobbies_id"]];
        self.sportsId = [self retrieveNSSetFromString:[rs stringForColumn:@"sports_id"]];
        self.sparetimeId = [self retrieveNSSetFromString:[rs stringForColumn:@"sparetime_id"]];
        self.musicId = [self retrieveNSSetFromString:[rs stringForColumn:@"music_id"]];
        self.moviesId = [self retrieveNSSetFromString:[rs stringForColumn:@"movies_id"]];
    }
    
    [rs close];

    // retrieve the user candidate profile data
    [self.candidateProfile retrieveDataFromDatabase];
}

- (void)retrieveDataFromWebService
{
    // User profile
/*    self.gender = [NSNumber numberWithInt:kMale];

    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:26];
    [components setMonth:9];
    [components setYear:1981];
    self.dateOfBirth = [[NSCalendar currentCalendar] dateFromComponents:components];

    self.presentation = @"I was working from year 2005 to the begining of 2008 at ArenaMobile (Reus, Spain), a global multimedia mobile content provider that worked with partners like Vodafone, Movistar, Orange, Claro and many other telcos worldwide. At 2008 I joined the Internet Web Serveis company (Lleida, Spain), just coinciding with the arrival of the first iPhone SDK from Apple to the mobile market. IWS is a local ISP that provides all kind of custom made Internet web services with customers like Terra, Grupo Prisa or Fon.";
    self.city = @"Girona";
    self.faceFrontImageURL = @"";
    self.faceFrontImage = [[UIImage alloc] init];
    self.faceProfileImageURL = @"";
    self.faceProfileImage = [[UIImage alloc] init];
    self.bodyImageURL = @"";
    self.bodyImage = [[UIImage alloc] init];*/
//    self.height = @180; // 180cm
//    self.weight = @85; // 85kg
//    self.hairColorId = @3; // Moreno
//    self.hairSizeId = @4; // Semillarg
//    self.eyeColorId = @6; // Negres
//    self.personalityId = @15; // Despreocupat
//    self.silhouetteId = @2; // Esportiva
//    self.bodyHighlightId = @1; // Els ulls
//    self.maritalStatusId = @1; // No casat mai
//    self.hasChildrensId = @1; // Cap
//    self.liveWithId = @5; // En un pis compartit
//    self.citizenshipId = @6; // Andorrana
//    self.ethnicalOriginId = @1; // Europeu
//    self.religionId = @25; // Cristià
//    self.religionLevelId = @3; // No practicant
//    self.marriageOpinionId = @5; // Impensable
//    self.romanticismId = @4; // Gens romàntic
//    self.wantChildrensId = @2; // Si, 1
//    self.studiesId = @5; // Llicenciat
//    self.languagesId = [NSSet setWithObjects:@4, @22, @13, nil]; // Anglès, Francès, Català
//    self.professionId = @42; // Metge
//    self.salaryId = @4; // De 30 a 50.000€/any
//    self.styleId = @5; // Despreocupat
//    self.dietId = @1; // Menja de tot
//    self.smokeId = @1; // Si, ocasionalment
//    self.animalsId = [NSSet setWithObjects:@9, @2, nil]; // Conill, Gos
//    self.hobbiesId = [NSSet setWithObjects:@22, @7, nil]; // Fotos, Música
//    self.sportsId = [NSSet setWithObjects:@25, @19, nil]; // Tenis, Surf
//    self.sparetimeId = [NSSet setWithObjects:@9, @7, nil]; // Cinema, Concert
//    self.musicId = [NSSet setWithObjects:@11, nil]; // Pop-Rock
//    self.moviesId = [NSSet setWithObjects:@2, nil]; // Acció

    // User candidate profile
/*    self.candidateProfile.minAge = @25;
    self.candidateProfile.maxAge = @35;
    self.candidateProfile.minHeight = @160;
    self.candidateProfile.maxHeight = @180;
    self.candidateProfile.minWeight = @55;
    self.candidateProfile.maxWeight = @65;
    self.candidateProfile.maritalStatusId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.whereIsLivingId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.wantChildrensId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.hasChildrensId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.silhouetteID = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.mainCharacteristicId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.isRomanticId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.marriageIsId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.smokesId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.dietId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.nationId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.ethnicalOriginId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.bodyLookId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.hairSizeId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.hairColorId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.eyeColorId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.styleId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.highlightId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.studiesMinLevelId = @1;
    self.candidateProfile.studiesMaxLevelId = @2;
    self.candidateProfile.languagesId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.religionId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.religionLevelId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.hobbiesId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.sparetimeId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.musicId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.moviesId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.animalsId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.sportsId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.businessId = [NSSet setWithObjects:@1, @2, nil];
    self.candidateProfile.minSalaryId = @1;
    self.candidateProfile.maxSalaryId = @2;*/


//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.mode = MBProgressHUDAnimationFade;
//    self.hud.labelText = NSLocalizedString(@"Loading data...", @"");

    NSURL *url = [NSURL URLWithString:@"http://www.albertnadal.cat/ws/v1/profile.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //json parse

    NSDictionary *profileData = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSLog(@"App.net Global Stream: %@", profileData);

    // Set the basic user home information
    NSDictionary *userBasicInformation = [profileData objectForKey:@"userBasicInformation"];

    self.gender = [userBasicInformation objectForKey:@"gender"];
    self.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)[userBasicInformation objectForKey:@"dateOfBirth"] intValue]];
    self.presentation = [userBasicInformation objectForKey:@"presentation"];
    self.city = [userBasicInformation objectForKey:@"city"];

    self.faceFrontImageURL = [userBasicInformation objectForKey:@"frontFaceImageUrl"];
    self.faceFrontImage = [[UIImage alloc] init];
    if([self.faceFrontImageURL length])
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.faceFrontImageURL]];
        [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             self.faceFrontImage = image;
             if([(id)self.delegate respondsToSelector:@selector(userProfile:didRetrievedFrontFaceImage:)])
                 [self.delegate userProfile:self didRetrievedFrontFaceImage:self.faceFrontImage];
             [self saveToDatabase];
         } failure:nil];
    }


    self.faceProfileImageURL = [userBasicInformation objectForKey:@"profileFaceImageUrl"];
    self.faceProfileImage = [[UIImage alloc] init];
    if([self.faceProfileImageURL length])
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.faceProfileImageURL]];
        [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             self.faceProfileImage = image;
             if([(id)self.delegate respondsToSelector:@selector(userProfile:didRetrievedFaceProfileImage:)])
                 [self.delegate userProfile:self didRetrievedFaceProfileImage:self.faceProfileImage];
             [self saveToDatabase];
         } failure:nil];
    }


    self.bodyImageURL = [userBasicInformation objectForKey:@"bodyImageUrl"];
    self.bodyImage = [[UIImage alloc] init];
    if([self.bodyImageURL length])
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.bodyImageURL]];
        [[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             self.bodyImage = image;
             if([(id)self.delegate respondsToSelector:@selector(userProfile:didRetrievedBodyImage:)])
                 [self.delegate userProfile:self didRetrievedBodyImage:self.bodyImage];
             [self saveToDatabase];
         } failure:nil];
    }


    // Set the user description
    NSDictionary *userDescription = [profileData objectForKey:@"userDescription"];

    self.height = [userDescription objectForKey:kHeightUserProfileField];
    self.weight = [userDescription objectForKey:kWeightUserProfileField];
    self.hairColorId = [userDescription objectForKey:kHairColorUserProfileField];
    self.hairSizeId = [userDescription objectForKey:kHairSizeUserProfileField];
    self.eyeColorId = [userDescription objectForKey:kEyeColorUserProfileField];
    self.personalityId = [userDescription objectForKey:kMainCharacteristicUserProfileField];
    self.appearanceId = [userDescription objectForKey:kBodyLookUserProfileField];
    self.silhouetteId = [userDescription objectForKey:kSilhouetteUserProfileField];
    self.maritalStatusId = [userDescription objectForKey:kMaritalStatusUserProfileField];
    self.hasChildrensId = [userDescription objectForKey:kHasChildrensUserProfileField];
    self.liveWithId = [userDescription objectForKey:kWhereIsLivingUserProfileField];
    self.bodyHighlightId = [userDescription objectForKey:kMyHighlightUserProfileField];
    self.citizenshipId = [userDescription objectForKey:kNationUserProfileField];
    self.ethnicalOriginId = [userDescription objectForKey:kEthnicalOriginUserProfileField];
    self.religionId = [userDescription objectForKey:kReligionUserProfileField];
    self.religionLevelId = [userDescription objectForKey:kReligionLevelUserProfileField];
    self.marriageOpinionId = [userDescription objectForKey:kMarriageOpinionUserProfileField];
    self.romanticismId = [userDescription objectForKey:kRomanticismLevelUserProfileField];
    self.wantChildrensId = [userDescription objectForKey:kIWantChildrensUserProfileField];
    self.studiesId = [userDescription objectForKey:kStudiesLevelUserProfileField];
    self.languagesId = [userDescription objectForKey:kLanguagesUserProfileField];
    self.professionId = [userDescription objectForKey:kMyBusinessUserProfileField];
    self.salaryId = [userDescription objectForKey:kSalaryUserProfileField];
    self.styleId = [userDescription objectForKey:kMyStyleUserProfileField];
    self.dietId = [userDescription objectForKey:kAlimentUserProfileField];
    self.smokeId = [userDescription objectForKey:kSmokeUserProfileField];
    self.animalsId = [userDescription objectForKey:kAnimalsUserProfileField];
    self.hobbiesId = [userDescription objectForKey:kMyHobbiesUserProfileField];
    self.sportsId = [userDescription objectForKey:kMySportsUserProfileField];
    self.sparetimeId = [userDescription objectForKey:kMySparetimeUserProfileField];
    self.musicId = [userDescription objectForKey:kMusicUserProfileField];
    self.moviesId = [userDescription objectForKey:kMoviesUserProfileField];


    // Set the user candidate description
    NSDictionary *candidateDescription = [profileData objectForKey:@"candidateDescription"];

    self.candidateProfile.minAge = [candidateDescription objectForKey:kMinAgeCandidateProfileField];
    self.candidateProfile.maxAge = [candidateDescription objectForKey:kMaxAgeCandidateProfileField];
    self.candidateProfile.minHeight = [candidateDescription objectForKey:kMinHeightCandidateProfileField];
    self.candidateProfile.maxHeight = [candidateDescription objectForKey:kMaxHeightCandidateProfileField];
    self.candidateProfile.minWeight = [candidateDescription objectForKey:kMinWeightCandidateProfileField];
    self.candidateProfile.maxWeight = [candidateDescription objectForKey:kMaxWeightCandidateProfileField];
    self.candidateProfile.maritalStatusId = [candidateDescription objectForKey:kMaritalStatusCandidateProfileField];
    self.candidateProfile.whereIsLivingId = [candidateDescription objectForKey:kWhereIsLivingCandidateProfileField];
    self.candidateProfile.wantChildrensId = [candidateDescription objectForKey:kWantChildrensCandidateProfileField];
    self.candidateProfile.hasChildrensId = [candidateDescription objectForKey:kHasChildrensCandidateProfileField];
    self.candidateProfile.silhouetteID = [candidateDescription objectForKey:kSilhouetteCandidateProfileField];
    self.candidateProfile.mainCharacteristicId = [candidateDescription objectForKey:kMainCharacteristicCandidateProfileField];
    self.candidateProfile.isRomanticId = [candidateDescription objectForKey:kIsRomanticCandidateProfileField];
    self.candidateProfile.marriageIsId = [candidateDescription objectForKey:kMarriageIsCandidateProfileField];
    self.candidateProfile.smokesId = [candidateDescription objectForKey:kSmokesCandidateProfileField];
    self.candidateProfile.dietId = [candidateDescription objectForKey:kDietCandidateProfileField];
    self.candidateProfile.nationId = [candidateDescription objectForKey:kNationCandidateProfileField];
    self.candidateProfile.ethnicalOriginId = [candidateDescription objectForKey:kEthnicalOriginCandidateProfileField];
    self.candidateProfile.bodyLookId = [candidateDescription objectForKey:kBodyLookCandidateProfileField];
    self.candidateProfile.hairSizeId = [candidateDescription objectForKey:kHairSizeCandidateProfileField];
    self.candidateProfile.hairColorId = [candidateDescription objectForKey:kHairColorCandidateProfileField];
    self.candidateProfile.eyeColorId = [candidateDescription objectForKey:kEyeColorCandidateProfileField];
    self.candidateProfile.styleId = [candidateDescription objectForKey:kStyleCandidateProfileField];
    self.candidateProfile.highlightId = [candidateDescription objectForKey:kHighlightCandidateProfileField];
    self.candidateProfile.studiesMinLevelId = [candidateDescription objectForKey:kStudiesMinLevelCandidateProfileField];
    self.candidateProfile.studiesMaxLevelId = [candidateDescription objectForKey:kStudiesMaxLevelCandidateProfileField];
    self.candidateProfile.languagesId = [candidateDescription objectForKey:kLanguagesCandidateProfileField];
    self.candidateProfile.religionId = [candidateDescription objectForKey:kReligionCandidateProfileField];
    self.candidateProfile.religionLevelId = [candidateDescription objectForKey:kReligionLevelCandidateProfileField];
    self.candidateProfile.hobbiesId = [candidateDescription objectForKey:kHobbiesCandidateProfileField];
    self.candidateProfile.sparetimeId = [candidateDescription objectForKey:kSparetimeCandidateProfileField];
    self.candidateProfile.musicId = [candidateDescription objectForKey:kMusicCandidateProfileField];
    self.candidateProfile.moviesId = [candidateDescription objectForKey:kMoviesCandidateProfileField];
    self.candidateProfile.animalsId = [candidateDescription objectForKey:kAnimalsCandidateProfileField];
    self.candidateProfile.sportsId = [candidateDescription objectForKey:kSportsCandidateProfileField];
    self.candidateProfile.businessId = [candidateDescription objectForKey:kBusinessCandidateProfileField];
    self.candidateProfile.minSalaryId = [candidateDescription objectForKey:kMinSalaryCandidateProfileField];
    self.candidateProfile.maxSalaryId = [candidateDescription objectForKey:kMaxSalaryCandidateProfileField];

    [self saveToDatabase];

/*

 // User candidate preferences
 [self assignDefaultObject:user_profile.candidateProfile.minAge toModel:model forKey:kMinAgeCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.maxAge toModel:model forKey:kMaxAgeCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.minHeight toModel:model forKey:kMinHeightCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.maxHeight toModel:model forKey:kMaxHeightCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.minWeight toModel:model forKey:kMinWeightCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.maxWeight toModel:model forKey:kMaxWeightCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.maritalStatusId toModel:model forKey:kMaritalStatusCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.whereIsLivingId toModel:model forKey:kWhereIsLivingCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.wantChildrensId toModel:model forKey:kWantChildrensCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.hasChildrensId toModel:model forKey:kHasChildrensCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.silhouetteID toModel:model forKey:kSilhouetteCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.mainCharacteristicId toModel:model forKey:kMainCharacteristicCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.isRomanticId toModel:model forKey:kIsRomanticCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.marriageIsId toModel:model forKey:kMarriageIsCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.smokesId toModel:model forKey:kSmokesCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.dietId toModel:model forKey:kDietCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.nationId toModel:model forKey:kNationCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.ethnicalOriginId toModel:model forKey:kEthnicalOriginCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.bodyLookId toModel:model forKey:kBodyLookCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.hairSizeId toModel:model forKey:kHairSizeCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.hairColorId toModel:model forKey:kHairColorCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.eyeColorId toModel:model forKey:kEyeColorCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.styleId toModel:model forKey:kStyleCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.highlightId toModel:model forKey:kHighlightCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.studiesMinLevelId toModel:model forKey:kStudiesMinLevelCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.studiesMaxLevelId toModel:model forKey:kStudiesMaxLevelCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.languagesId toModel:model forKey:kLanguagesCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.religionId toModel:model forKey:kReligionCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.religionLevelId toModel:model forKey:kReligionLevelCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.hobbiesId toModel:model forKey:kHobbiesCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.sparetimeId toModel:model forKey:kSparetimeCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.musicId toModel:model forKey:kMusicCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.moviesId toModel:model forKey:kMoviesCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.animalsId toModel:model forKey:kAnimalsCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.sportsId toModel:model forKey:kSportsCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.businessId toModel:model forKey:kBusinessCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.minSalaryId toModel:model forKey:kMinSalaryCandidateProfileField];
 [self assignDefaultObject:user_profile.candidateProfile.maxSalaryId toModel:model forKey:kMaxSalaryCandidateProfileField];
 
 return model;*/
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    NSString *languagesIdString = [[self.languagesId allObjects] componentsJoinedByString:@","];
    NSString *animalsIdString = [[self.animalsId allObjects] componentsJoinedByString:@","];
    NSString *hobbiesIdString = [[self.hobbiesId allObjects] componentsJoinedByString:@","];
    NSString *sportsIdString = [[self.sportsId allObjects] componentsJoinedByString:@","];
    NSString *sparetimeIdString = [[self.sparetimeId allObjects] componentsJoinedByString:@","];
    NSString *musicIdString = [[self.musicId allObjects] componentsJoinedByString:@","];
    NSString *moviesIdString = [[self.moviesId allObjects] componentsJoinedByString:@","];

    if([self usernameIsInDatabase:username])
    {
        // Update user data
        [db beginTransaction];
        [db executeUpdate:@"update user_profile set gender = ?, date_of_birth = ?, city = ?, presentation = ?, face_front_image_url = ?, face_front_image = ?, face_profile_image_url = ?, face_profile_image = ?, body_image_url = ?, body_image = ?, height = ?, weight = ?, hair_color_id = ?, hair_size_id = ?, eye_color_id = ?, personality_id = ?, appearance_id = ?, silhouette_id = ?, body_highlight_id = ?, marital_status_id = ?, has_childrens_id = ?, live_with_id = ?, citizenship_id = ?, ethnical_origin_id = ?, religion_id = ?, religion_level_id = ?, marriage_opinion_id = ?, romanticism_id = ?, want_childrens_id = ?, studies_id = ?, languages_id = ?, profession_id = ?, salary_id = ?, style_id = ?, diet_id = ?, smoke_id = ?, animals_id = ?, hobbies_id = ?, sports_id = ?, sparetime_id = ?, music_id = ?, movies_id = ? where username = ?", self.gender, self.dateOfBirth, self.city, self.presentation, self.faceFrontImageURL, UIImagePNGRepresentation(self.faceFrontImage), self.faceProfileImageURL, UIImagePNGRepresentation(self.faceProfileImage), self.bodyImageURL, UIImagePNGRepresentation(self.bodyImage), self.height, self.weight, self.hairColorId, self.hairSizeId, self.eyeColorId, self.personalityId, self.appearanceId, self.silhouetteId, self.bodyHighlightId, self.maritalStatusId, self.hasChildrensId, self.liveWithId, self.citizenshipId, self.ethnicalOriginId, self.religionId, self.religionLevelId, self.marriageOpinionId, self.romanticismId, self.wantChildrensId, self.studiesId, languagesIdString, self.professionId, self.salaryId, self.styleId, self.dietId, self.smokeId, animalsIdString, hobbiesIdString, sportsIdString, sparetimeIdString, musicIdString, moviesIdString, self.username];
        [db commit];
    }
    else
    {
        // Insert user to db
        [db beginTransaction];
        [db executeUpdate:@"insert into user_profile (username, gender, date_of_birth, city, presentation, face_front_image_url, face_front_image, face_profile_image_url, face_profile_image, body_image_url, body_image, height, weight, hair_color_id, hair_size_id, eye_color_id, personality_id, appearance_id, silhouette_id, body_highlight_id, marital_status_id, has_childrens_id, live_with_id, citizenship_id, ethnical_origin_id, religion_id, religion_level_id, marriage_opinion_id, romanticism_id, want_childrens_id, studies_id, languages_id, profession_id, salary_id, style_id, diet_id, smoke_id, animals_id, hobbies_id, sports_id, sparetime_id, music_id, movies_id) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", username, self.gender, self.dateOfBirth, self.city, self.presentation, self.faceFrontImageURL, UIImagePNGRepresentation(self.faceFrontImage), self.faceProfileImageURL, UIImagePNGRepresentation(self.faceProfileImage), self.bodyImageURL, UIImagePNGRepresentation(self.bodyImage), self.height, self.weight, self.hairColorId, self.hairSizeId, self.eyeColorId, self.personalityId, self.appearanceId, self.silhouetteId, self.bodyHighlightId, self.maritalStatusId, self.hasChildrensId, self.liveWithId, self.citizenshipId, self.ethnicalOriginId, self.religionId, self.religionLevelId, self.marriageOpinionId, self.romanticismId, self.wantChildrensId, self.studiesId, languagesIdString, self.professionId, self.salaryId, self.styleId, self.dietId, self.smokeId, animalsIdString, hobbiesIdString, sportsIdString, sparetimeIdString, musicIdString, moviesIdString];
        [db commit];
    }

    // Also save the user candidate profile to db
    [self.candidateProfile saveToDatabase];
}

- (bool)usernameIsInDatabase:(NSString *)_username
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from user_profile where username = ?", _username];

    bool has_rows = false;

    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

@end
