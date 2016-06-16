//
//  BNRDetailsViewController.m
//  HomePwner
//
//  Created by Steven Liu on 2016-06-14.
//  Copyright © 2016 Steven Liu. All rights reserved.
//

#import "BNRDetailsViewController.h"
#import "BNRImageStore.h"
#import "BNRItem.h"

@interface BNRDetailsViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) UIView *crossHairOverlay;
@end

@implementation BNRDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter;
    
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text =[dateFormatter stringFromDate:item.dateCreated];
    self.imageView.image = [[BNRImageStore sharedStore] imageForKey:item.itemKey];
    
    // Need to hide the crosshairs when user finish taking the photo or else app will crash
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCrossHairsView:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCrossHairsView:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
    
}
- (IBAction)takePicture:(id)sender {
     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.crossHairOverlay = [self createCameraOverlay];
        [imagePicker setCameraOverlayView:self.crossHairOverlay];
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageView.image = info[UIImagePickerControllerEditedImage];
    [[BNRImageStore sharedStore] setImage:self.imageView.image forKey:self.item.itemKey];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)clearImage:(id)sender
{
    self.imageView.image = nil;
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
}


- (UIView *)createCameraOverlay
{
    
    CGPoint center;
    center.x = self.view.bounds.origin.x + self.view.bounds.size.width/2.0;
    center.y = self.view.bounds.origin.y + self.view.bounds.size.height/2.0;
    
    // navbar height = 40px
    UIView *crossHairView = [[UIView alloc] initWithFrame:CGRectMake(center.x-15, center.y-55, 30, 30)];
    crossHairView.opaque = NO;
    crossHairView.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *crossHairLayer = [[CAShapeLayer alloc] init];
    crossHairLayer.strokeColor = [UIColor redColor].CGColor;
    
    UIBezierPath *line = [UIBezierPath bezierPath];

    CGPoint p1 = CGPointMake(0,15);
    CGPoint p2 = CGPointMake(30, 15);
    CGPoint p3 = CGPointMake(15, 0);
    CGPoint p4 = CGPointMake(15, 30);
    [line moveToPoint:p1];
    [line addLineToPoint:p2];
    [line closePath];
    [line moveToPoint:p3];
    [line addLineToPoint:p4];
    [line closePath];
    
    [crossHairLayer setPath:line.CGPath];
    [[crossHairView layer] addSublayer:crossHairLayer];

    return crossHairView;
}


- (void)hideCrossHairsView:(NSNotification *)message
{
    if ([message.name isEqualToString:@"_UIImagePickerControllerUserDidCaptureItem"]) {
        self.crossHairOverlay.hidden = YES;
    } else {
        self.crossHairOverlay.hidden = NO;
    }
}

@end
