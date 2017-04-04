//
//  UIColor+FDColors.h
//  [Client Name]
//
//  Created by John Kosinski on 10/6/15.
//

#import <Foundation/Foundation.h>

@interface UIColor (UIColor_FDColors)

- (id) initWithHex: (long) hexColor;

+ (UIColor *) colorWithHex: (long) hexColor;
+ (UIColor *) colorWithHex: (long) hexColor  alpha: (float) opacity;
+ (UIColor *) colorWithFDGreen;
+ (UIColor *) colorWithFDOrange;
+ (UIColor *) colorWithFDRed;
+ (UIColor *) colorWithFDLightRed;
+ (UIColor *) colorWithFDPink;
+ (UIColor *) colorWithFDGray;
+ (UIColor *) colorWithFDLightGray;
+ (UIColor *) colorWithFDBlue;
+ (UIColor *) colorWithFDPurple;
+ (UIColor *) colorWithFDStroke;
+ (UIColor *) colorWithFDPageBG;
+ (UIColor *) colorWithFDPressedOverlay;
+ (UIColor *) colorWithFDBlockText;
+ (UIColor *) colorWithFDBlockTextLight;
+ (UIColor *) colorWithFDBlockTextDark;

+ (UIColor *) colorWithFDNewGreen;
+ (UIColor *) colorWithFDNewGreenInactive;
+ (UIColor *) colorWithFDNewLightGreen;
+ (UIColor *) colorWithFDNewLigthGreenInactive;
+ (UIColor *) colorWithFDNewBlockText;
+ (UIColor *) colorWithFDNewTextGray;
+ (UIColor *) colorWithFDNewTextDarkGray;
+ (UIColor *) colorWithFDNewSectionHeader;
+ (UIColor *) colorWithFDNewSectionHeaderText;
+ (UIColor *) colorWithFDNewOptionGray;

@end
