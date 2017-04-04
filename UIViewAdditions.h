//
//  UIViewAdditions.h
//  [Client Name]
//
//  Created by John Kosinski on 12/12/15.
//

#define FDVAlignViews(targetView, toView) \
    targetView.frame = CGRectMake(targetView.frame.origin.x, toView.frame.origin.y, \
                                targetView.frame.size.width, targetView.frame.size.height)

#define FDHAlignViews(targetView, toView) \
    targetView.frame = CGRectMake(toView.frame.origin.x, targetView.frame.origin.y, \
                                targetView.frame.size.width, targetView.frame.size.height)


NSUInteger DeviceSystemMajorVersion();
#define IOS_LOWER_7 (DeviceSystemMajorVersion() < 7)
#define IOS_EQUAL_OR_HIGHER_8 (DeviceSystemMajorVersion() >= 8)

@interface UIView (MFAdditions)

typedef enum  
{ 
	UIViewAddtionsPositionMaskNone = 0,
	UIViewAddtionsPositionMaskCenter,
	UIViewAddtionsPositionMaskLeft,
	UIViewAddtionsPositionMaskRight
}UIViewAddtionsPositionMask;

// -----------------------------------------------------------------------------
// ADDED PROPERTIES
// -----------------------------------------------------------------------------

// Position of the top-left corner in superview's coordinates

@property CGPoint position;
@property CGFloat x;
@property CGFloat y;

// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

- (CGPoint) position;
- (void) setPosition: (CGPoint) position;
- (CGFloat) x;
- (void) setX: (CGFloat) x;
- (void) shiftX: (CGFloat) x;
- (CGFloat) y;
- (void) setY: (CGFloat) y;
- (void) shiftY: (CGFloat) y;
- (CGSize)size;
- (void) setSize: (CGSize) size;
- (CGFloat) width;
- (void) setWidth: (CGFloat) width;
- (CGFloat) height;
- (void) setHeight: (CGFloat) height;

// -----------------------------------------------------------------------------
// ADDED FUNCTIONS
// -----------------------------------------------------------------------------

// REMOVE or RESIZE
- (void) removeAllSubviews;
- (void) resizeToFitSubviews;
- (void) updateHeight;
- (void) updateHeightHidingView:(UIView*)view;

// ADDING VIEWS
- (void) addSubviewAndCenter: (UIView *)view;
- (void) addView: (UIView *) view  belowView: (UIView *) previousView  withSpace: (CGFloat)space positionMask: (UIViewAddtionsPositionMask)mask;
- (void) addViews: (NSArray *) views  withVerticalSpace: (CGFloat) space;
- (void) addViews: (NSArray *) views  withVerticalSpace: (CGFloat) space  startX: (CGFloat) startX  startY: (CGFloat) startY;

// REPOSITIONING
- (void) centerHorizontally: (NSArray *) views  withOffset: (CGFloat) offset;
- (void) distributeViewsVertically: (NSTimeInterval) animationTime  withOffset: (CGFloat) offset  excludeHidden: (BOOL)excludeHidden;
- (void) distributeViewsVertically: (NSArray *) subViews
					 withAnimation: (NSTimeInterval) animationTime
							startY: (CGFloat) startY
						withOffset: (CGFloat) offset
					  updateHeigth: (BOOL) updateHeigth
					 excludeHidden: (BOOL) excludeHidden;

// PUSHING OTHER VIEWS IN RELATION TO SUBVIES
- (void) addSubview: (UIView *) view  upOfSubview: (UIView *) subview;
- (void) addSubview: (UIView *) view  downOfSubview: (UIView *) subview;
- (void) pushSubview: (UIView *) view  inDirectionOf: (UIView *) subview  withOffset: (int)offset; // 0 is 1 item up

// QUICK ANIAMTIONS
- (void) setFrame: (CGRect) aFrame  animated: (NSTimeInterval) seconds;
- (void) quickMoveFromXOffset: (int) fromXoffset  toXOffset: (int) toXoffset  fromAlpha: (int) startAlpha  toAlpha: (int)finalAlpha;

// UTILITIES
- (void) toPixelAbsolutePosition;
- (CGRect) roundFrame: (CGRect) rect;

- (CGFloat) degreesToRadians: (int) degrees;
- (CGFloat) radiansToDegrees: (int) radians;
- (void) rotateViewOnDegrees: (CGFloat) degrees;


- (void) positionViews: (BOOL)animated;

@end
