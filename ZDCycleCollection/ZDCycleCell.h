//
//  ZDCycleCell.h

//
//  Created by william on 16/3/7.
//  Copyright © 2016年 william. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCycleCell : UICollectionViewCell
@property (nonatomic, copy) void (^initCellBlock)();

- (void)initContentWithImageName:(NSString*)imgName ;
@end
