//
//  ZDCycleCollection.h

//
//  Created by william on 16/3/6.
//  Copyright © 2016年 william. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDCycleCell;
@interface ZDCycleCollection : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
/*!
 *  是否需要循环,默认是需要
 */
@property (nonatomic, assign)BOOL  isNeedCycle;
///当前页码
@property (nonatomic,assign)NSInteger currentPage;

///对应当前页码的联动操作
@property(nonatomic, copy) void(^currentIndex)(NSInteger index);

///在cell上添加自定义视图
@property (nonatomic, copy) void (^initCellBlock)(ZDCycleCell *cell,NSInteger index);

///选中当前页码
@property(nonatomic, copy) void(^slectedCurrentPage)(NSInteger index);

///数据源,默认为名字为字符串的数组
@property (nonatomic, strong)NSMutableArray *data;

///滚动方向
@property (nonatomic, assign)UICollectionViewScrollDirection scrollDirection;

/*!
 *  初始化循环页面
 *
 *  @param frame          容器视图坐标与大小
 *  @param itemsize       单个展示页面大小
 *  @param scrollDrection 滚动的方向
 *  @param data           数据源
 *  @param isNeedCycle    是否需要循环
 *
 *  @return 本类
 */
- (instancetype)initWithFrame:(CGRect)frame itemsize:(CGSize)itemsize direction:(UICollectionViewScrollDirection )scrollDrection data:(NSArray*)data isNeedCycle:(BOOL)isNeedCycle;

///转到指定页码
- (void)jumpToIndex:(NSInteger )index;



@end
