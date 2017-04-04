//
//  UIImage+ScaleImage.h
//  [Client Name]
//
//  Created by John Kosinski on 22/02/14.
//

@interface UIImage (ScaleImage)

- (UIImage *) scaleToSize: (CGSize) size;
- (UIImage *) resizableImageWithSize: (CGSize) size;

@end
