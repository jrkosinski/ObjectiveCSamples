//
//  UIViewController+CartMethods.m
//  [Client Name]
//
//  Created by John Kosinski on 10/12/15.
//


#import "UIViewController+CartMethods.h"
#import "UIViewControllerAdditions.h"
#import "FDCartViewController.h"
#import "FDCheckOutViewController.h"

@implementation UIViewController (CartMethods)

-(void)showCart {
    [self showCart:true];
}

-(void)showCart:(BOOL)push {
    FDCartViewController *viewController = [[FDCartViewController alloc] initWithNibName: @"FDCartView"  bundle: nil];
    
    if (viewController)
    {
        [self.navigationController pushViewController: viewController  animated: YES];
    }
    [viewController release];
}

@end
