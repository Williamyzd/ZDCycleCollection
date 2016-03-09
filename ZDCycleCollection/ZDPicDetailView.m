//
//  ZDPicDetailView.m
//  testImageScan
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 william. All rights reserved.
//

#import "ZDPicDetailView.h"
#import "UIImageView+WebCache.h"
@interface ZDPicDetailView(){
       CGFloat   scale;
    UIImageView  *imgView;
}
@end
@implementation ZDPicDetailView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self setMinimumZoomScale:.5];
        [self setMaximumZoomScale:5.0];
        UIImageView * imagev = [[UIImageView alloc] initWithFrame:self.bounds];
        imagev.contentMode = UIViewContentModeScaleAspectFit;
        [self addGuesturesWithView:imagev];
        self.delegate = self;
        imagev.backgroundColor = [UIColor redColor];
        [self addSubview:imagev];
        imgView = imagev;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img{
    self = [[ZDPicDetailView alloc] initWithFrame:frame];
    if (self) {
        imgView.image = img;
        CGSize imageSize = [self reSetImageSize:img.size ] ;
        imgView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        imgView.center = self.center;
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl{
    
    self = [[ZDPicDetailView alloc] initWithFrame:frame];
    if (self) {
        __weak typeof(self) weakself = self;
    __weak UIImageView * weakImageV = imgView;
      [imgView setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
          if(image){
            CGSize imageSize = [weakself reSetImageSize:image.size ] ;
            CGPoint center = weakImageV.center;
            weakImageV.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
            weakImageV.center = center;
        }
      }];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    self = [[ZDPicDetailView alloc]initWithFrame:frame image:[UIImage imageNamed:imageName]];
    return self;
}

    //图片等比处理
- (CGSize)reSetImageSize:(CGSize)size{
    if(size.width == 0 || size.height == 0)
            return CGSizeZero;
        
        float xscale = size.width/self.bounds.size.width;
        float yscale = size.height/self.bounds.size.height;
        CGSize rsize ;
        
        if(xscale > yscale){
            rsize = CGSizeMake(self.bounds.size.width, size.height / xscale);
        }else{
            rsize = CGSizeMake(size.width / yscale, self.bounds.size.height);
        }
        return rsize;
    }

#pragma mark----手势操作
- (void)addGuesturesWithView:(UIImageView*)view{
    view.userInteractionEnabled = YES;
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGuestureJust)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired =1;
    [view addGestureRecognizer:singleTap];
    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGuestureJust:)];
    doubleTap.numberOfTapsRequired = 2;
    [view addGestureRecognizer:doubleTap];
    //长按保存
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressJust:)];
    [view addGestureRecognizer:longPress];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
}

//单击退出
- (void)singleGuestureJust{
    //    [self dismissViewControllerAnimated:YES completion:Nil];
    NSLog(@"单击");
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

//双击缩放
- (void)doubleGuestureJust:(UIGestureRecognizer*)sender{
    NSLog(@"%@",sender.view);
    // 解决手势叠加问题
    //for(UIScrollView * sc in self.subviews){
        if(self.zoomScale != 1){
            [self setZoomScale:1 animated:YES];
            [UIView animateWithDuration:.3 animations:^{
                sender.view.transform = CGAffineTransformMakeScale(1, 1);
                scale = 0;
            }];
            return;
            
        }
 //   }
    
    if (!scale) {
        scale = 2.0;
        
        [UIView animateWithDuration:.3 animations:^{
            sender.view.transform =CGAffineTransformMakeScale(scale, scale);
        }];
        
    }else {
        [UIView animateWithDuration:.3 animations:^{
            sender.view.transform = CGAffineTransformMakeScale(1, 1);
            scale = 0;
        }];
    }
    
}
//长按保存
- (void)longPressJust:(UILongPressGestureRecognizer *)longPress{
    
    if ([longPress state] == UIGestureRecognizerStateBegan) {
        
        UIImageView *imageView = (UIImageView *)longPress.view;
        //   UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
        UIImageWriteToSavedPhotosAlbum(imageView.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
    }
    
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        NSLog(@"保存成功");
    }else{
        NSLog(@" 保存失败");
    }
}
#pragma mark - /*************************scrollview代理方法***************************/
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    UIView * view = [[scrollView subviews ] objectAtIndex:0];
    
    view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                              scrollView.contentSize.height * 0.5 + offsetY);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIView * view = [[scrollView subviews] objectAtIndex:0];
    return view;
}
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//    if(scrollView.zoomScale != 1){
//                [scrollView setZoomScale:1 animated:YES];
//            }
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//            if(scrollView.zoomScale != 1){
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [scrollView setZoomScale:1 animated:NO];
//                    
//                });
//            }
//}
//
@end
