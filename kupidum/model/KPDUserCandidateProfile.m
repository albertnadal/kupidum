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
@synthesize minAge, maxAge, minHeight, maxHeight, minWeight, maxWeight, maritalStatusId, whereIsLivingId, wantChildrensId, hasChildrensId, silhouetteID;
@synthesize mainCharacteristicId, isRomanticId, marriageIsId, smokesId, dietId, nationId, ethnicalOriginId, bodyLookId, hairSizeId, hairColorId, eyeColorId;
@synthesize styleId, highlightId, studiesMinLevelId, studiesMaxLevelId, languagesId, religionId, religionLevelId, hobbiesId, sparetimeId, musicId, moviesId;
@synthesize animalsId, sportsId, businessId, minSalaryId, maxSalaryId;

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

        self.minAge = nil;
        self.maxAge = nil;
        self.minHeight = nil;
        self.maxHeight = nil;
        self.minWeight = nil;
        self.maxWeight = nil;
        self.maritalStatusId = nil;
        self.whereIsLivingId = nil;
        self.wantChildrensId = nil;
        self.hasChildrensId = nil;
        self.silhouetteID = nil;
        self.mainCharacteristicId = nil;
        self.isRomanticId = nil;
        self.marriageIsId = nil;
        self.smokesId = nil;
        self.dietId = nil;
        self.nationId = nil;
        self.ethnicalOriginId = nil;
        self.bodyLookId = nil;
        self.hairSizeId = nil;
        self.hairColorId = nil;
        self.eyeColorId = nil;
        self.styleId = nil;
        self.highlightId = nil;
        self.studiesMinLevelId = nil;
        self.studiesMaxLevelId = nil;
        self.languagesId = nil;
        self.religionId = nil;
        self.religionLevelId = nil;
        self.hobbiesId = nil;
        self.sparetimeId = nil;
        self.musicId = nil;
        self.moviesId = nil;
        self.animalsId = nil;
        self.sportsId = nil;
        self.businessId = nil;
        self.minSalaryId = nil;
        self.maxSalaryId = nil;

        // If the user is not in the database then we have to retrieve the full data from web service and save to database
        if([self usernameIsInDatabase:_username])
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

    FMResultSet *rs = [db executeQuery:@"select * from user_candidate_profile where username = ?", self.username];

    while ([rs next])
    {
        self.minAge = [NSNumber numberWithInt:[rs intForColumn:@"min_age"]];
        self.maxAge = [NSNumber numberWithInt:[rs intForColumn:@"max_age"]];
        self.minHeight = [NSNumber numberWithInt:[rs intForColumn:@"min_height"]];
        self.maxHeight = [NSNumber numberWithInt:[rs intForColumn:@"max_height"]];
        self.minWeight = [NSNumber numberWithInt:[rs intForColumn:@"min_weight"]];
        self.maxWeight = [NSNumber numberWithInt:[rs intForColumn:@"max_weight"]];
        self.maritalStatusId = [self retrieveNSSetFromString:[rs stringForColumn:@"marital_status_id"]];;
        self.whereIsLivingId = [self retrieveNSSetFromString:[rs stringForColumn:@"where_is_living_id"]];;
        self.wantChildrensId = [self retrieveNSSetFromString:[rs stringForColumn:@"want_childrens_id"]];;
        self.hasChildrensId = [self retrieveNSSetFromString:[rs stringForColumn:@"has_childrens_id"]];;
        self.silhouetteID = [self retrieveNSSetFromString:[rs stringForColumn:@"silhouette_id"]];;
        self.mainCharacteristicId = [self retrieveNSSetFromString:[rs stringForColumn:@"main_characteristic_id"]];;
        self.isRomanticId = [self retrieveNSSetFromString:[rs stringForColumn:@"is_romantic_id"]];;
        self.marriageIsId = [self retrieveNSSetFromString:[rs stringForColumn:@"marriage_is_id"]];;
        self.smokesId = [self retrieveNSSetFromString:[rs stringForColumn:@"smokes_id"]];;
        self.dietId = [self retrieveNSSetFromString:[rs stringForColumn:@"diet_id"]];;
        self.nationId = [self retrieveNSSetFromString:[rs stringForColumn:@"nation_id"]];;
        self.ethnicalOriginId = [self retrieveNSSetFromString:[rs stringForColumn:@"ethnical_origin_id"]];;
        self.bodyLookId = [self retrieveNSSetFromString:[rs stringForColumn:@"body_look_id"]];;
        self.hairSizeId = [self retrieveNSSetFromString:[rs stringForColumn:@"hair_size_id"]];;
        self.hairColorId = [self retrieveNSSetFromString:[rs stringForColumn:@"hair_color_id"]];;
        self.eyeColorId = [self retrieveNSSetFromString:[rs stringForColumn:@"eye_color_id"]];;
        self.styleId = [self retrieveNSSetFromString:[rs stringForColumn:@"style_id"]];;
        self.highlightId = [self retrieveNSSetFromString:[rs stringForColumn:@"highlight_id"]];;
        self.studiesMinLevelId = [NSNumber numberWithInt:[rs intForColumn:@"studies_min_level_id"]];
        self.studiesMaxLevelId = [NSNumber numberWithInt:[rs intForColumn:@"studies_max_level_id"]];
        self.languagesId = [self retrieveNSSetFromString:[rs stringForColumn:@"languages_id"]];;
        self.religionId = [self retrieveNSSetFromString:[rs stringForColumn:@"religion_id"]];;
        self.religionLevelId = [self retrieveNSSetFromString:[rs stringForColumn:@"religion_level_id"]];;
        self.hobbiesId = [self retrieveNSSetFromString:[rs stringForColumn:@"hobbies_id"]];;
        self.sparetimeId = [self retrieveNSSetFromString:[rs stringForColumn:@"sparetime_id"]];;
        self.musicId = [self retrieveNSSetFromString:[rs stringForColumn:@"music_id"]];;
        self.moviesId = [self retrieveNSSetFromString:[rs stringForColumn:@"movies_id"]];;
        self.animalsId = [self retrieveNSSetFromString:[rs stringForColumn:@"animals_id"]];;
        self.sportsId = [self retrieveNSSetFromString:[rs stringForColumn:@"sports_id"]];;
        self.businessId = [self retrieveNSSetFromString:[rs stringForColumn:@"business_id"]];;
        self.minSalaryId = [NSNumber numberWithInt:[rs intForColumn:@"min_salary_id"]];
        self.maxSalaryId = [NSNumber numberWithInt:[rs intForColumn:@"max_salary_id"]];
    }
    
    [rs close];
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    NSString *maritalStatusIdString = [[self.maritalStatusId allObjects] componentsJoinedByString:@","];
    NSString *whereIsLivingIdString = [[self.whereIsLivingId allObjects] componentsJoinedByString:@","];
    NSString *wantChildrensIdString = [[self.wantChildrensId allObjects] componentsJoinedByString:@","];
    NSString *hasChildrensIdString = [[self.hasChildrensId allObjects] componentsJoinedByString:@","];
    NSString *silhouetteIDString = [[self.silhouetteID allObjects] componentsJoinedByString:@","];
    NSString *mainCharacteristicIdString = [[self.mainCharacteristicId allObjects] componentsJoinedByString:@","];
    NSString *isRomanticIdString = [[self.isRomanticId allObjects] componentsJoinedByString:@","];
    NSString *marriageIsIdString = [[self.marriageIsId allObjects] componentsJoinedByString:@","];
    NSString *smokesIdString = [[self.smokesId allObjects] componentsJoinedByString:@","];
    NSString *dietIdString = [[self.dietId allObjects] componentsJoinedByString:@","];
    NSString *nationIdString = [[self.nationId allObjects] componentsJoinedByString:@","];
    NSString *ethnicalOriginIdString = [[self.ethnicalOriginId allObjects] componentsJoinedByString:@","];
    NSString *bodyLookIdString = [[self.bodyLookId allObjects] componentsJoinedByString:@","];
    NSString *hairSizeIdString = [[self.hairSizeId allObjects] componentsJoinedByString:@","];
    NSString *hairColorIdString = [[self.hairColorId allObjects] componentsJoinedByString:@","];
    NSString *eyeColorIdString = [[self.eyeColorId allObjects] componentsJoinedByString:@","];
    NSString *styleIdString = [[self.styleId allObjects] componentsJoinedByString:@","];
    NSString *highlightIdString = [[self.highlightId allObjects] componentsJoinedByString:@","];
    NSString *languagesIdString = [[self.languagesId allObjects] componentsJoinedByString:@","];
    NSString *religionIdString = [[self.religionId allObjects] componentsJoinedByString:@","];
    NSString *religionLevelIdString = [[self.religionLevelId allObjects] componentsJoinedByString:@","];
    NSString *hobbiesIdString = [[self.hobbiesId allObjects] componentsJoinedByString:@","];
    NSString *sparetimeIdString = [[self.sparetimeId allObjects] componentsJoinedByString:@","];
    NSString *musicIdString = [[self.musicId allObjects] componentsJoinedByString:@","];
    NSString *moviesIdString = [[self.moviesId allObjects] componentsJoinedByString:@","];
    NSString *animalsIdString = [[self.animalsId allObjects] componentsJoinedByString:@","];
    NSString *sportsIdString = [[self.sportsId allObjects] componentsJoinedByString:@","];
    NSString *businessIdString = [[self.businessId allObjects] componentsJoinedByString:@","];

    if([self usernameIsInDatabase:username])
    {
        // Update user data
        [db beginTransaction];
        [db executeUpdate:@"update user_candidate_profile set min_age = ?, max_age = ?, min_height = ?, max_height = ?, min_weight = ?, max_weight = ?, marital_status_id = ?, where_is_living_id = ?, want_childrens_id = ?, has_childrens_id = ?, silhouette_id = ?, main_characteristic_id = ?, is_romantic_id = ?, marriage_is_id = ?, smokes_id = ?, diet_id = ?, nation_id = ?, ethnical_origin_id = ?, body_look_id = ?, hair_size_id = ?, hair_color_id = ?, eye_color_id = ?, style_id = ?, highlight_id = ?, studies_min_level_id = ?, studies_max_level_id = ?, languages_id = ?, religion_id = ?, religion_level_id = ?, hobbies_id = ?, sparetime_id = ?, music_id = ?, movies_id = ?, animals_id = ?, sports_id = ?, business_id = ?, min_salary_id = ?, max_salary_id = ? where username = ?", self.minAge, self.maxAge, self.minHeight, self.maxHeight, self.minWeight, self.maxWeight, maritalStatusIdString, whereIsLivingIdString, wantChildrensIdString, hasChildrensIdString, silhouetteIDString, mainCharacteristicIdString, isRomanticIdString, marriageIsIdString, smokesIdString, dietIdString, nationIdString, ethnicalOriginIdString, bodyLookIdString, hairSizeIdString, hairColorIdString, eyeColorIdString, styleIdString, highlightIdString, self.studiesMinLevelId, self.studiesMaxLevelId, languagesIdString, religionIdString, religionLevelIdString, hobbiesIdString, sparetimeIdString, musicIdString, moviesIdString, animalsIdString, sportsIdString, businessIdString, self.minSalaryId, self.maxSalaryId, self.username];
        [db commit];
    }
    else
    {
        // Insert user to db
        [db beginTransaction];
        [db executeUpdate:@"insert into user_candidate_profile (username, min_age, max_age, min_height, max_height, min_weight, max_weight, marital_status_id, where_is_living_id, want_childrens_id, has_childrens_id, silhouette_id, main_characteristic_id, is_romantic_id, marriage_is_id, smokes_id, diet_id, nation_id, ethnical_origin_id, body_look_id, hair_size_id, hair_color_id, eye_color_id, style_id, highlight_id, studies_min_level_id, studies_max_level_id, languages_id, religion_id, religion_level_id, hobbies_id, sparetime_id, music_id, movies_id, animals_id, sports_id, business_id, min_salary_id, max_salary_id) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", self.username, self.minAge, self.maxAge, self.minHeight, self.maxHeight, self.minWeight, self.maxWeight, maritalStatusIdString, whereIsLivingIdString, wantChildrensIdString, hasChildrensIdString, silhouetteIDString, mainCharacteristicIdString, isRomanticIdString, marriageIsIdString, smokesIdString, dietIdString, nationIdString, ethnicalOriginIdString, bodyLookIdString, hairSizeIdString, hairColorIdString, eyeColorIdString, styleIdString, highlightIdString, self.studiesMinLevelId, self.studiesMaxLevelId, languagesIdString, religionIdString, religionLevelIdString, hobbiesIdString, sparetimeIdString, musicIdString, moviesIdString, animalsIdString, sportsIdString, businessIdString, self.minSalaryId, self.maxSalaryId];
        [db commit];
    }
}

- (bool)usernameIsInDatabase:(NSString *)_username
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from user_candidate_profile where username = ?", _username];

    bool has_rows = false;

    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

@end
