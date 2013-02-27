//
//  KPDChatMessage.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"

@interface KPDMessage : NSObject
{
    KPDUser *fromUser;
    KPDUser *toUser;
    NSString *subject;
    NSString *message;
    bool read;
    NSDate *dateMessage;
}

@property (nonatomic, retain) KPDUser *fromUser;
@property (nonatomic, retain) KPDUser *toUser;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *message;
@property (atomic) bool read;
@property (nonatomic, retain) NSDate *dateMessage;

- (id)initWithFromUser:(KPDUser *)_fromUser toUser:(KPDUser *)_toUser subject:(NSString *)_subject message:(NSString *)_message read:(bool)_read date:(NSDate *)_dateMessage;
- (void)retrieveDataFromWebService;
- (void)saveToDatabase;
- (bool)messageIsInDatabaseWithUser:(KPDUser *)usera andUser:(KPDUser *)userb withDate:(NSDate *)msgdate;
+ (NSArray *)retrieveMessagesOfUser:(KPDUser *)user;

@end
