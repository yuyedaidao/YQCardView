//
//  YQCardLayout.m
//  YQCardController-OC
//
//  Created by 王叶庆 on 15/9/21.
//  Copyright © 2015年 王叶庆. All rights reserved.
//

#import "YQCardLayout.h"

#define MinimuInteritemSpacing 10.0f
#define SpaceTopBottom 30.0f
//typedef struct {
//    
//};

static CGFloat const ZoomDelta = 0.4;

@interface YQCardLayout ()
@property (nonatomic, assign) NSInteger visibleCount;
@property (nonatomic, assign) CGFloat itemDistance;
@end
@implementation YQCardLayout


- (instancetype)initWithVisibleCount:(NSInteger)visibleCount{
    if(self = [super init]){
        _visibleCount = visibleCount;
        _zoomDelta = ZoomDelta;
        _spaceTopBottom = SpaceTopBottom;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    //根据可见个数调整itemSize
    CGFloat side = MIN(CGRectGetHeight(self.collectionView.frame)-2*self.spaceTopBottom,CGRectGetWidth(self.collectionView.frame)/_visibleCount);
//    CGFloat side = CGRectGetHeight(self.collectionView.frame)-2*SpaceTopBottom;
    self.itemSize = CGSizeMake(side, side);
    self.sectionInset = UIEdgeInsetsMake(self.spaceTopBottom, 0, self.spaceTopBottom, 0);
    self.minimumLineSpacing = (CGRectGetWidth(self.collectionView.frame)-_visibleCount*self.itemSize.width)/(_visibleCount-1);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemDistance = self.minimumLineSpacing+self.itemSize.width;
    
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *resultArray = [NSMutableArray array];
    //先确定当前滑到的位置
    CGFloat horizontalCenter = self.collectionView.contentOffset.x+CGRectGetWidth(self.collectionView.bounds)/2;
    [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *obj = [_obj copy];
        CGFloat distance = ABS(obj.center.x-horizontalCenter);
        if(distance<self.itemDistance){
            CGFloat zoom = (1-(distance/self.itemDistance))*self.zoomDelta+1;
            obj.transform = CGAffineTransformMakeScale(zoom, zoom);
            obj.zIndex = 1;
        }else{
            obj.transform = CGAffineTransformIdentity;
        }
        [resultArray addObject:obj];
    }];
    return resultArray;
}

//借鉴自喵神的微博 http://onevcat.com/2012/08/advanced-collection-view/
- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect;
    targetRect.origin = proposedContentOffset;
    targetRect.size = self.collectionView.bounds.size;
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end
