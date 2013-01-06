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
}

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIView *videoView;

- (IBAction)connect:(id)sender;
- (IBAction)callUser:(id)sender;
- (IBAction)hangUp:(id)sender;
- (void)showEmbededVideoView;
- (void)showIncomingVideocallAlertFromUser:(id)theUser;

@end
