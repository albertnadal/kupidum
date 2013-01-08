//
//  SearchResultCell.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 08/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];

        srvc = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
        [self.contentView addSubview:srvc.view];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
