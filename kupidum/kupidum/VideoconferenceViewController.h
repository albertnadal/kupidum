//
//  HomeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDClientSIP.h"

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
- (void)showEmbededVideoView;

@end
