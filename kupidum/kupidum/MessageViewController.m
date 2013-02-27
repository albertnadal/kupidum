//
//  ChatViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "KPDUserSingleton.h"
#import "KPDUser.h"
#import "KPDMessage.h"

@interface MessageViewController ()
{
    NSArray *usersHistory;
}
@end

@implementation MessageViewController

- (id)init
{
    if(self = [super init])
    {
        self.title = NSLocalizedString(@"Missatges", @"");
        usersHistory = nil;
        [self reloadUsersHistoryList];
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Missatges", @"");
        usersHistory = nil;
        [self reloadUsersHistoryList];
    }
    return self;
}

- (void)showNavigationBarButtons
{
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Edit", @"")
                                                                                style: UIBarButtonItemStyleDone
                                                                               target: self.navigationController
                                                                               action: @selector(editMessages)]];
}

- (void)reloadUsersHistoryList
{
    NSString *localUsername = [[KPDUserSingleton sharedInstance] username];
    KPDUser *user1 = [[KPDUser alloc] initWithUsername:localUsername];

    usersHistory = [KPDMessage retrieveMessagesOfUser:user1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [usersTable reloadData];
    [self showNavigationBarButtons];
}

- (void)dealloc
{
    
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

    KPDMessage *msg = [usersHistory objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateMessage = [formatter stringFromDate:[msg dateMessage]];

    if (!cell)
    {
        NSString *remote_username = [[msg toUser] username];
        if([remote_username isEqualToString:[[KPDUserSingleton sharedInstance] username]])
            remote_username = [[msg toUser] username];

        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMessage:msg remoteUser:remote_username withDate:dateMessage];
    }
    else
    {
        [[[(MessageCell *)cell ucvc] headOfMessage] setText:[msg message]];
        [[[(MessageCell *)cell ucvc] subject] setText:[msg subject]];
        [[[(MessageCell *)cell ucvc] dateUpdate] setText:dateMessage];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KPDMessage *msg = [usersHistory objectAtIndex:indexPath.row];

/*    ConversationViewController *cvc = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" withChat:chat];
    [self.navigationController pushViewController:cvc animated:YES];*/

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
