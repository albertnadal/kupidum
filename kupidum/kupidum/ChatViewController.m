//
//  ChatViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "ChatViewController.h"
#import "ConversationViewController.h"
#import "UserChatCell.h"
#import "KPDUser.h"
#import "KPDChat.h"

@interface ChatViewController ()
{
    NSArray *usersHistory;
}
@end

@implementation ChatViewController

- (id)init
{
    if(self = [super init])
    {
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
        usersHistory = nil;
        [[KPDClientSIP sharedInstance] addDelegate:self];
        [self reloadUsersHistoryList];
    }
    return self;
}

- (void)clientDidReceivedInstantMessage:(KPDClientSIP *)client fromUser:(KPDUser *)fromUser withContent:(NSString *)textMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{

        // Load from database new possible conversations
        [self reloadUsersHistoryList];

        // Reload all active chat conversations
/*        if(usersHistory)
            for(int i=0; i<[usersHistory count]; i++)
                [[usersHistory objectAtIndex:i] reloadConversation];*/

        // Reload table of active chats
        [self.usersTable reloadData];
        [self.view setNeedsDisplay];

        // Play sound
        NSURL *incomingMessageAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_message" withExtension:@"aif"];
        [[KPDAudioUtilities sharedInstance] playRingtone:incomingMessageAudioUrl];
    });
}

- (void)reloadUsersHistoryList
{
    NSString *localUsername = [[KPDUserSingleton sharedInstance] username];
    KPDUser *user1 = [[KPDUser alloc] initWithUsername:localUsername];

    usersHistory = [KPDChat retrieveChatsOfUser:user1];
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

    KPDChat *chat = [usersHistory objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateLastMessage = [formatter stringFromDate:[chat dateLastMessage]];

    if (!cell)
    {
        NSString *remote_username = [[chat usernameA] username];
        if([remote_username isEqualToString:[[KPDUserSingleton sharedInstance] username]])
            remote_username = [[chat usernameB] username];

        cell = [[UserChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier username:[[chat usernameA] username] lastMessage:[chat lastMessage] lastDateMessage:dateLastMessage];
    }
    else
    {
        [[[(UserChatCell *)cell ucvc] lastMessage] setText:[chat lastMessage]];
        [[[(UserChatCell *)cell ucvc] dateUpdate] setText:dateLastMessage];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KPDChat *chat = [usersHistory objectAtIndex:indexPath.row];

    ConversationViewController *cvc = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" withChat:chat];
    [self.navigationController pushViewController:cvc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
