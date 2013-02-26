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
#import "AKSegmentedControl.h"

@interface VideoconferenceViewController ()

@end

@implementation VideoconferenceViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize videoView;
@synthesize remoteUser;
@synthesize panelView;

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

- (void)showPanel
{
    [panelView setBackgroundColor:[UIColor clearColor]];
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(12.0, 11.0, 110.0, 42.0)];
    [segmentedControl addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [segmentedControl setSelectedIndex:0];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [segmentedControl setBackgroundImage:backgroundImage];
    [segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-left.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-right.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // Button 1
    UIButton *buttonSocial = [[UIButton alloc] init];
    UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"img_front_camera"];
    
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
    [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *buttonStar = [[UIButton alloc] init];
    UIImage *buttonStarImageNormal = [UIImage imageNamed:@"img_back_camera"];
    
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateNormal];
    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateSelected];
    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateHighlighted];
    [buttonStar setImage:buttonStarImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];

    [segmentedControl setButtonsArray:@[buttonSocial, buttonStar]];
    [panelView addSubview:segmentedControl];
}

- (void)segmentedViewController:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    NSIndexSet *indexs = [segmentedControl selectedIndexes];

    switch ([indexs firstIndex])
    {
        case 0: [[KPDClientSIP sharedInstance] useFrontalCamera];
                break;

        case 1: [[KPDClientSIP sharedInstance] useBackCamera];
                break;

        default:
            break;
    }

}

- (void)showNavigationBarButtons
{
    [self.navigationItem setHidesBackButton:YES];

/*    UIButton *backButton = [KPDUIUtilities customCircleBarButtonWithImage:@"nav_black_circle_button.png"
                                                           andInsideImage:@"nav_arrow_back_button.png"
                                                              andSelector:@selector(backPressed)
                                                                andTarget:self];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];*/
}

- (void)backPressed
{
    //[[KPDClientSIP sharedInstance] hangUp];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showEmbededVideoView
{
    int ingoingVideoWidth = 320;
    int ingoingVideoHeight = 392;

    CGRect remoteCgrect = CGRectMake(0, 0, ingoingVideoWidth, ingoingVideoHeight);

    [[KPDClientSIP sharedInstance] setVideoStreamViewFrame:remoteCgrect];
    [[KPDClientSIP sharedInstance] setIngoingVideoStreamViewFrame:remoteCgrect];
    [[KPDClientSIP sharedInstance] setIngoingVideoStreamViewHidden:false];

    CGRect localCgrect = CGRectMake(0, 0, ingoingVideoWidth, ingoingVideoHeight); //CGRectMake(0, ingoingVideoHeight - outgoingVideoHeight, outgoingVideoWidth, outgoingVideoHeight);

    [[KPDClientSIP sharedInstance] setOutgoingVideoStreamViewFrame:localCgrect];
    [[KPDClientSIP sharedInstance] setOutgoingVideoStreamViewHidden:false];


    // All possible old views inside the videoView must be removed
    for (UIView *view in videoView.subviews) {
        [view removeFromSuperview];
    }

    UIView *remoteView = [[KPDClientSIP sharedInstance] getVideoStreamView]; //getIngoingVideoStreamView];
/*    remoteView.contentMode = UIViewContentModeScaleToFill;
    remoteView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [remoteView setFrame:remoteCgrect];
    [remoteView setNeedsDisplay];
    [remoteView reloadInputViews];
    [remoteView setFrame:remoteCgrect];
    [remoteView.layer setFrame:remoteCgrect];*/

    // We add the ingoing video view from app_pjsip into the videoView
    [videoView addSubview:remoteView];
    [videoView reloadInputViews];

    // Preview view
    UIView *localView = [[KPDClientSIP sharedInstance] getOutgoingVideoStreamView];
    [remoteView addSubview:localView];
//    [videoView reloadInputViews];

    [[KPDClientSIP sharedInstance] setOutgoingVideoStreamViewFrame:localCgrect];
    [self performSelectorOnMainThread:@selector(updatePreviewFrame) withObject:nil waitUntilDone:YES];

    [videoView setNeedsDisplay];
}

- (void)updatePreviewFrame
{
    int ingoingVideoWidth = 320;
    int ingoingVideoHeight = 392;

    // (0, 256, 112, 136)
    CGRect localCgrect = CGRectMake(0, 0, ingoingVideoWidth, ingoingVideoHeight);
    //CGRectMake(0, ingoingVideoHeight - outgoingVideoHeight, outgoingVideoWidth, outgoingVideoHeight);

    [[KPDClientSIP sharedInstance] setOutgoingVideoStreamViewFrame:localCgrect];
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

//    [self showEmbededVideoView];
}

- (IBAction)callUser:(id)sender
{
    [[KPDClientSIP sharedInstance] callUser:@"silvia" withVideo:TRUE];

//    [self showEmbededVideoView];
}

- (IBAction)hangUp:(id)sender
{
    [[KPDClientSIP sharedInstance] hangUp];
    [self performSelectorOnMainThread:@selector(backPressed) withObject:nil waitUntilDone:YES];
}

- (void)videoconferenceDidBegan:(KPDClientSIP *)client withRemoteUser:(KPDUser *)user
{
//    [self showEmbededVideoView];
//    [self performSelectorOnMainThread:@selector(showEmbededVideoView) withObject:nil waitUntilDone:YES];
}

- (void)videoconferenceDidEnd:(KPDClientSIP *)client withRemoteUser:(KPDUser *)user
{
    [[KPDClientSIP sharedInstance] hangUp];
    [self performSelectorOnMainThread:@selector(backPressed) withObject:nil waitUntilDone:YES];
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
    [self showPanel];
    [self showEmbededVideoView];
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
