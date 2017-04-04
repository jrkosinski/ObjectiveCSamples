//
//  UITabBar+BarTintColor.m
//  [Client Name]
//
//  Created by John Kosinski on 07/08/14.
//

#import "UITabBar+BarTintColor.h"

@implementation UITabBar (BarTintColor)

- (void) setIOSIndependentTintColor: (UIColor *) color
{
    [self setBarTintColor:color];
}

@end
