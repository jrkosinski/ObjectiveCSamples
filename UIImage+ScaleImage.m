//
//  UIImage+ScaleImage.m
//  [Client Name]
//
//  Created by John Kosinski on 22/02/14.
//

#import "UIImage+ScaleImage.h"

@implementation UIImage (ScaleImage)

- (UIImage *) scaleToSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *) resizableImageWithSize: (CGSize) size
{
    if ([self respondsToSelector: @selector(resizableImageWithCapInsets:)])
    {
        return [self resizableImageWithCapInsets: UIEdgeInsetsMake(size.height, size.width, size.height, size.width)];
    }
    else
    {
        return [self stretchableImageWithLeftCapWidth: size.width  topCapHeight: size.height];
    }
}

@end
