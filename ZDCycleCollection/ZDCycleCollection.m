//
//  ZDCycleCollection.m
//  iDrive
//
//  Created by william on 16/3/6.
//  Copyright © 2016年 TRS. All rights reserved.
//

#import "ZDCycleCollection.h"
#import "ZDLayout.h"
#import "ZDCycleCell.h"

static NSString *reusedId = @"SycleCell";
@interface ZDCycleCollection ()
@property (nonatomic, assign)CGFloat itemWidth;
@property (nonatomic, assign) CGSize itemsize;

@end
@implementation ZDCycleCollection

#pragma mark - /*************************初始化***************************/
- (instancetype)initWithFrame:(CGRect)frame itemsize:(CGSize)itemsize direction:(UICollectionViewScrollDirection )scrollDrection data:(NSArray*)data{
    //绑定layout
    ZDLayout *layout = [[ZDLayout alloc] init];
    layout.itemSize = itemsize;
    layout.scrollDirection = scrollDrection;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.itemWidth = itemsize.width;
    self.itemsize = itemsize;
    self.bounces = NO;
    self.scrollDirection= scrollDrection;
    
    //设置属性
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0] ;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    //绑定代理,顺序不能错,优先级
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[ZDCycleCell class] forCellWithReuseIdentifier:reusedId];
    
    //处理数据
    _data=[NSMutableArray arrayWithArray:data];
    //_totalCount = _data.count+2;
    
    // 偏移到1,仍然是第一张图片
    NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
    [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
      NSLog(@"%zd",self.contentOffset.x);
    
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
    return self.data.count+2;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ZDCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedId forIndexPath:indexPath];
    
    //消除缓存的影响
    for (UIView *subView in cell.subviews) {
        [subView removeFromSuperview];
    }
    
//1.indexPath 不为首尾时
    
        if (indexPath.item!=0 && indexPath.item!=self.data.count+1) {
            self.currentPage = indexPath.item-1;
            NSLog(@"当前实际页码:%zd,抽象页码:%zd",self.currentPage,indexPath.item);
            if (self.currentIndex) {
                self.currentIndex(indexPath.item-1);
            }
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
            
        }else if (indexPath.item ==0){
            //自定义内容
            self.currentPage = self.data.count-1;
            NSLog(@"当前实际页码:%zd,抽象页码:%zd",self.currentPage,indexPath.item);
            if (self.initCellBlock) {
                __weak typeof(cell) weakCell = cell;
                [cell setInitCellBlock:^{
                    self.initCellBlock(weakCell,self.data.count-1);
                }];
            }else{
            //默认图片
                NSString *img =self.data[indexPath.row-1];
               [cell initContentWithImageName:img ];
            }
            
//3.indexPath 为尾时
            
        }else if (indexPath.item ==self.data.count+1){
            self.currentPage = 0;
            NSLog(@"当前实际页码:%zd,抽象页码:%zd",self.currentPage,indexPath.item);
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
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.slectedCurrentPage) {
        if (indexPath.item!=0 && indexPath.item!=self.data.count+1) {
           self.slectedCurrentPage(indexPath.item-1);
        }else if (indexPath.item==0){
             self.slectedCurrentPage(self.data.count-1);
        }
       }else if (indexPath.item ==self.data.count+1){
        self.slectedCurrentPage(0);
        
    }
    
}
#pragma mark - /*************************scrollview代理方法***************************/
//将要停止滚动
//自动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
     NSLog(@"%zd",self.contentOffset.x);
}

//手动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //水平滚动
    if (self.scrollDirection ==UICollectionViewScrollDirectionHorizontal) {
        if (scrollView.contentOffset.x>=scrollView.contentSize.width-self.bounds.size.width ) {
            
            NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }
        else if (scrollView.contentOffset.x<self.itemWidth) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:self.data.count inSection:0];
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }

    }else{
        //垂直滚动
        if (scrollView.contentOffset.y>=scrollView.contentSize.height-self.bounds.size.height) {
            
            NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }
        else if (scrollView.contentOffset.y<self.itemsize.height) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:self.data.count inSection:0];
            [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
        }

    }
    
    
}

//跳转方法
-(void)jumpToIndex:(NSInteger)index{
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:(index +1) inSection:0];
    [self scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone  animated:NO];
}

@end