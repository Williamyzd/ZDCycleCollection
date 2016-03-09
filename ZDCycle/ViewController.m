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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    //只加载图片的demo
    //[self normalDemo];
    
    // 自定义视图的demo
    [self conplexDemo];
    }
//复杂图片(视图),单击,双击,长按手势等操作
- (void)conplexDemo{
    CGRect aframe = CGRectMake(0,100, self.view.bounds.size.width, 500);
    CGSize asize = CGSizeMake(300, 400);
    NSArray *arr = @[
                     @"0.jpg",
                     @"1.jpg",
                     @"2.jpg",
                     @"3.jpg"
                     ];

    ZDCycleCollection *collect = [[ZDCycleCollection alloc] initWithFrame:aframe itemsize:asize direction:UICollectionViewScrollDirectionHorizontal data:arr];
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
    
    ZDCycleCollection *collect = [[ZDCycleCollection alloc] initWithFrame:aframe itemsize:asize direction:UICollectionViewScrollDirectionVertical data:arr];
    
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
