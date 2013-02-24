//
//  KPDChatMessage.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"

@interface KPDChatMessage : NSObject
{
    KPDUser *fromUser;
    KPDUser *toUser;
    NSString *message;
    NSDate *dateMessage;
}

@property (nonatomic, retain) KPDUser *fromUser;
@property (nonatomic, retain) KPDUser *toUser;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSDate *dateMessage;

- (id)initWithFromUser:(KPDUser *)_fromUser toUser:(KPDUser *)_toUser message:(NSString *)_message date:(NSDate *)_dateMessage;
- (void)saveToDatabase;

@end
