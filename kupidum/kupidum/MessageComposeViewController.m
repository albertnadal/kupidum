//
//  MessageComposeViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 27/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "MessageComposeViewController.h"
#import "KPDUIUtilities.h"

@interface MessageComposeViewController ()
- (void)showNavigationBarButtons;
- (void)backPressed;
- (void)sendMessageAndGoBack;
@end

@implementation MessageComposeViewController

@synthesize fromAvatar, fromLabel, scroll, fromUser, toUser, subjectField, messageText;

- (id)initWithNibName:(NSString *)nibNameOrNil toUser:(KPDUser *)tuser fromUser:(KPDUser *)fuser
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        fromUser = fuser;
        toUser = tuser;
        self.title = [NSString stringWithFormat:@"%@ →%@", [fromUser username], [toUser username]];
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

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Send", @"")
                                                                                style: UIBarButtonItemStyleDone
                                                                               target: self
                                                                               action: @selector(sendMessageAndGoBack)]];
}

- (void)sendMessageAndGoBack
{
    // Implement sendMessage!
    // [self sendMessage];
    [self backPressed];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [subjectField setText:@""];
    [messageText setText:@""];
    [self showNavigationBarButtons];
    [subjectField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
