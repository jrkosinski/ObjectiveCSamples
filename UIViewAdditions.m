//
//  UIViewAdditions.m
//  [Client Name]
//
//  Created by John Kosinski on 12/12/15.
//

#import "UIViewAdditions.h"

#import <QuartzCore/QuartzCore.h>
#import "math.h"

#import "FDViewSpacer.h"

NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString: @"."] objectAtIndex: 0] intValue];
    });
    return _deviceSystemMajorVersion;
}

@implementation UIView (MFAdditions)

//static BOOL matchPixels = NO;

#pragma mark -
#pragma mark POSITION FUNCTIONS
#pragma mark -

- (void) removeAllSubviews
{
	NSArray * allSubViews = [self subviews];
	for(id view in allSubViews)
	{
		[view removeFromSuperview];
	}
}


// Function to float all subviews in a parent view and stretch the bounds.
- (void) resizeToFitSubviews
{
	CGFloat maxHeight = 0.0f;
	CGFloat maxWidht = 0.0f;
	
	NSArray * allViews = [self subviews];
	
	for (NSUInteger i = 0; i < [allViews count]; i++)
	{
		UIView * firstView  = [allViews objectAtIndex: i];
		CGRect firstViewRect = [firstView frame];
		
		CGFloat currentWidth = CGRectGetMaxX(firstViewRect);
		CGFloat currentHeight = CGRectGetMaxY(firstViewRect);
		
		if(currentWidth > maxWidht)
			maxWidht = currentWidth;
		
		if(currentHeight > maxHeight)
			maxHeight = currentHeight;	
	}
	
	
	CGFloat x = self.bounds.origin.x;
	CGFloat y = self.bounds.origin.y;
		
	[self setBounds: CGRectMake(x, y, maxWidht, maxHeight)];
	
}

- (void) addView: (UIView *)view belowView: (UIView *)previousView withSpace: (CGFloat)space positionMask: (UIViewAddtionsPositionMask)mask
{
	
	// TOP VIEW
	CGRect previousViewRect = [previousView frame];	
	CGFloat newYposition =  CGRectGetMaxY(previousViewRect) + space;	
	
	CGRect viewRect = CGRectMake(0, newYposition, view.frame.size.width, view.frame.size.height);
	
	if(![[view superview] isEqual:self])
		[self addSubview:view];
	
	[view setFrame:viewRect];
	[view toPixelAbsolutePosition];
	
	// NONE
	if(mask == UIViewAddtionsPositionMaskNone)
	{
		return;
	}	
	// CENTER
	if(mask == UIViewAddtionsPositionMaskCenter)
	{
		CGFloat posX = self.frame.size.width * 0.5;
		CGFloat posY = [view center].y;
		
		[view setCenter:CGPointMake(posX, posY)];
		[view toPixelAbsolutePosition];
	}	
		
}

- (void) addViews: (NSArray *)views withVerticalSpace: (CGFloat) space  startX: (CGFloat) startX  startY: (CGFloat) startY
{
	for (NSUInteger i = 0; i < [views count]; i++)
	{
		id view = [views objectAtIndex: i];
		CGRect viewRect = [view frame];
        viewRect.origin.x = startX;
		viewRect.origin.y = startY;
		
		[view setFrame: viewRect];
		
		startY = CGRectGetMaxY(viewRect);
		startY += space;
		
		if([view superview] != self)
			[self addSubview: view];
	}    
}

- (void) distributeViewsVertically: (NSArray *) subViews
					 withAnimation: (NSTimeInterval) animationTime
							startY: (CGFloat) startY
						withOffset: (CGFloat) offset
					  updateHeigth: (BOOL) updateHeigth
					 excludeHidden: (BOOL) excludeHidden
{
	NSArray * subviews = (subViews) ? subViews : [self subviews];
	CGFloat initY = startY;
		
	for (NSUInteger i=0; i < [subviews count]; i++) 
	{
		UIView * view = [subviews objectAtIndex:i];
		
		if(view.hidden && excludeHidden)
			continue;
		
		CGRect viewRect = CGRectMake(view.frame.origin.x, initY, view.frame.size.width, view.frame.size.height);
		if(animationTime > 0)
		{
			[UIView beginAnimations: @"repositionAnimation"  context: nil];
			[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
			[UIView setAnimationDuration: animationTime];
			[UIView setAnimationDelay: 0];
			// -----------------------------------------------------------------------------	
			[view setFrame: viewRect];
			// -----------------------------------------------------------------------------
			[UIView commitAnimations];			
			
		}
		else
		{
			[view setFrame: viewRect];
		}
		
		// setting up new initY frame
		initY =  CGRectGetMaxY([view frame]) + offset;		
	}
	
	if(!updateHeigth)
		return;
	
	CGRect selfFrame = [self frame];
	selfFrame.size.height = initY - offset;
	[self setFrame:selfFrame];
	
}

- (void) distributeViewsVertically: (NSTimeInterval) animationTime  withOffset: (CGFloat) offset  excludeHidden: (BOOL) excludeHidden
{
	NSArray * subviews = [self subviews];
	CGFloat initY = offset;
	
	for (NSUInteger i = 0; i < [subviews count]; i++)
	{
		UIView * view = [subviews objectAtIndex: i];
		
		if(view.hidden && excludeHidden)
			continue;
		
		CGRect viewRect = CGRectMake(view.frame.origin.x, initY, view.frame.size.width, view.frame.size.height);
		if(animationTime > 0)
		{
			[UIView beginAnimations: @"repositionAnimation"  context: nil];
			[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
			[UIView setAnimationDuration: animationTime];
			[UIView setAnimationDelay: 0];
			// -----------------------------------------------------------------------------	
			[view setFrame: viewRect];
			// -----------------------------------------------------------------------------
			[UIView commitAnimations];			
			
		}
		else
		{
			[view setFrame: viewRect];
		}

		// setting up new initY frame
		initY =  CGRectGetMaxY([view frame]) + offset;		
	}
	
	CGRect selfFrame = [self frame];
	selfFrame.size.height = initY - offset;
	[self setFrame: selfFrame];
}

- (void) addSubview: (UIView *) view  upOfSubview: (UIView*)subview
{
	[self pushSubview: view  inDirectionOf: subview  withOffset: 0];
}

- (void) addSubview: (UIView *) view  downOfSubview: (UIView *) subview
{
	[self pushSubview: view  inDirectionOf: subview  withOffset: -1];
}

- (void) pushSubview: (UIView *) view  inDirectionOf: (UIView *) subview  withOffset: (int) offset
{
	[self addSubview: view];
	
	NSUInteger exchangeIndex = 0;
	NSArray * allViews = [self subviews];
	for(NSUInteger i = 0; i < [allViews count]; i++)
	{
		if([[allViews objectAtIndex: i] isEqual: subview])
			exchangeIndex = i;
		
	}
	[self insertSubview: view  atIndex: exchangeIndex + offset];
	
}

- (void) addViews: (NSArray *) views  withVerticalSpace: (CGFloat) space
{
    [self addViews: views  withVerticalSpace: space  startX: 0  startY: 0];
}

// Centering views in horizontally with offset
- (void) centerHorizontally: (NSArray *) views  withOffset: (CGFloat) offset
{
	CGRect selfRect = [self frame];
	
	CGFloat concatenatedWidth = 0;
	
	for (NSUInteger i = 0; i < [views count]; i++) 
	{
		id view = [views objectAtIndex: i];
		CGFloat width = [view frame].size.width;
		
		concatenatedWidth = concatenatedWidth + width + offset;		
	}	
	
	CGPoint center = CGPointMake(selfRect.size.width * .5, selfRect.size.height * .5);	
	CGFloat startX = center.x - concatenatedWidth * .5 + offset * .5;
	CGFloat concatenatedPosition = startX;
	
	for (NSUInteger i = 0; i < [views count]; i++) 
	{		
		id view = [views objectAtIndex:i];
		CGFloat widthOffset = [view frame].size.width;
		CGFloat position =  concatenatedPosition;
		
		
		CGRect rect = [view frame];
		rect.origin.x = position;
		
			
		[view setFrame:rect];
		[view toPixelAbsolutePosition];
		
		concatenatedPosition = concatenatedPosition + widthOffset + offset;		
	}		
}

- (void) addSubviewAndCenter: (UIView *) view
{
	if(![[view superview] isEqual: self])
    {
		[self addSubview: view];
	}
    
	CGPoint centerPoint =  CGPointMake(self.size.width * .5, self.size.height * .5);
	[view setCenter: centerPoint];
	// to remove blur effect, the frame x,y should be set to whole numeric values;
	[view toPixelAbsolutePosition];
	
}

- (void) updateHeight
{
    [self updateHeightHidingView:nil];
}

-(void) updateHeightHidingView:(UIView*)view {
    CGFloat maxHeight = 0.0f;
    
    NSArray * allViews = [self subviews];
    
    for (NSUInteger i = 0; i < [allViews count]; i++)
    {
        UIView * firstView  = [allViews objectAtIndex: i];
        
        if (firstView == view) {
            [firstView setHidden:YES];
            continue;
        }
        
        [firstView setHidden:NO];
        
        CGRect firstViewRect = [firstView frame];
        
        CGFloat currentHeight = CGRectGetMaxY(firstViewRect);
        
        if(currentHeight > maxHeight)
            maxHeight = currentHeight;
    }
    
    CGRect selfFrame = [self frame];
    selfFrame.size.height = maxHeight;
    [self setFrame: selfFrame];
}

- (void) positionViews: (BOOL) animated
{
	NSArray * subviews = [self subviews];
	CGFloat initY = 0;
	
	for (NSUInteger i=0; i < [subviews count]; i++) 
	{
		UIView * section = [subviews objectAtIndex:i];		
		CGRect viewRect = CGRectMake(0, initY, section.frame.size.width, section.frame.size.height);
		if(animated)
		{	
			[UIView beginAnimations: @"editAnimation"  context: nil];
			[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
			[UIView setAnimationDuration: 0.5];
			[UIView setAnimationDelay: 0];
			// -----------------------------------------------------------------------------	
			[section setFrame: viewRect];
			// -----------------------------------------------------------------------------
			[UIView commitAnimations];				
			
		}
		else
		{
			[section setFrame:viewRect];
		}
		// ANIMATION
		// setting up new initY frame
		initY =  CGRectGetMaxY([section frame]);		
	}
}

- (void) toPixelAbsolutePosition
{
	CGRect selfFrame = [self frame];
	selfFrame.origin.x = round(selfFrame.origin.x);
	selfFrame.origin.y = round(selfFrame.origin.y);
	
	[self setFrame:selfFrame];
}

- (CGRect) roundFrame: (CGRect)rect
{
	rect.origin.x = round(rect.origin.x);
	rect.origin.y = round(rect.origin.y);
	
	return rect;
}

#pragma mark -
#pragma mark POSITION PROPERTIES
#pragma mark -

// -----------------------------------------------------------------------------
// USEFULL PROPERTIES
// -----------------------------------------------------------------------------
- (CGPoint) position 
{
	return [self frame].origin;
}

- (void) setPosition: (CGPoint) position
{
	CGRect rect = [self frame];
	rect.origin = position;
	[self setFrame:rect];
}

- (CGFloat) x 
{
	return [self frame].origin.x;
}

- (void) setX: (CGFloat) x
{
	CGRect rect = [self frame];
	rect.origin.x = x;
	[self setFrame: rect];
}

- (void) shiftX: (CGFloat) x
{
	CGRect rect = [self frame];
	rect.origin.x += x;
	[self setFrame: rect];
}


- (CGFloat) y 
{
	return [self frame].origin.y;
}

- (void) setY: (CGFloat)y 
{
	CGRect rect = [self frame];
	rect.origin.y = y;
	[self setFrame:rect];
}

- (void) shiftY: (CGFloat)y 
{
	CGRect rect = [self frame];
	rect.origin.y += y;
	[self setFrame:rect];
}


- (CGSize) size
{
	return [self frame].size;
}

- (void) setSize: (CGSize) size
{
	CGRect rect = [self frame];
	rect.size = size;
	[self setFrame: rect];
}

- (CGFloat) width 
{
	return [self frame].size.width;
}

- (void) setWidth: (CGFloat) width
{
	CGRect rect = [self frame];
	rect.size.width = width;
	[self setFrame: rect];
}

- (CGFloat) height
{
	return [self frame].size.height;
}

- (void) setHeight: (CGFloat) height
{
	CGRect rect = [self frame];
	rect.size.height = height;
	[self setFrame: rect];
}

// -----------------------------------------------------------------------------
// QUICK ANIMATIONS
// -----------------------------------------------------------------------------

- (void) quickMoveFromXOffset: (int) fromXoffset  toXOffset: (int) toXoffset  fromAlpha: (int) startAlpha  toAlpha: (int)finalAlpha
{
	// if the element is currently in the final position or final transformation, do not process
	if(self.alpha == finalAlpha && (self.x == toXoffset || self.transform.tx == toXoffset))
		return;
	
	
	[self setAlpha: startAlpha];
	[self setTransform: CGAffineTransformMakeTranslation(fromXoffset,0)];
	// -----------------------------------------------------------------------------
	[UIView beginAnimations: @"anim"  context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration: 0.3];
	[UIView setAnimationDelay: 0];
	// -----------------------------------------------------------------------------	
	[self setTransform: CGAffineTransformMakeTranslation(toXoffset,0)];
	[self setAlpha: finalAlpha];
	// -----------------------------------------------------------------------------
	[UIView commitAnimations];	
}

- (void) setFrame: (CGRect) aFrame  animated: (NSTimeInterval) seconds
{
	[UIView beginAnimations: @"anim"  context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration: seconds];
	[UIView setAnimationDelay: 0];
	// -----------------------------------------------------------------------------	
	[self setFrame: aFrame];
	// -----------------------------------------------------------------------------
	[UIView commitAnimations];	
	
}
// -----------------------------------------------------------------------------
// MATH
// -----------------------------------------------------------------------------

- (CGFloat) degreesToRadians: (int) degrees
{
	return (degrees * M_PI / 180);
}
- (CGFloat) radiansToDegrees: (int) radians
{
	return (radians / M_PI / 180);
}

- (void) rotateViewOnDegrees: (CGFloat) degrees
{
    // Setup the animation
    [UIView beginAnimations: nil  context: NULL];
    [UIView setAnimationDuration: 0.25];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeRotation([self degreesToRadians: degrees]);
    self.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

@end
