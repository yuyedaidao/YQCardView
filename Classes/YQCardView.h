//
//  YQCardController.h
//  YQCardController-OC
//
//  Created by 王叶庆 on 15/9/21.
//  Copyright © 2015年 王叶庆. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YQCardView : UIView

/**
 *  😢为了让正中的元素突出，所以我们的visibleCount必须是奇数
 *
 *  @param count count description
 *
 *  @return return value description
 */
- (instancetype)initWithVisibleCount:(NSInteger)count registerInfo:(NSDictionary *)info;

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier   forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) UICollectionViewCell *(^cellForItemBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) NSInteger (^itemNumberBlock)(void);
@end
