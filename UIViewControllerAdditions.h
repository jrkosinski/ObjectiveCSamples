//
//  UIViewControllerAdditions.h
//  [Client Name]
//
//  Created by John Kosinski on 11/24/14.
//

#import <Foundation/Foundation.h>

@interface UIViewController (FDAdditions)

- (BOOL) isModal;

// Helper for items managed by UINavigation Controllers
//- (UIBarButtonItem *) barBackButton: (NSString *)title;

//We need run it on different OS types
- (void) presentModalViewController: (UIViewController *) viewController;
- (void) presentModalViewControllerInNavController: (UIViewController *)viewController;
- (void) presentModalViewControllerInNavController: (UIViewController *)viewController isAnimated:(BOOL)animated;
- (void) dismissModalViewControllerOnDifferentOsAnimated: (BOOL) animated DEPRECATED_ATTRIBUTE;

//to get parent view controller name from navigation stack
- (NSString *) getNavStackPath;

// to get active tab title
- (NSString *) getTabName;

@end
