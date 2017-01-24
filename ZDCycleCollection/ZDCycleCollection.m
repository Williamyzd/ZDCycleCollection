//
//  ZDCycleCollection.m

//
//  Created by william on 16/3/6.
//  Copyright © 2016年 william. All rights reserved.
//

#import "ZDCycleCollection.h"
#import "ZDLayout.h"
#import "ZDCycleCell.h"

static NSString *reusedId = @"SycleCell";
@interface ZDCycleCollection ()
/*!
 *  cell的宽度
 */
//@property (nonatomic, assign)CGFloat itemWidth;
/*!
 *  cell的大小
 */
@property (nonatomic, assign) CGSize itemsize;
/*!
 *  是否需要循环,默认是需要
 */
@property (nonatomic, assign)BOOL  isNeedCycle;

@end
@implementation ZDCycleCollection

#pragma mark - /*************************初始化***************************/
- (instancetype)initWithFrame:(CGRect)frame itemsize:(CGSize)itemsize direction:(UICollectionViewScrollDirection )scrollDrection data:(NSArray*)data isNeedCycle:(BOOL)isNeedCycle{
    //绑定layout
    CGSize ajustSize;
    ZDLayout *layout = [[ZDLayout alloc] init];
    if (scrollDrection ==UICollectionViewScrollDirectionHorizontal) {
        ajustSize = CGSizeMake(frame.size.width, itemsize.height);
        
    }else{
        ajustSize = CGSizeMake(itemsize.width, frame.size.height);
    }
    
    layout.itemSize = ajustSize;
    layout.scrollDirection = scrollDrection;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.itemsize = ajustSize;
    self.bounces = NO;
    self.scrollDirection= scrollDrection;
    
    //设置属性
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0] ;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.isNeedCycle = isNeedCycle;
    //绑定代理,顺序不能错,优先级
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[ZDCycleCell class] forCellWithReuseIdentifier:reusedId];
    
    //处理数据
    _data=[NSMutableArray arrayWithArray:data];
    //_totalCount = _data.count+2;
    
    // 偏移到1,仍然是第一张图片
    if (self.isNeedCycle) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
        // [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self jumpToIndex:0];
        NSLog(@"轮播初始化====%f",self.contentOffset.x);
    }
    
    
    
    return self;
    
}
- (void)setData:(NSMutableArray *)data{
    _data = [NSMutableArray arrayWithArray:data];
    
}


#pragma mark - /*************************数据源方法***************************/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.isNeedCycle) {
        return self.data.count;
    }else{
        return self.data.count+2;
    }
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    
    //消除缓存的影响
    for (UIView *subView in cell.subviews) {
        [subView removeFromSuperview];
    }
    
    //需要循环
    if (self.isNeedCycle) {
        //1.indexPath 不为首尾时
        
        if (indexPath.item!=0 && indexPath.item!=self.data.count+1) {
            //self.currentPage = indexPath.item-1;
            // NSLog(@"当前实际页码:%zd,抽象页码:%zd",self.currentPage,indexPath.item);
            //            if (self.currentIndex) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                     self.currentIndex(indexPath.item-1);
            //                });
            //
            //            }
            //加载cell内容视图
            //自定义内容
            if (self.initCellBlock) {
                __weak typeof(cell) weakCell = cell;
                [cell setInitCellBlock:^{
                    self.initCellBlock(weakCell,indexPath.item-1);
                }];
            }else{
                //默认图片
                NSString *img =self.data[indexPath.item-1];
                [cell initContentWithImageName:img ];
            }
            
            //2.indexPath 为首时
            
        }
        else if (indexPath.item ==0){
            //自定义内容
            // self.currentPage = self.data.count-1;
            //  NSLog(@"当前实际页码:%zd,抽象页码:%zd",self.currentPage,indexPath.item);
            if (self.initCellBlock) {
                __weak typeof(cell) weakCell = cell;
                [cell setInitCellBlock:^{
                    self.initCellBlock(weakCell,self.data.count-1);
                }];
            }else{
                //默认图片
                NSString *img =self.data[self.data.count-1];
                [cell initContentWithImageName:img ];
            }
            
            //3.indexPath 为尾时
            
        }else if (indexPath.item ==self.data.count+1){
            // self.currentPage = 0;
            //NSLog(@"当前实际页码:%zd,抽象页码:%zd",self.currentPage,indexPath.item);
            //自定义内容
            if (self.initCellBlock) {
                __weak typeof(cell) weakCell = cell;
                [cell setInitCellBlock:^{
                    self.initCellBlock(weakCell,0);
                }];
            }else{
                //默认图片
                NSString *img =self.data[0];
                [cell initContentWithImageName:img ];
            }
        }
        
        //不需要循环
    }else{
        //对当前的页面所做的联动
        //self.currentPage=indexPath.item;
        //        if (self.currentIndex) {
        //            self.currentIndex(indexPath.item);
        //        }
        //自定义当前页面
        if (self.initCellBlock) {
            __weak typeof(cell) weakCell = cell;
            [cell setInitCellBlock:^{
                self.initCellBlock(weakCell,indexPath.item);
            }];
        }else{
            //默认图片
            NSString *img =self.data[indexPath.item];
            [cell initContentWithImageName:img ];
        }
        
        
    }
    //    if (self.currentIndex) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.currentIndex(self.currentPage);
    //        });
    //    }
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.slectedCurrentPage) {
        //需要循环
        if (self.isNeedCycle) {
            if (indexPath.item!=0 && indexPath.item!=self.data.count+1) {
                self.slectedCurrentPage(indexPath.item-1);
            }else if (indexPath.item==0){
                self.slectedCurrentPage(self.data.count-1);
            }else if (indexPath.item ==self.data.count+1){
                self.slectedCurrentPage(0);
            }
            //不需要循环
        }else{
            self.slectedCurrentPage(indexPath.item);
        }
    }
    
}

#pragma mark - /*************************scrollview代理方法***************************/
//将要停止滚动
//自动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
    NSLog(@"%zd",self.contentOffset.x);
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"当前实际页码:%zd---偏移量:%f",self.currentPage,scrollView.contentOffset.x);
    
    //需要循环时才考虑
    NSInteger index;
    if (self.scrollDirection ==UICollectionViewScrollDirectionHorizontal) {
        index= (NSInteger)(scrollView.contentOffset.x/self.itemsize.width) ;
    }else{
        index= (NSInteger)(scrollView.contentOffset.y/self.itemsize.height) ;
    }
    
    //水平滚动
    if (self.isNeedCycle) {
        
        index--;
        if(index==-1)
        {
            index = self.data.count-1;
            [self jumpToIndex:self.data.count-1];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentIndex(self.data.count-1);
            });
        }
        else if(index == self.data.count)
        {
            index = 0;
            [self jumpToIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentIndex(0);
            });
            
        }
        else
        {
            [self jumpToIndex:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentIndex(index);
            });
        }
        
        self.currentPage=index;
    }else{
        self.currentPage=index;
        if (self.currentIndex) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentIndex(index);
            });
        }
        
        NSLog(@"=========:%zd---偏移量:%f",index,scrollView.contentOffset.x);
        
    }
    
}

//跳转方法
-(void)jumpToIndex:(NSInteger)index{
    NSIndexPath *indexpath;
    //需要循环
    if (self.isNeedCycle) {
        indexpath = [NSIndexPath indexPathForItem:(index +1) inSection:0];
        //不需要循环
    }else{
        indexpath = [NSIndexPath indexPathForItem:index  inSection:0];
        
        
    }
    
    [self scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
}

@end
