//
//  UserProfileViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 10/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IBAForms/IBAFormViewController.h>
#import <IBAforms/IBAFormConstants.h>

@interface UserProfileViewController : IBAFormViewController
{
    IBOutlet UIScrollView *scroll;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end
