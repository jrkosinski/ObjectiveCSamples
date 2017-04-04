//
//  UITableView+FDCompactStyle.m
//  [Client Name]
//
//  Created by John Kosinski on 11/3/14.
//

#import "UITableView+FDCompactStyle.h"


@implementation UITableView (FDCompactStyle)

- (CustomCellBackgroundViewPosition) getCellBackgroundPositionType: (NSIndexPath *) indexPath
{
    return CustomCellBackgroundViewPositionMiddle;
}

- (BOOL) isLastCellInSection: (NSIndexPath *) indexPath
{
	NSUInteger maxResults = [self numberOfRowsInSection: indexPath.section];
	if(indexPath.row == maxResults - 1)
		return YES;
	else 
		return NO;
	
	return NO;
}

@end
