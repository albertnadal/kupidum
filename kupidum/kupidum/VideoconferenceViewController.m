//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "WCAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoconferenceViewController.h"

@interface VideoconferenceViewController ()

@end

@implementation VideoconferenceViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize videoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[KPDClientSIP sharedInstance] addDelegate:self];
    }
    return self;
}

- (void)showEmbededVideoView
{
    int ingoingVideoWidth = 320;
    int ingoingVideoHeight = 392;

    CGRect remoteCgrect = CGRectMake(0, 0, ingoingVideoWidth, ingoingVideoHeight);

    [[KPDClientSIP sharedInstance] setIngoingVideoStreamViewFrame:remoteCgrect];
    [[KPDClientSIP sharedInstance] setIngoingVideoStreamViewHidden:false];

    // All possible old views inside the videoView must be removed
    for (UIView *view in videoView.subviews) {
        [view removeFromSuperview];
    }

    UIView *remoteView = [[KPDClientSIP sharedInstance] getVideoStreamView]; //getIngoingVideoStreamView];
    remoteView.contentMode = UIViewContentModeScaleToFill;
    remoteView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [remoteView setFrame:remoteCgrect];
    [remoteView setNeedsDisplay];
    [remoteView reloadInputViews];

    [remoteView setFrame:remoteCgrect];
    [remoteView.layer setFrame:remoteCgrect];

    // We add the ingoing video view from app_pjsip into the videoView
    [videoView addSubview:remoteView];
    [videoView reloadInputViews];
}

- (void)hideEmbededVideoView
{
    // All possible old views inside the videoView must be removed
    for (UIView *view in videoView.subviews) {
        [view removeFromSuperview];
    }
}

- (IBAction)connect:(id)sender
{
    [[KPDClientSIP sharedInstance] registerToServerWithUser:[usernameField text] password:[passwordField text]];

    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)callUser:(id)sender
{
    [[KPDClientSIP sharedInstance] callUser:@"silvia" withVideo:TRUE];

    [self showEmbededVideoView];
}

- (IBAction)hangUp:(id)sender
{
    [[KPDClientSIP sharedInstance] hangUp];
}

- (void)videoconferenceDidBegan:(KPDClientSIP *)client
{
    [self showEmbededVideoView];
}

- (void)showIncomingVideocallAlertFromUser:(id)theUser
{    
    [WCAlertView showAlertWithTitle:[NSString stringWithFormat:@"%@ is now calling you!", (NSString *)theUser] message:@"Do you want to Accept or Reject the videocall?" customizationBlock:^(WCAlertView *alertView) {
        
        // You can also set different appearance for this alert using customization block
        alertView.style = WCAlertViewStyleWhiteHatched;
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        [[KPDAudioUtilities sharedInstance] stopRingtone];
        
        if (buttonIndex == 0)
        {
            // Reject the videocall
            [[KPDClientSIP sharedInstance] rejectCall];
        }
        else if (buttonIndex == 1)
        {
            // Accept the videocall
            [[KPDClientSIP sharedInstance] acceptCall];
        }
        
    } cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
}

- (void)clientDidReceivedVideocall:(KPDClientSIP *)client fromUser:(NSString *)theUser
{
    NSURL *incomingVideocallAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_call" withExtension:@"wav"];
    [[KPDAudioUtilities sharedInstance] playRingtoneInLoop:incomingVideocallAudioUrl];

    [self performSelectorOnMainThread:@selector(showIncomingVideocallAlertFromUser:) withObject:theUser waitUntilDone:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[KPDClientSIP sharedInstance] removeDelegate:self];
}

@end
