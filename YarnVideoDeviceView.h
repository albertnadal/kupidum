//
//  YarnVideoDeviceView.h
//  pjsobj
//
//  Created by Albert Nadal on 25/4/12.
//  Copyright (c) 2012 Telefonica I+D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum video_device_view_type
{
    YARN_VIDEO_VIEW_DEFAULT,
    YARN_VIDEO_VIEW_PREVIEW
}video_device_view_type;

@interface YarnVideoDeviceView : NSObject
{
    UIView *view;               // This UIView acts as the main container
    UIImageView *videoView;     // This UIView contains de video view
    UIView *previewView;

    video_device_view_type viewType;
    CGRect viewFrame;
    CGRect previewFrame;

    bool ingoingVideoStreamIsTransmiting;
}

@property (retain, nonatomic) UIView *view;
@property (retain, nonatomic) UIImageView *videoView;
@property (retain, nonatomic) UIView *previewView;
@property (nonatomic) video_device_view_type viewType;

//API for Video View from "PJMEDIA/PJSIP" management
//ALL "private" for usage within app_pjsip.m
- (void)initializeView;
- (void)releaseDeviceView;
- (void)startNotificationListeners;
- (void)stopNotificationListeners;
- (void)setFrame:(CGRect)frame;
- (void)setPreviewFrame:(CGRect)frame;
- (void)showPreviewViewInFullScreenMode;
- (void)switchIngoingAndPreviewViews;
- (UIView *)getPreviewView;

@end