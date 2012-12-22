//
//  KPDVideoDevice.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum video_device_type
{
    YARN_UNKNOWN_VIDEO_DEVICE,
    YARN_BACK_VIDEO_DEVICE,
    YARN_FRONT_VIDEO_DEVICE
}video_device_type;

//Device "object" for video capture
@interface KPDVideoDevice : NSObject
{
    NSString *deviceId; //AVCaptureDevice uniqueID property
    NSString *deviceName;
    video_device_type deviceType; 
}

@property (retain, nonatomic) NSString* deviceId;
@property (retain, nonatomic) NSString* deviceName;
@property (nonatomic) video_device_type deviceType;

@end