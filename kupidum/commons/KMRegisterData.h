//
//  KMRegisterData.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 02/03/12.
//  Copyright (c) 2012 TID. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KMRegisterData : NSObject

+ (KMRegisterData *)sharedInstance;

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
