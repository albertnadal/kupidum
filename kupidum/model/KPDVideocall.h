//
//  KPDChat.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 22/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPDUser.h"
#import "KPDChatConversation.h"

@interface KPDVideocall : NSObject
{
    KPDUser *fromUser;
    KPDUser *toUser;
    int length;
    UIImage *firstIncomingFrame;
    bool missed;
    bool isIncomingCall;
    NSDate *dateCall;
}

@property (nonatomic, retain) KPDUser* fromUser;
@property (nonatomic, retain) KPDUser* toUser;
@property (atomic) int length;
@property (atomic) UIImage *firstIncomingFrame;
@property (atomic) bool missed;
@property (atomic) bool isIncomingCall;
@property (nonatomic, retain) NSDate *dateCall;

- (id)initWithFromUser:(KPDUser *)fuser andToUser:(KPDUser *)tuser andIsIncoming:(bool)isIncoming andDate:(NSDate *)date;
+ (NSArray *)retrieveVideocallsOfUser:(KPDUser *)user;
- (void)reloadVideocall;
- (bool)videcallIsInDatabaseWithUser:(KPDUser *)usera andUser:(KPDUser *)userb;
- (void)retrieveDataFromWebService;
- (void)saveToDatabase;


@end
