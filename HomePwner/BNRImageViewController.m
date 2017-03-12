//
//  BNRImageViewController.m
//  HomePwner
//
//  Created by Steven Liu on 2017-03-11.
//  Copyright © 2017 Steven Liu. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BNRImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _setupViewForZoom];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.image = self.image;
    self.imageView.center = self.view.center;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)_setupViewForZoom
{
    CGRect screenRect = self.view.bounds;
    
    [self _setupScrollViewWithFrame:screenRect];
    [self _setupImageViewWithFrame:screenRect];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}

- (void)_setupScrollViewWithFrame:(CGRect)frame
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = frame.size;
    self.scrollView.delegate = self;
}

- (void)_setupImageViewWithFrame:(CGRect)frame
{
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
@end
