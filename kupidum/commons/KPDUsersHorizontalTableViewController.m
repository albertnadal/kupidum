//
//  HorizontalPullToRefreshTableViewController.m
//  HorizontalPullToRefreshTable
//
//  Created by Albert Nadal Garriga on 07/01/13.
//  Copyright (c) 2013 Albert Nadal Garriga. All rights reserved.
//

#import "KPDUsersHorizontalTableViewController.h"

@interface KPDUsersHorizontalTableViewController ()

- (void)usersHorizontalTableViewControllerDidRefresh;

@end

@implementation KPDUsersHorizontalTableViewController

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        delegate = nil;

        int x = (frame.origin.x - (frame.size.width / 2)) + (frame.size.height / 2);
        int y = (frame.origin.y - (frame.size.height / 2)) + (frame.size.width / 2);

        self.view = [[UITableView alloc] initWithFrame:CGRectMake(x, y, frame.size.width, frame.size.height) style:UITableViewStylePlain];

        [self addPullToRefreshHeader];
        [(UITableView *)self.view setDataSource:self];
        [(UITableView *)self.view setDelegate:self];
        [(UITableView *)self.view setShowsHorizontalScrollIndicator:FALSE];
        [(UITableView *)self.view setShowsVerticalScrollIndicator:FALSE];
        [(UITableView *)self.view setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        ((UITableView *)self.view).transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }

    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        delegate = nil;

        // Custom initialization
    }
    return self;
}

- (void)scrollContentToLeft
{
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:5 inSection:0];
    [(UITableView *)self.view scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionBottom animated: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [self performSelector:@selector(usersHorizontalTableViewControllerDidRefresh) withObject:nil afterDelay:0.5];
}

- (void)usersHorizontalTableViewControllerDidRefresh
{
    if((delegate!=nil) && ([delegate respondsToSelector:@selector(usersHorizontalTableViewControllerDidRefresh:)]))
        [delegate usersHorizontalTableViewControllerDidRefresh:self];

    [self stopLoading];
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle: UITableViewCellStyleDefault
                reuseIdentifier: CellIdentifier];

        UIImageView *imatge = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.height,self.view.frame.size.height)];
        [imatge setImage:[UIImage imageNamed:@"fake_photo4.png"]];
        [cell.contentView addSubview:imatge];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];

        int bottom_container_height = 14;
        int bottom_container_padding = 1;
        int age_text_width = 18;

        UIView *bottom_container = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottom_container_height, self.view.frame.size.height, bottom_container_height)];
        [bottom_container setBackgroundColor:[UIColor blackColor]];
        [bottom_container setAlpha:0.60];
        [cell.contentView addSubview:bottom_container];

        UILabel *age_text = [[UILabel alloc] initWithFrame:CGRectMake(bottom_container_padding, bottom_container.frame.origin.y, age_text_width, bottom_container_height)];
        [age_text setTextColor:[UIColor whiteColor]];
        [age_text setBackgroundColor:[UIColor clearColor]];
        [age_text setTextAlignment:NSTextAlignmentCenter];
        [age_text setText:@"23"];
        [age_text setAlpha:0.85];
        [age_text setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
        [age_text setAdjustsFontSizeToFitWidth:YES];
        [cell.contentView addSubview:age_text];

        UILabel *alias_text = [[UILabel alloc] initWithFrame:CGRectMake(age_text.frame.origin.x + age_text.frame.size.width, bottom_container.frame.origin.y, bottom_container.frame.size.width - (age_text.frame.origin.x + age_text.frame.size.width) - bottom_container_padding, bottom_container_height)];
        [alias_text setTextColor:[UIColor whiteColor]];
        [alias_text setBackgroundColor:[UIColor clearColor]];
        [alias_text setTextAlignment:NSTextAlignmentCenter];
        [alias_text setText:@"gclooney"];
        [alias_text setAlpha:0.80];
        [alias_text setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [alias_text setAdjustsFontSizeToFitWidth:YES];
        [cell.contentView addSubview:alias_text];

        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.view.frame.size.height)];
        [separator setBackgroundColor:[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f]];
        [cell.contentView addSubview:separator];

        cell.transform = CGAffineTransformMakeRotation(M_PI * -0.5);
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
