//
//  UINavigationBar+BarTintColor.h
//  [Client Name]
//
//  Created by John Kosinski on 07/08/14.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BarTintColor)

- (void) setIOSIndependentTintDarkGreenFDColor;
- (void) setIOSIndependentBarTint: (UIColor*)barTint buttonColor: (UIColor*)tintColor;
@end
