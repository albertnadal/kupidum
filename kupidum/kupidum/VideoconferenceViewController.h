//
//  HomeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDClientSIP.h"
#import "KPDAudioUtilities.h"

@interface VideoconferenceViewController : UIViewController<UIAlertViewDelegate, KPDClientSIPDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIView *videoView;
    IBOutlet UIView *panelView;

    KPDUser *remoteUser;
}

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UIView *panelView;
@property (strong, nonatomic) KPDUser *remoteUser;

- (id)initWithNibName:(NSString *)nibNameOrNil withRemoteUser:(KPDUser *)_remoteUser;
- (IBAction)connect:(id)sender;
- (IBAction)callUser:(id)sender;
- (IBAction)hangUp:(id)sender;
- (void)showEmbededVideoView;
- (void)sendCallRequest;
- (void)showNavigationBarButtons;
- (void)backPressed;
- (void)showPanel;
- (void)segmentedViewController:(id)sender;

@end
