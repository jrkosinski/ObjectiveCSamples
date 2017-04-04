//
//  UITableView+FDCompactStyle.h
//  [Client Name]
//
//  Created by John Kosinski on 11/3/14.
//

#import <Foundation/Foundation.h>
#import "FDCustomCellBgView.h"

@interface UITableView (FDCompactStyle)

- (CustomCellBackgroundViewPosition) getCellBackgroundPositionType: (NSIndexPath *) indexPath;
- (BOOL) isLastCellInSection: (NSIndexPath *) indexPath;

@end
