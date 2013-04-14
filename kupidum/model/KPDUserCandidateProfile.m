//
//  KPDUserCandidateProfile.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 15/04/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDUserCandidateProfile.h"
#import "KupidumDBSingleton.h"

@implementation KPDUserCandidateProfile

@synthesize username;
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
    }

    return self;
}

- (id)initWithUsername:(NSString *)_username
{
    if(self = [super init])
    {
        username = _username;

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
        self.faceFrontImageURL = [rs stringForColumn:@"face_front_image_url"];
        self.faceFrontImage = [[UIImage alloc] initWithData:[rs dataForColumn:@"face_front_image"]];
        self.faceProfileImageURL = [rs stringForColumn:@"face_profile_image_url"];
        self.faceProfileImage = [[UIImage alloc] initWithData:[rs dataForColumn:@"face_profile_image"]];
        self.bodyImageURL = [rs stringForColumn:@"body_image_url"];
        self.bodyImage = [[UIImage alloc] initWithData:[rs dataForColumn:@"body_image"]];

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
}

- (void)retrieveDataFromWebService
{
#warning Implement this function

    self.faceFrontImageURL = @"";
    self.faceFrontImage = [[UIImage alloc] init];
    self.faceProfileImageURL = @"";
    self.faceProfileImage = [[UIImage alloc] init];
    self.bodyImageURL = @"";
    self.bodyImage = [[UIImage alloc] init];

    self.height = @180; // 180cm
    self.weight = @85; // 85kg
    self.hairColorId = @3; // Moreno
    self.hairSizeId = @4; // Semillarg
    self.eyeColorId = @6; // Negres
    self.personalityId = @15; // Despreocupat
    self.appearanceId = @3; // Agradable de veure
    self.silhouetteId = @2; // Esportiva
    self.bodyHighlightId = @1; // Els ulls
    self.maritalStatusId = @1; // No casat mai
    self.hasChildrensId = @1; // Cap
    self.liveWithId = @5; // En un pis compartit
    self.citizenshipId = @6; // Andorrana
    self.ethnicalOriginId = @1; // Europeu
    self.religionId = @25; // Cristià
    self.religionLevelId = @3; // No practicant
    self.marriageOpinionId = @5; // Impensable
    self.romanticismId = @4; // Gens romàntic
    self.wantChildrensId = @2; // Si, 1
    self.studiesId = @5; // Llicenciat
    self.languagesId = [NSSet setWithObjects:@4, @22, @13, nil]; // Anglès, Francès, Català
    self.professionId = @42; // Metge
    self.salaryId = @4; // De 30 a 50.000€/any
    self.styleId = @5; // Despreocupat
    self.dietId = @1; // Menja de tot
    self.smokeId = @1; // Si, ocasionalment
    self.animalsId = [NSSet setWithObjects:@9, @2, nil]; // Conill, Gos
    self.hobbiesId = [NSSet setWithObjects:@22, @7, nil]; // Fotos, Música
    self.sportsId = [NSSet setWithObjects:@25, @19, nil]; // Tenis, Surf
    self.sparetimeId = [NSSet setWithObjects:@9, @7, nil]; // Cinema, Concert
    self.musicId = [NSSet setWithObjects:@11, nil]; // Pop-Rock
    self.moviesId = [NSSet setWithObjects:@2, nil]; // Acció
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
        [db executeUpdate:@"update user_profile set face_front_image_url = ?, face_front_image = ?, face_profile_image_url = ?, face_profile_image = ?, body_image_url = ?, body_image = ?, height = ?, weight = ?, hair_color_id = ?, hair_size_id = ?, eye_color_id = ?, personality_id = ?, appearance_id = ?, silhouette_id = ?, body_highlight_id = ?, marital_status_id = ?, has_childrens_id = ?, live_with_id = ?, citizenship_id = ?, ethnical_origin_id = ?, religion_id = ?, religion_level_id = ?, marriage_opinion_id = ?, romanticism_id = ?, want_childrens_id = ?, studies_id = ?, languages_id = ?, profession_id = ?, salary_id = ?, style_id = ?, diet_id = ?, smoke_id = ?, animals_id = ?, hobbies_id = ?, sports_id = ?, sparetime_id = ?, music_id = ?, movies_id = ? where username = ?", self.faceFrontImageURL, UIImagePNGRepresentation(self.faceFrontImage), self.faceProfileImageURL, UIImagePNGRepresentation(self.faceProfileImage), self.bodyImageURL, UIImagePNGRepresentation(self.bodyImage), self.height, self.weight, self.hairColorId, self.hairSizeId, self.eyeColorId, self.personalityId, self.appearanceId, self.silhouetteId, self.bodyHighlightId, self.maritalStatusId, self.hasChildrensId, self.liveWithId, self.citizenshipId, self.ethnicalOriginId, self.religionId, self.religionLevelId, self.marriageOpinionId, self.romanticismId, self.wantChildrensId, self.studiesId, languagesIdString, self.professionId, self.salaryId, self.styleId, self.dietId, self.smokeId, animalsIdString, hobbiesIdString, sportsIdString, sparetimeIdString, musicIdString, moviesIdString, self.username];
        [db commit];
    }
    else
    {
        // Insert user to db
        [db beginTransaction];
        [db executeUpdate:@"insert into user_profile (username, face_front_image_url, face_front_image, face_profile_image_url, face_profile_image, body_image_url, body_image, height, weight, hair_color_id, hair_size_id, eye_color_id, personality_id, appearance_id, silhouette_id, body_highlight_id, marital_status_id, has_childrens_id, live_with_id, citizenship_id, ethnical_origin_id, religion_id, religion_level_id, marriage_opinion_id, romanticism_id, want_childrens_id, studies_id, languages_id, profession_id, salary_id, style_id, diet_id, smoke_id, animals_id, hobbies_id, sports_id, sparetime_id, music_id, movies_id) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", username, self.faceFrontImageURL, UIImagePNGRepresentation(self.faceFrontImage), self.faceProfileImageURL, UIImagePNGRepresentation(self.faceProfileImage), self.bodyImageURL, UIImagePNGRepresentation(self.bodyImage), self.height, self.weight, self.hairColorId, self.hairSizeId, self.eyeColorId, self.personalityId, self.appearanceId, self.silhouetteId, self.bodyHighlightId, self.maritalStatusId, self.hasChildrensId, self.liveWithId, self.citizenshipId, self.ethnicalOriginId, self.religionId, self.religionLevelId, self.marriageOpinionId, self.romanticismId, self.wantChildrensId, self.studiesId, languagesIdString, self.professionId, self.salaryId, self.styleId, self.dietId, self.smokeId, animalsIdString, hobbiesIdString, sportsIdString, sparetimeIdString, musicIdString, moviesIdString];
        [db commit];
    }
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
