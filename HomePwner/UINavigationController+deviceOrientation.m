//
//  UINavigationController+deviceOrientation.m
//  HomePwner
//
//  Created by Steven Liu on 2017-01-08.
//  Copyright © 2017 Steven Liu. All rights reserved.
//

#import "UINavigationController+deviceOrientation.h"

@implementation UINavigationController (deviceOrientation)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
