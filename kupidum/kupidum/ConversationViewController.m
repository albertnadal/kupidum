//
//  ConversationViewController.h.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 28/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "ConversationViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "KPDUserSingleton.h"
#import "KPDChatConversation.h"
#import "KPDChatMessage.h"
#import "KPDUser.h"

@interface ConversationViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;

    NSMutableArray *bubbleData;
}

- (void)reloadDataAfterSendMessage;

@end

@implementation ConversationViewController

@synthesize chat;

- (id)initWithNibName:(NSString *)nibNameOrNil withChat:(KPDChat *)_chat
{
    if(self = [self initWithNibName:nibNameOrNil bundle:nil])
    {
        chat = _chat;

        if([[[chat usernameA] username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
                self.title = [[chat usernameA] username];
        else    self.title = [[chat usernameB] username];
    }

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[KPDClientSIP sharedInstance] addDelegate:self];
        chat = nil;
    }
    return self;
}

- (void)dealloc
{
    [[KPDClientSIP sharedInstance] removeDelegate:self];
}

- (void)clientDidReceivedInstantMessage:(KPDClientSIP *)client fromUser:(KPDUser *)fromUser withContent:(NSString *)textMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
        NSBubbleData *receivedBubble = [NSBubbleData dataWithText:textMessage date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];

        receivedBubble.avatar = [UIImage imageNamed:@"img_front_face_anonymous_woman.png"];

        if([[[chat usernameA] username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
        {
            // My avatar
            if(([[chat usernameA] avatarURL]) && (![[[chat usernameA] avatarURL] isEqualToString:@""]))
                receivedBubble.avatar = [[chat usernameA] avatar];
        }
        else
        {
            // Remote user avatar
            if(([[chat usernameB] avatarURL]) && (![[[chat usernameB] avatarURL] isEqualToString:@""]))
                receivedBubble.avatar = [[chat usernameB] avatar];
        }

        [bubbleData addObject:receivedBubble];
        [bubbleTable reloadData];

//        NSURL *incomingMessageAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_message" withExtension:@"aif"];
//        [[KPDAudioUtilities sharedInstance] playRingtone:incomingMessageAudioUrl];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    textField.text = @"";
    [textField resignFirstResponder];

    if(!chat)
        return;

    KPDChatConversation *conversation = [chat conversation];
    bubbleData = [[NSMutableArray alloc] init]; //initWithObjects:heyBubble, photoBubble, replyBubble, nil];

    for(int i=0; i < [[conversation chatMessages] count]; i++)
    {
        KPDChatMessage *msg = [[conversation chatMessages] objectAtIndex:i];

        NSBubbleType msgDirection;
        UIImage *avatar = nil;

        if([[[msg fromUser] username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
        {
            // Message from local user
            msgDirection = BubbleTypeMine;
            avatar = [[msg fromUser] avatar];
        }
        else
        {
            // Message from remote user
            msgDirection = BubbleTypeSomeoneElse;
            avatar = [[msg toUser] avatar];
        }

        NSBubbleData *sayBubble = [NSBubbleData dataWithText:[msg message] date:[msg dateMessage] type:msgDirection];

        sayBubble.avatar = [UIImage imageNamed:@"img_front_face_anonymous_woman.png"];

        if([[[chat usernameA] username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
        {
            // My avatar
            if(([[chat usernameA] avatarURL]) && (![[[chat usernameA] avatarURL] isEqualToString:@""]))
                sayBubble.avatar = [[chat usernameA] avatar];
        }
        else
        {
            // Remote user avatar
            if(([[chat usernameB] avatarURL]) && (![[[chat usernameB] avatarURL] isEqualToString:@""]))
                sayBubble.avatar = [[chat usernameB] avatar];
        }

        [bubbleData addObject:sayBubble];
    }

    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= (kbSize.height - self.navigationController.navigationBar.frame.size.height - 5.0);
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= (kbSize.height - self.navigationController.navigationBar.frame.size.height - 5.0);
        bubbleTable.frame = frame;
    }];

    [bubbleTable reloadData];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += (kbSize.height - self.navigationController.navigationBar.frame.size.height - 5.0);
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += (kbSize.height - self.navigationController.navigationBar.frame.size.height - 5.0);
        bubbleTable.frame = frame;
    }];
}

- (void)reloadDataAfterSendMessage
{
    NSURL *outgoingMessageAudioUrl = [[NSBundle mainBundle] URLForResource:@"send_message" withExtension:@"aif"];
    [[KPDAudioUtilities sharedInstance] playRingtone:outgoingMessageAudioUrl];

    [bubbleTable reloadData];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    KPDUser *toUser = [chat usernameA];

    if([[toUser username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
        toUser = [chat usernameB];

    [[KPDClientSIP sharedInstance] sendInstantMessageToUser:toUser withContent:textField.text];

    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];

    sayBubble.avatar = [UIImage imageNamed:@"img_front_face_anonymous_woman.png"];
    
    if([[[chat usernameA] username] isEqualToString:[[KPDUserSingleton sharedInstance] username]])
    {
        // My avatar
        if(([[chat usernameA] avatarURL]) && (![[[chat usernameA] avatarURL] isEqualToString:@""]))
            sayBubble.avatar = [[chat usernameA] avatar];
    }
    else
    {
        // Remote user avatar
        if(([[chat usernameB] avatarURL]) && (![[[chat usernameB] avatarURL] isEqualToString:@""]))
            sayBubble.avatar = [[chat usernameB] avatar];
    }

    [bubbleData addObject:sayBubble];

    textField.text = @"";
    [textField resignFirstResponder];

    [NSTimer scheduledTimerWithTimeInterval:0.25f
                                     target:self
                                   selector:@selector(reloadDataAfterSendMessage)
                                   userInfo:nil
                                    repeats:NO];
}

@end

