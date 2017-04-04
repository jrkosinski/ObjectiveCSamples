//
//  UIImage+CustomCreation.h
//  [Client Name]
//
//  Created by John Kosinski on 10/11/14.
//

#import <UIKit/UIKit.h>

@interface UIImage (CustomCreation)

+ (UIImage *) imageFromColor: (UIColor *) color;
+ (UIImage *) roundedCorneredImage: (UIImage*) orig count:(NSUInteger) count;
+ (UIImage *) textInCircle: (NSString *) text;
+ (UIImage *) circle: (UIColor *) color radius: (NSUInteger) radius  innerRadius: (NSUInteger) innderRadius;

@end
