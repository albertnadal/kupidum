//
//  HomeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 23/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "VideoconferenceViewController.h"

@interface VideoconferenceViewController ()

@end

@implementation VideoconferenceViewController

@synthesize usernameField;
@synthesize passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)connect:(id)sender
{
    KPDClientSIP *clientSip = [KPDClientSIP sharedInstance];
    [clientSip registerToServerWithUser:[usernameField text] password:[passwordField text]];
}

- (IBAction)callUser:(id)sender
{
    KPDClientSIP *clientSip = [KPDClientSIP sharedInstance];
    [clientSip callUser:@"silvia" withVideo:TRUE];
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

@end
