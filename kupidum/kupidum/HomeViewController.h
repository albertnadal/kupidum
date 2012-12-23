//
//  HomeViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPDClientSIP.h"

@interface HomeViewController : UIViewController
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
}

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)connect:(id)sender;

@end
