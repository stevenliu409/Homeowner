//
//  BNRItemsViewController.m
//  HomePwner
//
//  Created by Steven Liu on 2016-06-11.
//  Copyright © 2016 Steven Liu. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation BNRItemsViewController


- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self) {
        for (int i = 0; i<5; i++){
            [[BNRItemStore sharedStore] createItem];
        }
    }
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}




@end
