//
//  ZDPicDetailView.h
//  testImageScan
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 william. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDPicDetailView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,copy)void(^singleTapBlock)();
/**
 *  初始化
 *
 *  @param frame     布局
 *  @param imageName 图片民称
 *
 *  @return 本类实例
 */
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;
///如使用此方法需要导入SDWebImage
- (instancetype) initWithFrame:(CGRect)frame imageUrl:(NSString*)imageUrl;
//- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img;
@end
