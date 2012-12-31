//
//  ChatViewController.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 28/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface ChatViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    
    NSMutableArray *bubbleData;
}

- (void)reloadDataAfterSendMessage;

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[KPDClientSIP sharedInstance] addDelegate:self];
    }
    return self;
}

- (void)clientDidReceivedInstantMessage:(KPDClientSIP *)client fromUser:(NSString *)fromUser withContent:(NSString *)textMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

        NSBubbleData *receivedBubble = [NSBubbleData dataWithText:textMessage date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
        receivedBubble.avatar = [UIImage imageNamed:@"avatar1.png"];

        [bubbleData addObject:receivedBubble];
        [bubbleTable reloadData];

        NSURL *incomingMessageAudioUrl = [[NSBundle mainBundle] URLForResource:@"incoming_message" withExtension:@"aif"];
        [[KPDAudioUtilities sharedInstance] playRingtone:incomingMessageAudioUrl];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
/*    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
*/    
    bubbleData = [[NSMutableArray alloc] init]; //initWithObjects:heyBubble, photoBubble, replyBubble, nil];

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
    [[KPDClientSIP sharedInstance] sendInstantMessageToUser:@"silvia" withContent:textField.text];

    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
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

