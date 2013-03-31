//
//  UserNavigatorProfileViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 31/03/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "UserNavigatorProfileViewController.h"

@interface UserNavigatorProfileViewController ()

@end

@implementation UserNavigatorProfileViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Invisible selector button
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setBackgroundColor:[UIColor clearColor]];
    [selectButton addTarget:self action:@selector(showFullUserProfile:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.frame = self.view.frame;
    [self.view addSubview:selectButton];
}

- (IBAction)showFullUserProfile:(id)sender
{
    [self.delegate showUserProfile:@"albert"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
