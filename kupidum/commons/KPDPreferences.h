//
//  KMPreferences
//  kupidum
//
//  Created by Albert Nadal Garriga on 02/03/12.
//  Copyright (c) 2012 TID. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPDPreferences : NSObject

+ (KPDPreferences *)sharedInstance;

- (NSString *)proxy;
- (NSString *)user;
- (NSString *)password;
- (NSString *)apiPassword;
- (NSString *)apiUserId;
- (NSString *)apiStorageUrl;
- (NSString *)identifier;
- (NSString *)domain;
- (NSString *)qosServerAddress;
- (NSNumber *)qosServerPort;
- (NSString *)APIServerRootPath;
- (void)setAPIServerRootPath:(NSString *)path;
- (NSString *)appVersion;
- (NSString *)deviceID;
- (NSString *)deviceToken;
- (NSString *)screenName;
- (NSURL *)helpURL;
- (NSURL *)termsURL;
- (NSURL *)thirdPartyURL;
- (NSURL *)privacyURL;
- (BOOL)showWelcomeTour;
- (BOOL)addressBookPermission;
- (NSString *)feedbackEmail;
- (BOOL)performQosTest;

//- (void)saveUserData:(CNCUserData *)userData;

- (void)saveUser:(NSString *)theUser
        password:(NSString *)thePassword
          domain:(NSString *)theDomain
           proxy:(NSString *)theProxy
     apiPassword:(NSString *)theApiPassword
       apiUserId:(NSString *)theApiUserId
   apiStorageUrl:(NSString *)theApiStorageUrl;

- (void)setShowWelcomeTour:(BOOL)value;
- (void)saveUser:(NSString *)theUser;
- (void)saveUserScreenName:(NSString *)theScreenName;
- (void)saveUserAddressBookPermission:(BOOL)permission;
- (void)saveUserDeviceToken:(NSString *)theDeviceToken;
- (void)saveUserDeviceID:(NSString *)theDeviceID;
- (void)saveHelpURL:(NSURL *)url;
- (void)saveTermsURL:(NSURL *)url;
- (void)savePrivacyURL:(NSURL *)url;
- (void)saveFeedbackEmail:(NSString *)email;

- (void)clearPreferences;

- (BOOL)isSignedUp;

@end
