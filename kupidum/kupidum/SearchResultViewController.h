//
//  SearchResultViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 08/01/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController
{
    IBOutlet UIImageView *image;
    IBOutlet UIImageView *greenLed;
    IBOutlet UILabel *username;
    IBOutlet UILabel *city;
    IBOutlet UILabel *age;
    IBOutlet UILabel *height;
    IBOutlet UILabel *status;
    IBOutlet UILabel *personality;
    IBOutlet UILabel *looking;
}

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *greenLed;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UILabel *height;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *personality;
@property (strong, nonatomic) IBOutlet UILabel *looking;

@end
