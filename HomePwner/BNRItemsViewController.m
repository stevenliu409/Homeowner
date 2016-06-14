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
@interface BNRItemsViewController()

@property (nonatomic, strong) IBOutlet UIView *headerView;

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
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *itemArray = [[BNRItemStore sharedStore] allItems];
    
    cell.textLabel.text = [[itemArray objectAtIndex:indexPath.row] description];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}



- (IBAction)addNewItem:(id)sender
{
    NSLog(@"add new item tapped");
}


-(IBAction)toggleEditingMode:(id)sender
{
    NSLog(@"edit mode tapped");
    if ((self.isEditing)) {
        [self setEditing:NO animated:YES];
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
    } else {
        [self setEditing:YES animated:YES];
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (UIView *)headerView
{
    if(!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    
    return  _headerView;
}

@end
