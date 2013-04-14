//
//  KupidumDB.m
//  kupidum
//
//  Created by Albert Nadal Garriga on 24/02/13.
//  Copyright (c) 2013 laFruitera.com. All rights reserved.
//

#import "KupidumDBSingleton.h"

@implementation KupidumDBSingleton

@synthesize db;

- (id)init
{
    if(self = [super init])
    {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@.db", [searchPaths objectAtIndex:0], KUPIDUM_DB_FILENAME];

        db = [FMDatabase databaseWithPath:dbPath];

#warning Disable the following log traces
        db.logsErrors = YES;
        db.traceExecution = NO;

        if (![db open])
        {
            NSLog(@"Could not open db.");
            return nil;
        }
    }

    return self;
}

+ (KupidumDBSingleton *)sharedInstance
{
    static dispatch_once_t onceToken;
    static KupidumDBSingleton *_instance;
    
    dispatch_once(&onceToken, ^{
        _instance = [[KupidumDBSingleton alloc] init];
    });
    
    return _instance;
}

@end
