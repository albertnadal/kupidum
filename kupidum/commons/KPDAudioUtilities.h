//
//  KPDAudioUtilities.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 30/12/12.
//  Copyright (c) 2012 Albert Nadal Garriga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPDAudioUtilities : NSObject

+ (KPDAudioUtilities *)sharedInstance;
- (void)playRingtoneInLoop:(NSURL *)ringtonePath;
- (void)playRingtone:(NSURL *)ringtonePath;
- (void)stopRingtone;

@end
