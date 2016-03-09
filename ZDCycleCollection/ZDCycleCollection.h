//
//  ZDCycleCollection.h
//  iDrive
//
//  Created by william on 16/3/6.
//  Copyright © 2016年 TRS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDCycleCell;
@interface ZDCycleCollection : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
//当前页码
@property (nonatomic,assign)NSInteger currentPage;

//对应当前页码的联动操作
@property(nonatomic, copy) void(^currentIndex)(NSInteger index);

//在cell上添加自定义视图
@property (nonatomic, copy) void (^initCellBlock)(ZDCycleCell *cell,NSInteger index);

//选中当前页码
@property(nonatomic, copy) void(^slectedCurrentPage)(NSInteger index);

//数据源,默认为名字为字符串的数组
@property (nonatomic, strong)NSMutableArray *data;

//滚动方向
@property (nonatomic, assign)UICollectionViewScrollDirection scrollDirection;

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame itemsize:(CGSize)itemsize direction:(UICollectionViewScrollDirection )scrollDrection data:(NSArray*)data;

//转到指定页码
- (void)jumpToIndex:(NSInteger )index;



@end
