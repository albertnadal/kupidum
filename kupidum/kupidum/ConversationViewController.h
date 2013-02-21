//
//  ConversationViewController.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 28/12/12.
//  Copyright (c) 2012 laFruitera.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "KPDClientSIP.h"
#import "KPDAudioUtilities.h"

@interface ConversationViewController : UIViewController<UIBubbleTableViewDataSource, KPDClientSIPDelegate>

@end
