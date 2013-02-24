//
//  KupidumDB.h
//  kupidum
//
//  Created by Albert Nadal Garriga on 24/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

@interface KupidumDBSingleton : NSObject
{
    FMDatabase *db;
}

@property (nonatomic, retain) FMDatabase *db;

+ (KupidumDBSingleton *)sharedInstance;

@end
