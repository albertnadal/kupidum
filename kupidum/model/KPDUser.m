//
//  KPDUser.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KPDUser.h"
#import "KupidumDBSingleton.h"

@implementation KPDUser

@synthesize username, avatarURL, avatar, gender, genderCandidate, dateOfBirth, city, professionId, profession;

- (id)init
{
    if(self = [super init])
    {
        self.username = nil;
        self.avatarURL = nil;
        self.avatar = nil;
        self.gender = nil;
        self.genderCandidate = nil;
        self.dateOfBirth = nil;
        self.city = nil;
        self.professionId = nil;
        self.profession = nil;
    }

    return self;
}

- (id)initWithUsername:(NSString *)_username avatarUrl:(NSString *)avatar_url gender:(int)the_gender genderCandidate:(int)gender_candidate_ dateOfBirth:(NSDate *)date_of_birth city:(NSString *)city_ professionId:(int)profession_id
{
    if(self = [super init])
    {
        self.username = _username;
        self.avatarURL = avatar_url;
        self.gender = [NSNumber numberWithInt:the_gender];
        self.genderCandidate = [NSNumber numberWithInt:gender_candidate_];
        self.dateOfBirth = date_of_birth;
        self.city = city_;
        self.professionId = [NSNumber numberWithInt:profession_id];
        self.profession = [self professionStringFromIdentifier:[self.professionId intValue]];

        // If the user is not in the database then we have to retrieve the full data from web service and save to database
        if(![self usernameIsInDatabase:_username])
        {
            [self saveToDatabase];
        }
    }
    
    return self;
}

- (id)initWithUsername:(NSString *)_username
{
    if(self = [super init])
    {
        self.username = _username;

        // If the user is not in the database then we have to retrieve the full data from web service and save to database
        if(![self usernameIsInDatabase:_username])
        {
            [self retrieveDataFromWebService];
            [self saveToDatabase];
        }
    }

    return self;
}

- (void)retrieveDataFromWebService
{
    //warning Implement this function!
    self.avatar = [[UIImage alloc] init];
    self.avatarURL = @"https://twimg0-a.akamaihd.net/profile_images/3070674028/9f2af264ad0fa725337701afe41dbcab.jpeg";

    self.gender = [NSNumber numberWithInt:kMale];
    self.genderCandidate = [NSNumber numberWithInt:kFemale];

    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:26];
    [components setMonth:9];
    [components setYear:1981];
    self.dateOfBirth = [[NSCalendar currentCalendar] dateFromComponents:components];

    self.city = @"Girona";
    self.professionId = @42; // Metge
    self.profession = [self professionStringFromIdentifier:[self.professionId intValue]];
}

- (NSString *)professionStringFromIdentifier:(int)profession_id
{
    switch(profession_id)
    {
        case 0: return @""; break;
        case 1: return NSLocalizedString(@"[1]actor", @""); break;
        case 2: return NSLocalizedString(@"[2]agente de seguros", @""); break;
        case 3: return NSLocalizedString(@"[3]agente de viajes", @""); break;
        case 4: return NSLocalizedString(@"[4]agente hospitalario", @""); break;
        case 5: return NSLocalizedString(@"[5]agente inmobiliario", @""); break;
        case 6: return NSLocalizedString(@"[6]agricultor", @""); break;
        case 7: return NSLocalizedString(@"[7]pintor artístico", @""); break;
        case 8: return NSLocalizedString(@"[8]asistente social", @""); break;
        case 9: return NSLocalizedString(@"[9]asistente/secretario", @""); break;
        case 10: return NSLocalizedString(@"[10]abogado", @""); break;
        case 11: return NSLocalizedString(@"[11]aibliotecario, librero", @""); break;
        case 12: return NSLocalizedString(@"[12]ejecutivo administrativo", @""); break;
        case 13: return NSLocalizedString(@"[13]ejecutivo bancario", @""); break;
        case 14: return NSLocalizedString(@"[14]ejecutivo comercial", @""); break;
        case 15: return NSLocalizedString(@"[15]ejecutivo financiero", @""); break;
        case 16: return NSLocalizedString(@"[16]ejecutivo recursos humanos", @""); break;
        case 17: return NSLocalizedString(@"[17]directivo/ejecutivo superior", @""); break;
        case 18: return NSLocalizedString(@"[18]otros ejecutivos", @""); break;
        case 19: return NSLocalizedString(@"[19]cazatalentos", @""); break;
        case 20: return NSLocalizedString(@"[20]camionero", @""); break;
        case 21: return NSLocalizedString(@"[21]peluquero", @""); break;
        case 22: return NSLocalizedString(@"[22]comerciante", @""); break;
        case 23: return NSLocalizedString(@"[23]contable", @""); break;
        case 24: return NSLocalizedString(@"[24]consultor", @""); break;
        case 25: return NSLocalizedString(@"[25]cocinero", @""); break;
        case 26: return NSLocalizedString(@"[26]dentista", @""); break;
        case 27: return NSLocalizedString(@"[27]escritor", @""); break;
        case 28: return NSLocalizedString(@"[28]editor", @""); break;
        case 29: return NSLocalizedString(@"[29]atención al cliente", @""); break;
        case 30: return NSLocalizedString(@"[30]docente", @""); break;
        case 31: return NSLocalizedString(@"[31]especialista de belleza", @""); break;
        case 32: return NSLocalizedString(@"[32]estudiante", @""); break;
        case 33: return NSLocalizedString(@"[33]florista", @""); break;
        case 34: return NSLocalizedString(@"[34]funcionario", @""); break;
        case 35: return NSLocalizedString(@"[35]grafista", @""); break;
        case 36: return NSLocalizedString(@"[36]enfermero", @""); break;
        case 37: return NSLocalizedString(@"[37]ingeniero informático", @""); break;
        case 38: return NSLocalizedString(@"[38]ingeniero no informático", @""); break;
        case 39: return NSLocalizedString(@"[39]periodista", @""); break;
        case 40: return NSLocalizedString(@"[40]jurista", @""); break;
        case 41: return NSLocalizedString(@"[41]masajista", @""); break;
        case 42: return NSLocalizedString(@"[42]médico", @""); break;
        case 43: return NSLocalizedString(@"[43]militar", @""); break;
        case 44: return NSLocalizedString(@"[44]músico", @""); break;
        case 45: return NSLocalizedString(@"[45]obrero", @""); break;
        case 46: return NSLocalizedString(@"[46]personal aéreo", @""); break;
        case 47: return NSLocalizedString(@"[47]policía", @""); break;
        case 48: return NSLocalizedString(@"[48]bombero", @""); break;
        case 49: return NSLocalizedString(@"[49]publicista", @""); break;
        case 50: return NSLocalizedString(@"[50]restaurador", @""); break;
        case 51: return NSLocalizedString(@"[51]jubilado", @""); break;
        case 52: return NSLocalizedString(@"[52]empleado de asociación", @""); break;
        case 53: return NSLocalizedString(@"[53]sin empleo", @""); break;
        case 54: return NSLocalizedString(@"[54]camarero", @""); break;
        case 55: return NSLocalizedString(@"[55]deportista", @""); break;
        case 56: return NSLocalizedString(@"[56]técnico", @""); break;
        case 57: return NSLocalizedString(@"[57]otros", @""); break;
        case 58: return NSLocalizedString(@"[58]arquitecto", @""); break;
        case 59: return NSLocalizedString(@"[59]notario", @""); break;
        case 60: return NSLocalizedString(@"[60]educador", @""); break;
        case 61: return NSLocalizedString(@"[61]empresario", @""); break;
        case 62: return NSLocalizedString(@"[62]intérprete", @""); break;
        case 65: return NSLocalizedString(@"[65]doctor", @""); break;
        case 92: return NSLocalizedString(@"[92]artesano", @""); break;
        case 93: return NSLocalizedString(@"[93]panadero", @""); break;
    }

    return @"";
}

- (void)saveToDatabase
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    if([self usernameIsInDatabase:username])
    {
        // Update user data
        [db beginTransaction];
        [db executeUpdate:@"update user set avatar_url = ?, avatar = ?, gender = ?, gender_candidate = ?, date_of_birth = ?, city = ?, profession_id = ? where username = ?", self.avatarURL, UIImagePNGRepresentation(avatar), self.gender, self.genderCandidate, self.dateOfBirth, self.city, self.professionId, username];
        [db commit];
    }
    else
    {
        // Insert user to db
        [db beginTransaction];
        [db executeUpdate:@"insert into user (username, avatar_url, avatar, gender, gender_candidate, date_of_birth, city, profession_id) values (?, ?, ?, ?, ?, ?, ?, ?)", username, avatarURL, UIImagePNGRepresentation(avatar), self.gender, self.genderCandidate, self.dateOfBirth, self.city, self.professionId];
        [db commit];
    }
}

- (bool)usernameIsInDatabase:(NSString *)_username
{
    FMDatabase *db = [[KupidumDBSingleton sharedInstance] db];

    FMResultSet *rs = [db executeQuery:@"select COUNT(*) from user where username = ?", _username];

    bool has_rows = false;

    while ([rs next])
    {
        has_rows = ([rs intForColumnIndex:0] > 0);
    }

    [rs close];

    return has_rows;
}

@end
