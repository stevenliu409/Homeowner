//
//  BNRItemStore.m
//  HomePwner
//
//  Created by Steven Liu on 2016-06-11.
//  Copyright © 2016 Steven Liu. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore;
    
    if(!sharedStore) {
        sharedStore = [[BNRItemStore alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
               format:@"Use +[BNRItemStore sharedStore]"];
    return nil;
}

- (instancetype) initPrivate
{
    if(self = [super init]) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}


- (NSArray *)allItems
{
    return [self.privateItems copy];
}

-(BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    return item;
}

@end
