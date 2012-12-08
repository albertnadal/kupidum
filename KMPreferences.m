//
//  CNCPreferences.m
//  GConnect
//
//  Created by Francisco José  Rodríguez Pérez on 02/03/12.
//  Copyright (c) 2012 TID. All rights reserved.
//

#import "KMPreferences.h"

@interface KMPreferences ()

@property (nonatomic, strong) NSMutableDictionary *preferences;

- (BOOL)existsFileInDocuments;
- (void)copyPreferencesFileToDocuments;
- (void)mergeNewEntriesToPreferencesFile;
- (BOOL)needToOverwriteDefaultValue:(id)defaultValue withInstalledValue:(id)installedValue;
- (NSMutableDictionary *)preferencesDictionaryFromDocuments;
- (NSString *)settingsPath;
- (void)setValue:(id)value forKey:(NSString *)key;

@end

@implementation KMPreferences

@synthesize preferences = preferences_;

+ (KMPreferences *)sharedInstance
{    
    static dispatch_once_t onceToken;
    static KMPreferences *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[KMPreferences alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (![self existsFileInDocuments]) {
            [self copyPreferencesFileToDocuments];
        } else {
            [self mergeNewEntriesToPreferencesFile];
        }
        
        preferences_ = [self preferencesDictionaryFromDocuments];
    }
    return self;
}

- (NSString*)proxy
{
    NSString *value =  [self.preferences objectForKey:@"proxy"];
    return value;
}

- (NSString*)user
{
    NSString *value = [self.preferences objectForKey:@"user"];
    return value;
}

- (NSString*)password
{
    NSString *value = [self.preferences objectForKey:@"password"];
    return value;
}

- (NSString*)apiPassword
{
    NSString *value = [self.preferences objectForKey:@"apiPassword"];
    return value;
}

- (NSString*)apiUserId
{
    NSString *value = [self.preferences objectForKey:@"apiUserId"];
    return value;
}

- (NSString*)apiStorageUrl
{
    NSString *value = [self.preferences objectForKey:@"apiStorageUrl"];
    return value;
}

- (NSString*)domain
{
    NSString *value = [self.preferences objectForKey:@"domain"];
    return value;
}

- (NSString*)identifier
{
    NSString *value = [self.preferences objectForKey:@"identifier"];
    return value;
}

- (NSString*)qosServerAddress
{
    NSString *value = [self.preferences objectForKey:@"QosServerAddress"];
    return value;
}

- (NSNumber*)qosServerPort
{
    NSNumber *value = [self.preferences objectForKey:@"QosServerPort"];
    return value;
}

- (NSString*)APIServerRootPath
{
    NSString *value = [self.preferences objectForKey:@"APIServerRootPath"];
    return value;
}

- (void)setAPIServerRootPath:(NSString *)path
{
    [self setValue:path forKey:@"APIServerRootPath"];
}

- (NSString*)appVersion
{
    NSString *value = [self.preferences objectForKey:@"AppVersion"];
    return value;
}

- (NSString*)screenName
{
    NSString *value = [self.preferences objectForKey:@"screenName"];
    return value;
}

- (NSString *)deviceToken
{
    NSString *value = [self.preferences objectForKey:@"deviceToken"];
    return value;
}

- (NSURL *)helpURL
{
    NSURL *value = [NSURL URLWithString:[self.preferences objectForKey:@"helpURL"]];
    return value;
}

- (NSURL *)termsURL
{
    NSURL *value = [NSURL URLWithString:[self.preferences objectForKey:@"termsURL"]];
    return value;
}

- (NSURL *)thirdPartyURL
{
    NSURL *value = [NSURL URLWithString:[self.preferences objectForKey:@"thirdpartyURL"]];
    return value;
}

- (NSURL *)privacyURL
{
    NSURL *value = [NSURL URLWithString:[self.preferences objectForKey:@"privacyURL"]];
    return value;
}

- (BOOL)performQosTest
{
    BOOL value = [[self.preferences objectForKey:@"PerformQosTest"] boolValue];
    return value;
}

- (BOOL)addressBookPermission
{
    NSNumber *value = [self.preferences objectForKey:@"addressBookPermission"];
    return [value boolValue];
}

- (void)saveUserAddressBookPermission:(BOOL)permission
{
    [self setValue:[NSNumber numberWithBool:permission] forKey:@"addressBookPermission"];
}

- (BOOL)showWelcomeTour
{
    NSNumber *value = [self.preferences objectForKey:@"showWelcomeTour"];
    if (value == nil)
        return YES;
    else
        return [value boolValue];
}

- (NSString *)feedbackEmail
{
    NSString *value = [self.preferences objectForKey:@"feedbackEmail"];
    return value;
}

- (void)setShowWelcomeTour:(BOOL) value
{
    [self setValue:[NSNumber numberWithBool:value] forKey:@"showWelcomeTour"];
}

- (void)saveUser:(NSString *)theUser
{
    [self setValue:theUser forKey:@"user"];
}

/*- (void)saveUserData:(CNCUserData *)userData
{
    [self saveUser:userData.config.sip.username password:userData.config.sip.password
             domain:userData.config.sip.domain proxy:userData.config.sip.proxy 
        apiPassword:userData.password apiUserId:userData.user_id
      apiStorageUrl:userData.config.storage.url];
    
    [self saveFeedbackEmail:userData.config.service.feedback];
    [self saveHelpURL:[NSURL URLWithString:userData.config.service.boilerplate.help]];
    [self savePrivacyURL:[NSURL URLWithString:userData.config.service.boilerplate.dataPrivacy]];
    [self saveTermsURL:[NSURL URLWithString:userData.config.service.boilerplate.termsAndConds]];
}*/

- (void)saveUser:(NSString *)theUser
        password:(NSString *)thePassword
          domain:(NSString *)theDomain
           proxy:(NSString *)theProxy 
     apiPassword:(NSString *)theApiPassword 
       apiUserId:(NSString *)theApiUserId
   apiStorageUrl:(NSString *)theApiStorageUrl
{
    [self.preferences setValue:theUser forKey:@"user"];
    [self.preferences setValue:thePassword forKey:@"password"];
    [self.preferences setValue:theDomain forKey:@"domain"];
    [self.preferences setValue:theProxy forKey:@"proxy"];
    [self.preferences setValue:theUser forKey:@"identifier"];
    [self.preferences setValue:theApiPassword forKey:@"apiPassword"];
    [self.preferences setValue:theApiUserId forKey:@"apiUserId"];
    [self.preferences setValue:theApiStorageUrl forKey:@"apiStorageUrl"];
    [self.preferences writeToFile:[self settingsPath] atomically:YES];
}

- (void)saveUserScreenName:(NSString *)theScreenName
{
    [self setValue:theScreenName forKey:@"screenName"];
}

- (void)saveUserDeviceToken:(NSString *)theDeviceToken
{
    [self setValue:theDeviceToken forKey:@"deviceToken"];
}

- (void)saveUserDeviceID:(NSString *)theDeviceID
{
    [self setValue:theDeviceID forKey:@"deviceID"];
}

- (void)saveHelpURL:(NSURL *)url
{
    [self setValue:url.absoluteString forKey:@"helpURL"];
}

- (void)savePrivacyURL:(NSURL *)url
{
    [self setValue:url.absoluteString forKey:@"privacyURL"];
}

- (void)saveTermsURL:(NSURL *)url
{
    [self setValue:url.absoluteString forKey:@"termsURL"];
}

- (void)saveFeedbackEmail:(NSString *)email
{
    [self setValue:email forKey:@"feedbackEmail"];
}

- (void)clearPreferences
{
    [self saveUser:nil password:nil domain:nil proxy:nil 
       apiPassword:nil apiUserId:nil apiStorageUrl:nil];
}

- (BOOL)isSignedUp
{
    return ([self.user length] && [self.password length]);
}

#pragma mark - Private methods

/*- (NSString *)settingsPath
{
    return [CNCFilesystemManager localPathForFile:@"settings.plist"];
}*/

- (BOOL)existsFileInDocuments
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *settingsPath = [self settingsPath];
    return [fileManager fileExistsAtPath:settingsPath];
}

- (void)copyPreferencesFileToDocuments
{     
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *settingsPath = [self settingsPath];
    NSError *error;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"settings.plist"];
    [fileManager copyItemAtPath:defaultDBPath toPath:settingsPath error:&error]; 
}

- (BOOL)needToOverwriteDefaultValue:(id)defaultValue withInstalledValue:(id)installedValue
{
    if (!defaultValue) return NO;
    
    if ([defaultValue isKindOfClass:[NSString class]] &&
        [installedValue isKindOfClass:[NSString class]]) {
        if ([defaultValue length] > 0 && ![defaultValue isEqualToString:installedValue]) {
            return YES;
        }
    } else if ([defaultValue isKindOfClass:[NSNumber class]] &&
               [installedValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    return NO;
}

- (void)mergeNewEntriesToPreferencesFile
{
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"settings.plist"];
    NSString *settingsPath = [self settingsPath];
    
    NSMutableDictionary *defaultDict = [[NSMutableDictionary alloc] initWithContentsOfFile:defaultDBPath];    
    NSMutableDictionary *installedDict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    NSArray *installedDictKeys = [installedDict allKeys];

    for (NSString *key in [defaultDict allKeys]) {
        id defaultValue = [defaultDict valueForKey:key];
        if (![installedDictKeys containsObject:key] 
            || [self needToOverwriteDefaultValue:defaultValue 
                              withInstalledValue:[installedDict valueForKey:key]]) {
            [installedDict setValue:defaultValue forKey:key];
        }
    }
    
    [installedDict writeToURL:[NSURL fileURLWithPath:settingsPath] atomically:YES];
}

- (NSMutableDictionary *)preferencesDictionaryFromDocuments
{
    NSString *settingsPath = [self settingsPath];
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    if (!plistDictionary) {
        plistDictionary = [[NSMutableDictionary alloc] init];
    }
    return plistDictionary;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.preferences setValue:value forKey:key];
    [self.preferences writeToFile:[self settingsPath] atomically:YES];
}

@end
