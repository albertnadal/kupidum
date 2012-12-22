//
//  app_pjsip_video.h
//  pjsobj
//
//  Created by Albert Nadal on 25/4/12.
//  Copyright (c) 2012 Telefonica I+D. All rights reserved.
//

#import "YarnVideoDeviceView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YarnVideoDeviceView

@synthesize previewView, view, videoView, viewType;

- (id)init
{
    self = [super init];

    [self initializeView];
//    videoView = nil;
//    previewView = nil;
    viewFrame = CGRectZero;
    previewFrame = CGRectZero;
    viewType = YARN_VIDEO_VIEW_DEFAULT;
//    [self startNotificationListeners];

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];

    ingoingVideoStreamIsTransmiting = false;
    viewFrame = frame;
    previewView = nil;
    [self initializeView];
    viewType = YARN_VIDEO_VIEW_DEFAULT;
//    [self startNotificationListeners];

    return self;
}

- (void)initializeView
{
    ingoingVideoStreamIsTransmiting = false;
    videoView = nil;
    previewView = nil;

    view = [[UIView alloc] initWithFrame:CGRectZero];

    // The following code was the original decorator used to enable rounded corners in the preview view
    /*
    CALayer *capa = view.layer;
    capa.shadowOffset = CGSizeMake(0, 3.5);
    capa.shadowRadius = 4.0;
    capa.shadowColor = [UIColor blackColor].CGColor;
    capa.shadowOpacity = 0.8;*/
}

- (void)releaseDeviceView
{
    ingoingVideoStreamIsTransmiting = false;

    if(videoView != nil)
    {
        [videoView removeFromSuperview];
        videoView = nil;
    }

    if(previewView != nil)
    {
        [previewView removeFromSuperview];
        previewView = nil;
    }
}

- (void)setPreviewFrame:(CGRect)frame
{
    NSDictionary *userInfoPreview = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:frame.origin.x], @"x", [NSNumber numberWithInt:frame.origin.y], @"y", [NSNumber numberWithInt:frame.size.width], @"width", [NSNumber numberWithInt:frame.size.height], @"height", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setOutgoingVideoStreamViewFrame" object:nil userInfo:userInfoPreview];

    previewFrame = frame;
    if(previewView != nil)
        [previewView setFrame:previewFrame];
}

- (void)setFrame:(CGRect)frame
{
    viewFrame = frame;

    NSLog(@"videoView frame: x:%f y:%f w:%f h:%f", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);

    if(videoView != nil)
        [videoView setFrame:frame];
    else
    {
        NSLog(@"videoView frame: x:%f y:%f w:%f h:%f", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
        videoView = [[UIImageView alloc] initWithFrame:viewFrame]; //CGRectMake(0, 0, viewFrame.frame.size.width, viewFrame.frame.size.height)];  //Creates the view to put the video content
        videoView.contentMode = UIViewContentModeScaleToFill;
        videoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [videoView setNeedsDisplay];
        [videoView reloadInputViews];
        [videoView.layer setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    }
}

- (void)showPreviewViewInFullScreenMode
{
    int previewVideoWidth = 320;
    int previewVideoHeight = 391;

    previewFrame = CGRectMake(0, 0, previewVideoWidth, previewVideoHeight);

    if(previewView != nil)
        [previewView setFrame:previewFrame];

    [videoView removeFromSuperview];
    videoView = nil;
}

- (void)switchIngoingAndPreviewViews
{
    int ingoingVideoWidth = viewFrame.size.width;
    int ingoingVideoHeight = viewFrame.size.height;
    int outgoingMargin = 10;

    CGRect remoteCgrect = CGRectMake(0, 0, ingoingVideoWidth, ingoingVideoHeight);
    CGRect localCgrect = CGRectMake((ingoingVideoWidth - 96) - outgoingMargin, (ingoingVideoHeight - 128) - outgoingMargin, 96, 128);

    [self setFrame:remoteCgrect];
    [self setPreviewFrame:localCgrect];
}

- (void)startNotificationListeners
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIngoingVideoFrame:) name:@"setIngoingVideoFrame" object:nil];
}

- (void)stopNotificationListeners
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setIngoingVideoFrame: (NSNotification*)theNotification
{
    if(!ingoingVideoStreamIsTransmiting)
    {
        if(videoView == nil)
        {
            NSLog(@"videoView frame: x:%f y:%f w:%f h:%f", viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
            videoView = [[UIImageView alloc] initWithFrame:viewFrame]; //CGRectMake(0, 0, viewFrame.frame.size.width, viewFrame.frame.size.height)];  //Creates the view to put the video content
            
            videoView.contentMode = UIViewContentModeScaleToFill;
            videoView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [videoView setNeedsDisplay];
            [videoView reloadInputViews];
            [videoView.layer setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        }

        [view addSubview:videoView]; //Add the view to the main container

        // At this point the remote user agent started sending frames to this client
        ingoingVideoStreamIsTransmiting = true;

        // Based on the Benjaming UI storyboard. When the remote user agent start sending frames then the preview view must be shown in the right-bottom corner and the ingoing view must be fullsized
        [self performSelectorOnMainThread:@selector(switchIngoingAndPreviewViews) withObject:nil waitUntilDone:YES];
    }
    
    if([videoView respondsToSelector:@selector(setImage:)])
    {
        [videoView setImage:(UIImage *)[[theNotification userInfo] valueForKey:@"videoframe"]];
    }
}

- (UIView *)getPreviewView
{
    NSMutableDictionary *userInfoOutgoingVideoStreamView = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil, @"view", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOutgoingVideoStreamView" object:nil userInfo:userInfoOutgoingVideoStreamView];

    previewView = [userInfoOutgoingVideoStreamView objectForKey:@"view"]; //It returns de UIView of outgoing video stream (aka video preview)
    [previewView setBackgroundColor:[UIColor clearColor]];

    // The following code was the original decorator used to enable rounded corners in the preview view
    /*
    CALayer *capa = previewView.layer;
    capa.shadowOffset = CGSizeMake(0, 3);
    capa.shadowRadius = 3.5;
    capa.cornerRadius = 6.0;
    capa.shadowColor = [UIColor blackColor].CGColor;
    capa.shadowOpacity = 0.7;*/

    return previewView;
}

@end