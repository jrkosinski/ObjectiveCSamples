//
//  UINavigationBar+BarTintColor.m
//  [Client Name]
//
//  Created by John Kosinski on 07/08/14.
//

#import "UINavigationBar+BarTintColor.h"

@implementation UINavigationBar (BarTintColor)

- (void) setIOSIndependentTintDarkGreenFDColor
{
     self.translucent =  NO;
    [self setBarTintColor: [UIColor colorWithFDGreen]];
    [self setTintColor: [UIColor whiteColor]];//change color of buttons
    
    [self setBackgroundImage:[[UIImage new] autorelease]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    
    [self setShadowImage:[[UIImage new] autorelease]];
}

- (void) setIOSIndependentBarTint: (UIColor*)barTint buttonColor: (UIColor*)tintColor
{
    self.translucent =  NO;
    [self setBarTintColor: barTint];
    [self setTintColor: tintColor];//change color of buttons
    
}

@end
