//
//  UserChatCell.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 21/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize ucvc, msg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMessage:(KPDMessage *)_msg remoteUser:(NSString *)_remote_user withDate:(NSString *)_date
{
    if(self = [[MessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        NSLog(@"Subject: %@ | Message: %@", [_msg subject], [_msg message]);
        [[ucvc username] setText:_remote_user];
        [[ucvc subject] setText:[_msg subject]];
        [[ucvc headOfMessage] setText:[_msg message]];
        [[ucvc dateUpdate] setText:_date];
    }

    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];

        ucvc = [[MessageCellViewController alloc] initWithNibName:@"MessageCellViewController" bundle:nil];
        [self.contentView addSubview:ucvc.view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
