//
//  KPDVideoDeviceView.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/12/12.
//  Copyright 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum video_device_view_type
{
    YARN_VIDEO_VIEW_DEFAULT,
    YARN_VIDEO_VIEW_PREVIEW
}video_device_view_type;

@interface KPDVideoDeviceView : NSObject
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