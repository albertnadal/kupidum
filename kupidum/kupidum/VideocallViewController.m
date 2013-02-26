//
//  VideocallViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "VideocallViewController.h"
#import "VideoconferenceViewController.h"
#import "UserChatCell.h"
#import "KPDUser.h"
#import "KPDVideocall.h"
#import "KPDUserSingleton.h"
#import "WCAlertView.h"

@interface VideocallViewController ()
{
    NSArray *usersHistory;
}
@end

@implementation VideocallViewController

- (id)init
{
    if(self = [super init])
    {
        self.title = NSLocalizedString(@"Videotrucades", @"");
        usersHistory = nil;
        [[KPDClientSIP sharedInstance] addDelegate:self];
        [self reloadUsersHistoryList];
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Videotrucades", @"");
        usersHistory = nil;
        [[KPDClientSIP sharedInstance] addDelegate:self];
        [self reloadUsersHistoryList];
    }
    return self;
}

- (void)videoconferenceDidBegan:(KPDClientSIP *)client withRemoteUser:(KPDUser *)user
{
    NSLog(@"Videoconference begins");
}

- (void)clientDidSendVideocallRequestToUser:(KPDUser *)toUser
{
    // Refresh the user videocall historic
    [self reloadUsersHistoryList];
}

- (void)clientDidReceivedVideocall:(KPDClientSIP *)client fromUser:(NSString *)theUser
{
    NSURL *incomingVideocallAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_call" withExtension:@"wav"];
    [[KPDAudioUtilities sharedInstance] playRingtoneInLoop:incomingVideocallAudioUrl];

    // Refresh the user videocall historic
    [self reloadUsersHistoryList];

    [self performSelectorOnMainThread:@selector(showIncomingVideocallAlertFromUser:) withObject:theUser waitUntilDone:YES];
}

- (void)showIncomingVideocallAlertFromUser:(id)theUser
{
    KPDUser *fromUser = [[KPDUser alloc] initWithUsername:theUser];
    KPDUser *toUser = [[KPDUser alloc] initWithUsername:[[KPDUserSingleton sharedInstance] username]];
    KPDVideocall *videocall = [[KPDVideocall alloc] initWithFromUser:fromUser andToUser:toUser andIsIncoming:true andDate:[NSDate date]];

    [WCAlertView showAlertWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ is now calling you!", @""), (NSString *)theUser] message:NSLocalizedString(@"Do you want to Accept or Reject the videocall?", @"") customizationBlock:^(WCAlertView *alertView) {

        // You can also set different appearance for this alert using customization block
        alertView.style = WCAlertViewStyleWhiteHatched;
        alertView.alertViewStyle = UIAlertViewStyleDefault;

    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        [[KPDAudioUtilities sharedInstance] stopRingtone];

        if (buttonIndex == 0)
        {
            // Reject the videocall
            [videocall setMissed:true];

            [[KPDClientSIP sharedInstance] rejectCall];
        }
        else if (buttonIndex == 1)
        {
            // Accept the videocall
            [videocall setMissed:false];

            bool animated = ([self.tabBarController selectedViewController] == self);

            VideoconferenceViewController *vvc = [[VideoconferenceViewController alloc] initWithNibName:@"VideoconferenceViewController" withRemoteUser:fromUser];
            [self.navigationController pushViewController:vvc animated:animated];

            [self.tabBarController setSelectedViewController:self.navigationController];

            [[KPDClientSIP sharedInstance] acceptCall];
        }

        [videocall saveToDatabase];
        [self reloadUsersHistoryList];

    } cancelButtonTitle:NSLocalizedString(@"Reject", @"") otherButtonTitles:NSLocalizedString(@"Accept", @""), nil];
}

/*- (void)clientDidReceivedInstantMessage:(KPDClientSIP *)client fromUser:(KPDUser *)fromUser withContent:(NSString *)textMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{

        // Load from database new possible conversations
        [self reloadUsersHistoryList];

        // Reload table of active chats
        [self.usersTable reloadData];
        [self.view setNeedsDisplay];

        // Play sound
        NSURL *incomingMessageAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_message" withExtension:@"aif"];
        [[KPDAudioUtilities sharedInstance] playRingtone:incomingMessageAudioUrl];
    });
}*/

- (void)reloadUsersHistoryList
{
    NSString *localUsername = [[KPDUserSingleton sharedInstance] username];
    KPDUser *user1 = [[KPDUser alloc] initWithUsername:localUsername];

    usersHistory = [KPDVideocall retrieveVideocallsOfUser:user1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [usersTable reloadData];
}

- (void)dealloc
{
    [[KPDClientSIP sharedInstance] removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(usersHistory)    return [usersHistory count];
    else                return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    KPDVideocall *videocall = [usersHistory objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateCall = [formatter stringFromDate:[videocall dateCall]];

    if (!cell)
    {
        NSString *remote_username = [[videocall toUser] username];
        if([remote_username isEqualToString:[[KPDUserSingleton sharedInstance] username]])
            remote_username = [[videocall fromUser] username];

        cell = [[UserChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier username:remote_username lastMessage:@"" lastDateMessage:dateCall];
    }
    else
    {
        [[[(UserChatCell *)cell ucvc] lastMessage] setText:@""];
        [[[(UserChatCell *)cell ucvc] dateUpdate] setText:dateCall];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KPDVideocall *chat = [usersHistory objectAtIndex:indexPath.row];
    KPDUser *remoteUser = nil;

    if([[[chat toUser] username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
            remoteUser = [chat fromUser];
    else    remoteUser = [chat toUser];

    VideoconferenceViewController *vvc = [[VideoconferenceViewController alloc] initWithNibName:@"VideoconferenceViewController" withRemoteUser:remoteUser];
    [vvc sendCallRequest];

    [self.navigationController pushViewController:vvc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
