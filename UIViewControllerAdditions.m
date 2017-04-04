//
//  UIViewControllerAdditions.m
//  [Client Name]
//
//  Created by John Kosinski on 11/24/14.
//

#import "UIViewControllerAdditions.h"
#import "FreshDirectAppDelegate.h"
#import "FDNavigationController.h"

@implementation UIViewController (FDAdditions)

- (BOOL) isModal
{
    if (self.presentingViewController)
        return YES;
    else if (self.presentedViewController)
        return [self.presentedViewController isModal];
    return NO;
}


//- (UIBarButtonItem *) barBackButton: (NSString *) title
//{
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: title
//                                                                   style: UIBarButtonItemStyleDone
//                                                                  target: nil
//                                                                  action: nil];
//    return [backButton autorelease];
//}

- (void) presentModalViewController: (UIViewController *) viewController
{
    if ([viewController isKindOfClass: [UINavigationController class]])
        [((UINavigationController *)viewController).navigationBar setIOSIndependentTintDarkGreenFDColor];
    
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void) presentModalViewControllerInNavController: (UIViewController *) viewController
{
	[self presentModalViewControllerInNavController:viewController isAnimated:YES];
}

- (void) presentModalViewControllerInNavController: (UIViewController *) viewController isAnimated: (BOOL) animated
{
	FDNavigationController * navController = [[FDNavigationController alloc] init];
	//set status bar for navigation controller to white
	navController.navigationBar.barStyle = UIBarStyleBlack;
	
	[navController setViewControllers:@[viewController]];
	[navController.navigationBar setIOSIndependentTintDarkGreenFDColor];
	
	[self presentViewController:navController animated:animated completion:nil];
	[navController release];
}

- (void) dismissModalViewControllerOnDifferentOsAnimated: (BOOL) animated
{
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (NSString *) getNavStackPath
{
    NSMutableString * fullPath = nil;
    
    NSArray * viewControllers = [self.navigationController viewControllers];
    if (viewControllers)
    {
        fullPath = [[NSMutableString alloc] initWithString: @""];
        
        for (UIViewController * viewController in viewControllers)
        {
            [fullPath appendFormat: @"/%@", [viewController title]];
        }
    }
    return [fullPath  autorelease];
}

// to get active tab title
- (NSString *) getTabName
{
    UITabBarController * tabBarController = [FreshDirectAppDelegate sharedDelegate].rootController;
    if ([tabBarController isKindOfClass: [UITabBarController class]])
    {
        NSUInteger selectedIdx = [tabBarController selectedIndex];
        if (selectedIdx >= 4)
        {
            return @"More";
        }
        UIViewController * currentVC = [tabBarController.viewControllers objectAtIndex: selectedIdx];        
        NSString* str = [currentVC.tabBarItem.title lowercaseString];
        return str;
    }
    return nil;
}

@end
