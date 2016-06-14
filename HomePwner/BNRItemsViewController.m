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
    
    NSMutableArray *arr = self.filterArray[indexPath.section];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"valueInDollars" ascending:YES];
    
    [arr sortUsingDescriptors:@[sortDesc]];
    
    if (indexPath.row < [arr count]) {
        cell.textLabel.text = [arr[indexPath.row] description];
        tableView.rowHeight = 60;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
        cell.imageView.image = [UIImage imageNamed:@"Icon"];
    } else {
        cell.textLabel.text = @"No More Items";
        tableView.rowHeight = 44;
    }
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.filterArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.filterArray[section] count] + 1;
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
    
    [wrapperArray addObject:greaterThanAmount];
    [wrapperArray addObject:lessThanAmount];
    
    return wrapperArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  @"Greater than 50";
    } else {
        return @"Less than 50";
    }
}




@end
