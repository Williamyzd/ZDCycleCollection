//
//  ZDCycleCell.h

//
//  Created by william on 16/3/7.
//  Copyright © 2016年 william. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDCycleCell : UICollectionViewCell
/**
 *  自定义cell的内容,需要自己addSubView
 */
@property (nonatomic, copy) void (^initCellBlock)();

/**
 *  默认用法,加载图片
 *
 *  @param imgName 图片的名字
 */

- (void)initContentWithImageName:(NSString*)imgName ;
@end
