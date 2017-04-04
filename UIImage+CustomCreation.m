//
//  UIImage+CustomCreation.m
//  [Client Name]
//
//  Created by John Kosinski on 10/11/14.
//

#import "UIImage+CustomCreation.h"

@implementation UIImage (CustomCreation)

+ (UIImage *) imageFromColor: (UIColor *) color
{
    CGRect imageRect = CGRectMake( 0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, imageRect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *) roundedCorneredImage: (UIImage*) orig count:(NSUInteger) count
{
    NSString * countString = [NSString stringWithFormat: @"%lu", (unsigned long)count];
    UIColor * textColor = [UIColor clearColor];
    UIFont * font = [UIFont fontWithName: @"HelveticaNeue-Bold"  size: 8.0];
    
    //get width of string
    CGFloat offsetForSmallText = 0.0;
    CGFloat offsetForBigText = 0.0;
    CGSize size = [countString sizeWithAttributes: @{NSFontAttributeName: font}];
    if (size.width < 10.0)
    {
        offsetForSmallText = (10.0 - size.width) / 2;
    }
    else if (size.width > 10.0)
    {
        offsetForBigText = size.width - 10.0;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake( orig.size.width + 10.0 + offsetForBigText, orig.size.height + 5.0), NO, 0);
    [[UIColor whiteColor] set];
    
    
    [orig drawInRect:(CGRect){CGPointMake(0.0, 5.0), orig.size}];
    
    [[UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointMake(orig.size.width - 18.0 + 10.0,0.0), CGSizeMake(18.0 + offsetForBigText, 18.0)}
                                cornerRadius: 7.0] fillWithBlendMode: kCGBlendModeClear alpha: 0.0];
    
    [[UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointMake(orig.size.width - 16.0 + 10.0,2.0), CGSizeMake(14.0 + offsetForBigText, 14.0)}
                                cornerRadius: 7.0] fill];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    
    [countString drawAtPoint: CGPointMake(orig.size.width + 10.0 - 14.0 + offsetForSmallText, 4.0)
              withAttributes: @{ NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: textColor}];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *) textInCircle: (NSString *) text
{
    UIColor * textColor = [UIColor colorWithHex: 0x8957C5];
    UIFont * font = [UIFont fontWithName: @"BrandonText-Bold"  size: 10.0];
    
    //get width of string
    CGFloat offsetForBigText = 0.0;
    CGSize size = [text sizeWithAttributes: @{NSFontAttributeName: font}];
    if (size.width > 10.0)
    {
        offsetForBigText = size.width - 10.0;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.0 + offsetForBigText, 20.0), NO, 0);
    [textColor set];
    
    
    [[UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointMake(0.0, 0.0), CGSizeMake(20.0 + offsetForBigText, 20.0)}
                                cornerRadius: 10.0] fill];
    [[UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointMake(2.0, 2.0), CGSizeMake(16.0 + offsetForBigText, 16.0)}
                                    cornerRadius: 8.0] fillWithBlendMode: kCGBlendModeClear alpha: 0.0];
    
    [text drawAtPoint: CGPointMake((20.0 + offsetForBigText - size.width) / 2, (20.0 - size.height) / 2)
              withAttributes: @{ NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: textColor}];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *) circle: (UIColor *) color radius: (NSUInteger) radius  innerRadius: (NSUInteger) innderRadius
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius * 2 + 2.0, radius * 2 + 2.0), NO, 0);
    [color set];
    
    
    [[UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointMake(1.0, 1.0), CGSizeMake(radius * 2, radius * 2)}
                                cornerRadius: radius] stroke];
    
    if (innderRadius > 0)
    {
        [[UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointMake(radius - innderRadius + 1.0, radius - innderRadius + 1.0), CGSizeMake(innderRadius * 2, innderRadius * 2)}
                                    cornerRadius: radius] fill];
    }
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
