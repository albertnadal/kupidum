//
//  MessageDetailViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 27/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageComposeViewController.h"
#import "KPDUIUtilities.h"

@interface MessageDetailViewController ()
- (void)showNavigationBarButtons;
- (void)backPressed;
@end

@implementation MessageDetailViewController

@synthesize fromAvatar, toAvatar, fromLabel, toLabel, dateLabel, subjectLabel, messageLabel, scroll, sendMessageButton, msg;

- (id)initWithNibName:(NSString *)nibNameOrNil withMsg:(KPDMessage *)_msg
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        msg = _msg;
        self.title = [NSString stringWithFormat:@"%@ →%@", [msg.fromUser username], [msg.toUser username]];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)replyMessage:(id)sender
{    
    MessageComposeViewController *mcvc = [[MessageComposeViewController alloc] initWithNibName:@"MessageComposeViewController" toUser:[msg fromUser] fromUser:[msg toUser]];
    [self.navigationController pushViewController:mcvc animated:YES];
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

@end
