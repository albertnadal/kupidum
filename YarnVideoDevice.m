//
//  app_pjsip_video.h
//  pjsobj
//
//  Created by Albert Nadal on 25/4/12.
//  Copyright (c) 2012 Telefonica I+D. All rights reserved.
//

#import "YarnVideoDevice.h"

@implementation YarnVideoDevice

@synthesize deviceId;
@synthesize deviceName;
@synthesize deviceType;

- (id)init
{
    self = [super init];
    deviceId = nil;
    deviceName = nil;
    deviceType = YARN_UNKNOWN_VIDEO_DEVICE;

    return self;
}

@end