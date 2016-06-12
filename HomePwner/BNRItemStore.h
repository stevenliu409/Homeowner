//
//  BNRItemStore.h
//  HomePwner
//
//  Created by Steven Liu on 2016-06-11.
//  Copyright © 2016 Steven Liu. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BNRItem;
@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;
@end
