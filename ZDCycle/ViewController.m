//
//  ViewController.m
//  ZDCycle
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 william. All rights reserved.
//

#import "ViewController.h"
#import "ZDCycleCollection.h"
#import "ZDPicDetailView.h"
#import "ZDCycleCell.h"
@interface ViewController ()
@property (nonatomic,weak)ZDCycleCollection *collect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor greenColor];
    //只加载图片的demo
    //[self normalDemo];
    
    // 自定义视图的demo
    //[self conplexDemo];
    [self addwebImage];
    }
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.collect jumpToIndex:0];
}
//复杂图片(视图),单击,双击,长按手势等操作

/*!
 * 添加网络图片
 */
- (void)addwebImage{
    NSArray *arr = @[
                     @"http://b.hiphotos.baidu.com/album/pic/item/caef76094b36acafe72d0e667cd98d1000e99c5f.jpg?psign=e72d0e667cd98d1001e93901213fb80e7aec54e737d1b867",
                     @"http://picm.photophoto.cn/038/047/010/0470100373.jpg",
                     @"http://pic41.nipic.com/20140509/18285693_231156450339_2.jpg",
                     @"http://h.hiphotos.baidu.com/lvpics/w=1000/sign=049d1d655cafa40f3cc6cadd9b54024f/29381f30e924b899de6cd36f68061d950a7bf611.jpg"
                     ];
    CGRect aframe = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGSize asize = CGSizeMake(self.view.bounds.size.width-30, aframe.size.height-100);
    ZDCycleCollection*collect = [[ZDCycleCollection alloc]initWithFrame:aframe itemsize:asize direction:UICollectionViewScrollDirectionVertical data:arr isNeedCycle:YES];
    [collect setInitCellBlock:^(ZDCycleCell *cell, NSInteger index) {
        ZDPicDetailView *imgVC = [[ZDPicDetailView alloc] initWithFrame:cell.bounds imageUrl:arr[index]];
       // imgVC.center = cell.center;
        [cell addSubview:imgVC];
    }];
    
    collect.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.98];
   
    collect.center = self.view.center;
    [self.view addSubview:collect];
   //  [collect jumpToIndex:0];
    self.collect = collect;

    
    
}
- (void)conplexDemo{
    CGRect aframe = CGRectMake(0,100, self.view.bounds.size.width, 500);
    CGSize asize = CGSizeMake(300, 400);
    NSArray *arr = @[
                     @"0.jpg",
                     @"1.jpg",
                     @"2.jpg",
                     @"3.jpg"
                     ];

    ZDCycleCollection *collect = [[ZDCycleCollection alloc] initWithFrame:aframe itemsize:asize direction:UICollectionViewScrollDirectionHorizontal data:arr isNeedCycle:YES];
    UILabel *alable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, 70, 50, 50)];
    alable.contentMode = UIViewContentModeCenter;
    alable.backgroundColor = [UIColor redColor];
    [self.view addSubview:alable];
    
    //自定义视图,单击隐藏标签,双击放大,捏合手势,长按保存
    //__weak ZDCycleCollection *weakcollect = collect;
    [collect setInitCellBlock:^(ZDCycleCell *cell, NSInteger index) {
        ZDPicDetailView *apic = [[ZDPicDetailView alloc] initWithFrame:cell.bounds imageName:arr[index]];
        [apic setSingleTapBlock:^{
            alable.hidden = !alable.hidden;
        }];
        [cell addSubview:apic];
        //[weakcollect reloadData];
    }];
    [collect setCurrentIndex:^(NSInteger index) {
        alable.text = [NSString stringWithFormat:@"第%zd张:%@",index,arr[index]];
        [alable sizeToFit];
    }];
    
    //设置选中
    [collect setSlectedCurrentPage:^(NSInteger index) {
        NSLog(@"我在大controll打印%zd",index);
    }];
    
    //是否设置为循环,默认循环

    [self.view addSubview:collect];
}
//简单图片
- (void)normalDemo{
    CGRect aframe = CGRectMake(0,100, self.view.bounds.size.width, 500);
    CGSize asize = CGSizeMake(300, 400);
    NSArray *arr = @[
                     @"0.jpg",
                     @"1.jpg",
                     @"2.jpg",
                     @"3.jpg"
                     ];
    
    ZDCycleCollection *collect = [[ZDCycleCollection alloc] initWithFrame:aframe itemsize:asize direction:UICollectionViewScrollDirectionVertical data:arr isNeedCycle:YES];
    
    //设置联动
    UILabel *alable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, 70, 50, 50)];
    alable.contentMode = UIViewContentModeCenter;
    alable.backgroundColor = [UIColor redColor];
    [self.view addSubview:alable];
    [collect setCurrentIndex:^(NSInteger index) {
        alable.text = [NSString stringWithFormat:@"第%zd张:%@",index,arr[index]];
        [alable sizeToFit];
    }];
    
    //设置选中
    [collect setSlectedCurrentPage:^(NSInteger index) {
        NSLog(@"我在大controll打印%zd",index);
    }];
    [self.view addSubview:collect];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
