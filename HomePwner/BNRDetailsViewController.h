//
//  BNRDetailsViewController.h
//  HomePwner
//
//  Created by Steven Liu on 2016-06-14.
//  Copyright © 2016 Steven Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailsViewController : UIViewController

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
