//
//  app_pjsip_video.h
//  pjsobj
//
//  Created by Albert Nadal on 25/4/12.
//  Copyright (c) 2012 Telefonica I+D. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum video_device_type
{
    YARN_UNKNOWN_VIDEO_DEVICE,
    YARN_BACK_VIDEO_DEVICE,
    YARN_FRONT_VIDEO_DEVICE
}video_device_type;

//Device "object" for video capture
@interface YarnVideoDevice : NSObject
{
    NSString *deviceId; //AVCaptureDevice uniqueID property
    NSString *deviceName;
    video_device_type deviceType; 
}

@property (retain, nonatomic) NSString* deviceId;
@property (retain, nonatomic) NSString* deviceName;
@property (nonatomic) video_device_type deviceType;

@end