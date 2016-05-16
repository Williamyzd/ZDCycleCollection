//
//  ZDLayout.m

//
//  Created by william on 16/3/6.
//  Copyright © 2016年 william. All rights reserved.
//

#import "ZDLayout.h"
@interface ZDLayout(){
    CGFloat  marginL;
    CGFloat  marginT;
    
}

@end
@implementation ZDLayout
- (void)prepareLayout{
    CGFloat marginLeft = (self.collectionView.bounds.size.width - self.itemSize.width)/2;
    CGFloat marginTop = (self.collectionView.bounds.size.height -self.itemSize.height)/2;
    marginL = marginLeft;
    marginT = marginTop;
    if (self.scrollDirection ==UICollectionViewScrollDirectionHorizontal) {
        self.collectionView.contentInset =UIEdgeInsetsMake( marginT, marginL,  marginT, marginL);

    }else{
        self.collectionView.contentInset =UIEdgeInsetsMake( marginT, 0, marginT,0);
    }
  }

//每个cell对应的属性,frame信息必须实现
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    //垂直
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat centerY = self.collectionView.bounds.size.height*indexPath.row + self.itemSize.height/2 + marginT;
        
        attributes.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2, centerY);
        //横向
    } else {
        CGFloat centerX = self.collectionView.bounds.size.width*indexPath.row + self.itemSize.width/2 + marginL;
        attributes.center = CGPointMake(centerX, CGRectGetHeight(self.collectionView.frame) / 2);
    }
    
    return attributes;
}

//所有的布局信息
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (CGSize)collectionViewContentSize {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(self.collectionView.bounds.size.width, cellCount * self.collectionView.bounds.size.height);
    }else{
        return CGSizeMake(cellCount*self.collectionView.bounds.size.width, 0);
    }
    
}

@end
