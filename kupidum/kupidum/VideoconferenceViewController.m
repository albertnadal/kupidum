//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VideoconferenceViewController.h"
#import "KPDUIUtilities.h"

@interface VideoconferenceViewController ()

@end

@implementation VideoconferenceViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize videoView;
@synthesize remoteUser;

- (id)initWithNibName:(NSString *)nibNameOrNil withRemoteUser:(KPDUser *)_remoteUser
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        remoteUser = _remoteUser;
        self.title = [remoteUser username];

        [[KPDClientSIP sharedInstance] addDelegate:self];
    }
    return self;
}

- (void)showNavigationBarButtons
{
    UIButton *backButton = [KPDUIUtilities customCircleBarButtonWithImage:@"nav_black_circle_button.png"
                                                           andInsideImage:@"nav_arrow_back_button.png"
                                                              andSelector:@selector(backPressed)
                                                                andTarget:self];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];
}

- (void)backPressed
{
    [[KPDClientSIP sharedInstance] hangUp];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)sendCallRequest
{
    [[KPDClientSIP sharedInstance] callUser:[remoteUser username] withVideo:TRUE];

    [self showEmbededVideoView];
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

- (void)videoconferenceDidBegan:(KPDClientSIP *)client withRemoteUser:(KPDUser *)user
{
    [self showEmbededVideoView];
}

- (void)clientDidReceivedVideocall:(KPDClientSIP *)client fromUser:(NSString *)theUser
{
//    NSURL *incomingVideocallAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_call" withExtension:@"wav"];
//    [[KPDAudioUtilities sharedInstance] playRingtoneInLoop:incomingVideocallAudioUrl];

//    [self performSelectorOnMainThread:@selector(showIncomingVideocallAlertFromUser:) withObject:theUser waitUntilDone:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNavigationBarButtons];
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
