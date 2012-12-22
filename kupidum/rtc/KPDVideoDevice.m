//
//  KPDVideoDevice.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import "KPDVideoDevice.h"

@implementation KPDVideoDevice

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