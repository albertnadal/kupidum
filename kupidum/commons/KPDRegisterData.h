//
//  KPDRegisterData.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 12/02/12.
//  Copyright (c) 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KPDRegisterData : NSObject

+ (KPDRegisterData *)sharedInstance;

- (NSNumber *)profileType;
- (NSNumber *)minAge;
- (NSNumber *)maxAge;
- (NSNumber *)birthday;
- (NSNumber *)birthmonth;
- (NSNumber *)birthyear;
- (NSString *)countryCode;

- (void)setProfileType:(NSNumber *)theProfileType
                minAge:(NSNumber *)theMinAge
                maxAge:(NSNumber *)theMaxAge
              birthday:(NSNumber *)theBirthday
            birthmonth:(NSNumber *)theBirthmonth
             birthyear:(NSNumber *)theBirthyear
           countryCode:(NSString *)theCountryCode;

- (void)clearRegisterData;

@end
