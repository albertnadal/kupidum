//
//  KPDClientSIP.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPDClientSIP : NSObject
{
    
}

/*@property (retain, nonatomic) NSString* deviceId;
@property (retain, nonatomic) NSString* deviceName;
@property (nonatomic) video_device_type deviceType;*/

+ (KPDClientSIP *)sharedInstance;
+ (NSString *)userAgent;
- (void)registerToServerWithUser:(NSString *)theUser password:(NSString *)thePassword;

@end