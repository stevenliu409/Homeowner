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

@interface BNRItemsViewController ()
@property (nonatomic, strong) NSMutableArray *filterArray;
@end

@implementation BNRItemsViewController

//Designated init method
- (instancetype)init
{
    if(self = [super initWithStyle:UITableViewStylePlain]) {
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.filterArray = [[NSMutableArray alloc] init];
    self.filterArray = [self filterArray:[[BNRItemStore sharedStore] allItems] withAmount:50];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSMutableArray *arr = self.filterArray[indexPath.section][@"array"];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"valueInDollars" ascending:YES];
    
    [arr sortUsingDescriptors:@[sortDesc]];
    
    cell.textLabel.text = [arr[indexPath.row] description];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.filterArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.filterArray[section][@"array"] count];
}

- (NSMutableArray *)filterArray:(NSArray *)array withAmount:(int)amount
{
    NSMutableArray *greaterThanAmount = [[NSMutableArray alloc] init];
    NSMutableArray *lessThanAmount = [[NSMutableArray alloc] init];
    NSMutableArray *wrapperArray = [[NSMutableArray alloc] init];
    
    for (BNRItem *item in array) {
        if (item.valueInDollars > amount) {
            [greaterThanAmount addObject:item];
        } else {
            [lessThanAmount addObject:item];
        }
    }
    
    NSDictionary *dic;
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:greaterThanAmount, @"array",
           @"Greater than 50", @"title", nil];
    
    [wrapperArray addObject:dic];
    
    dic = [NSDictionary dictionaryWithObjectsAndKeys:lessThanAmount, @"array",
           @"Less than 50", @"title", nil];
    
    [wrapperArray addObject:dic];
    
    return wrapperArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.filterArray[section][@"title"];
}


@end
