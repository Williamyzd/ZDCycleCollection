//
//  ZDCycleCell.m
//  iDrive
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 TRS. All rights reserved.
//

#import "ZDCycleCell.h"

@implementation ZDCycleCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      //自定义初始化操作
    }
    
    return self;
}
//添加自定义视图或方法
- (void)setInitCellBlock:(void (^)())initCellBlock{
    if (initCellBlock) {
        _initCellBlock = initCellBlock;
        _initCellBlock();
    }
}

//添加图片
- (void)initContentWithImageName:(NSString *)imgName {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.bounds];
    imgV.image = [UIImage imageNamed:imgName];
    self.contentMode = UIViewContentModeCenter;
    [self  addSubview:imgV];
    
}
@end
