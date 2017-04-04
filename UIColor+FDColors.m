//
//  UIColor+FDColors.m
//  [Client Name]
//
//  Created by John Kosinski on 10/6/15.
//

#import "UIColor+FDColors.h"

@implementation UIColor (UIColor_FDColors)

- (id) initWithHex: (long) hexColor
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [[UIColor alloc] initWithRed: red  green: green  blue: blue  alpha: 1.0];  
}

+ (UIColor *) colorWithHex: (long) hexColor
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];  
}

+ (UIColor *) colorWithHex: (long) hexColor  alpha: (float) opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];  
}

/*
 UIColor * const FDColorBrown = [UIColor colorWithHex:0x999966];
 UIColor * const FDColorPurple = [UIColor colorWithHex:0x996699];
 UIColor * const FDColorBlue = [UIColor colorWithHex:0x6699cc];
 */

+ (UIColor *) colorWithFDGreen
{
    return [UIColor colorWithHex: 0x68AA6E alpha: 1.0];
}


+ (UIColor *) colorWithFDNewGreen {
    return [UIColor colorWithRed:(104.0/255.0) green:(170.0/255.0) blue:(110.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewGreenInactive {
    return [UIColor colorWithRed:(104.0/255.0) green:(170.0/255.0) blue:(110.0/255.0) alpha:0.5];
}

+ (UIColor *) colorWithFDNewLightGreen {
    return [UIColor colorWithRed:(231.0/255.0) green:(244.0/255.0) blue:(230.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewLigthGreenInactive {
    return [UIColor colorWithHex:0xf3f9f2];
}

+ (UIColor *) colorWithFDNewBlockText {
    return [UIColor colorWithRed:(82.0/255.0) green:(80.0/255.0) blue:(75.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewTextGray {
    return [UIColor colorWithRed:(136.0/255.0) green:(131.0/255.0) blue:(129.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewTextDarkGray {
    return [UIColor colorWithRed:(101.0/255.0) green:(99.0/255.0) blue:(93.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewSectionHeader {
    return [UIColor colorWithRed:(242.0/255.0) green:(238.0/255.0) blue:(234.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewSectionHeaderText {
    return [UIColor colorWithRed:(136.0/255.0) green:(131.0/255.0) blue:(129.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDNewOptionGray {
    return [UIColor colorWithRed:(155.0/255.0) green:(155.0/255.0) blue:(155.0/255.0) alpha:1.0];
}

+ (UIColor *) colorWithFDOrange
{
    return [UIColor colorWithHex: 0xff9933];
}

+ (UIColor *) colorWithFDBlockText
{
    return [UIColor colorWithHex: 0x52504B];
}

+ (UIColor *) colorWithFDBlockTextLight
{
    return [UIColor colorWithHex: 0xC5C2C1];
}

+ (UIColor *) colorWithFDBlockTextDark
{
    return [UIColor colorWithHex: 0x4A4A4A];
}

+ (UIColor *) colorWithFDRed
{
    return [UIColor colorWithHex: 0xFFB08C];
}

+ (UIColor *) colorWithFDLightRed
{
    return [UIColor colorWithHex: 0xf16043];
}

+ (UIColor *) colorWithFDPink
{
    return [UIColor colorWithHex: 0xc56262];
}

+ (UIColor *) colorWithFDGray
{
    return [UIColor colorWithHex: 0xa9adb3];
}

+ (UIColor *) colorWithFDLightGray
{
    return [UIColor colorWithHex: 0xeeeaeb];
}

+ (UIColor *) colorWithFDBlue
{
    return [UIColor colorWithHex: 0x2199ce];
}

+ (UIColor *) colorWithFDPurple
{
    return [UIColor colorWithHex: 0x8957C5];
}

+ (UIColor *) colorWithFDStroke
{
    return [UIColor colorWithHex: 0xd6d6d6];
}

+ (UIColor *) colorWithFDPageBG
{
    return [UIColor colorWithHex: 0xf3eee6];
}

+ (UIColor *) colorWithFDPressedOverlay
{
    return [UIColor colorWithHex:0xfdf7e0];
}

@end
