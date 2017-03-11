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
#import "BNRImageStore.h"
#import "BNRImageViewController.h"
#import "BNRDetailsViewController.h"
#import "BNRItemCell.h"

@interface BNRItemsViewController() <UIPopoverPresentationControllerDelegate>

@end

@implementation BNRItemsViewController

//Designated init method
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self) {
        
        self.navigationItem.title = @"Homepwner";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    
    NSArray *itemArray = [[BNRItemStore sharedStore] allItems];
   
    BNRItem *item = itemArray[indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    __weak BNRItemCell *weakCell = cell;
    cell.actionBlock = ^{
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            BNRItemCell *strongCell = weakCell;
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:item.itemKey];
            
            if (!img)
            {
                return;
            }

            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            ivc.preferredContentSize = CGSizeMake(600, 600);
            ivc.modalPresentationStyle = UIModalPresentationPopover;
            [self presentViewController:ivc animated:YES completion:nil];
            
            UIPopoverPresentationController *popoverController = [ivc popoverPresentationController];
            popoverController.delegate = self;
            popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popoverController.sourceRect = strongCell.thumbnailView.bounds;
            popoverController.sourceView = strongCell.thumbnailView;
        }
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (IBAction)addNewItem:(id)sender
{
    //Create new item and add it to the data store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    BNRDetailsViewController *detailsVC = [[BNRDetailsViewController alloc] initForNewItem:YES];
    detailsVC.item = newItem;
    detailsVC.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailsVC];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailsViewController *detailsVC = [[BNRDetailsViewController alloc] initForNewItem:NO];
    NSArray *itemsArray = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = itemsArray[indexPath.row];
    detailsVC.item = selectedItem;
    
    [self.navigationController pushViewController:detailsVC animated:YES];
}

@end
