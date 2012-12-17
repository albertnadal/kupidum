//
//  KMRegisterData.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 02/03/12.
//  Copyright (c) 2012 TID. All rights reserved.
//

#import "KMRegisterData.h"

@interface KMRegisterData ()

@property (nonatomic, strong) NSMutableDictionary *registerData;

- (void)setValue:(id)value forKey:(NSString *)key;

@end

@implementation KMRegisterData

@synthesize registerData = registerData_;

+ (KMRegisterData *)sharedInstance
{    
    static dispatch_once_t onceToken;
    static KMRegisterData *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[KMRegisterData alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        registerData_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSNumber *)profileType
{
    NSNumber *value = [self.registerData objectForKey:@"profileType"];
    return value;
}

- (NSNumber *)minAge
{
    NSNumber *value = [self.registerData objectForKey:@"minAge"];
    return value;
}

- (NSNumber *)maxAge
{
    NSNumber *value = [self.registerData objectForKey:@"maxAge"];
    return value;
}

- (NSNumber *)birthday
{
    NSNumber *value = [self.registerData objectForKey:@"birthday"];
    return value;
}

- (NSNumber *)birthmonth
{
    NSNumber *value = [self.registerData objectForKey:@"birthmonth"];
    return value;
}

- (NSNumber *)birthyear
{
    NSNumber *value = [self.registerData objectForKey:@"birthyear"];
    return value;
}

- (NSString *)countryCode
{
    NSString *value =  [self.registerData objectForKey:@"countryCode"];
    return value;
}

- (void)setProfileType:(NSNumber *)theProfileType
                minAge:(NSNumber *)theMinAge
                maxAge:(NSNumber *)theMaxAge
              birthday:(NSNumber *)theBirthday
            birthmonth:(NSNumber *)theBirthmonth
             birthyear:(NSNumber *)theBirthyear
           countryCode:(NSString *)theCountryCode;
{
    [self.registerData setValue:theProfileType forKey:@"profileType"];
    [self.registerData setValue:theMinAge forKey:@"minAge"];
    [self.registerData setValue:theMaxAge forKey:@"maxAge"];
    [self.registerData setValue:theBirthday forKey:@"birthday"];
    [self.registerData setValue:theBirthmonth forKey:@"birthmonth"];
    [self.registerData setValue:theBirthyear forKey:@"birthyear"];
    [self.registerData setValue:theCountryCode forKey:@"countryCode"];
}

- (void)clearRegisterData
{
    [self setProfileType:nil minAge:nil maxAge:nil
                birthday:nil birthmonth:nil birthyear:nil countryCode:nil];
}

#pragma mark - Private methods

- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.registerData setValue:value forKey:key];
}

@end
