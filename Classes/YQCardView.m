//
//  YQCardController.m
//  YQCardController-OC
//
//  Created by 王叶庆 on 15/9/21.
//  Copyright © 2015年 王叶庆. All rights reserved.
//

#import "YQCardView.h"
#import "YQCardLayout.h"

static NSString *const YQPlaceholderIdentifier = @"YQPlaceholderIdentifier";

@interface YQCardView ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger _visibleCount;
};


@property (nonatomic, strong) NSDictionary *registerInfo;
@property (nonatomic, assign) NSInteger itemCount;
@end

@implementation YQCardView

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithVisibleCount:(NSInteger)count registerInfo:(NSDictionary *)info{
    NSAssert(count%2==1, @"Sorry,需要您输入一个奇数");
    if(self = [super init]){
        _visibleCount = count;
        self.registerInfo = info;
        [self prepare];
    }
    return self;
}

- (void)prepare{
    self.layout = [[YQCardLayout alloc] initWithVisibleCount:_visibleCount];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    
    NSAssert(self.registerInfo, @"您还没有注册任何可复用的cell信息");
    [self.registerInfo enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UINib class]]){
            [self.collectionView registerNib:obj forCellWithReuseIdentifier:key];
        }else{
            [self.collectionView registerClass:obj forCellWithReuseIdentifier:key];
        }
    }];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:YQPlaceholderIdentifier];
    
    [self addSubview:self.collectionView];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark public

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForItem:indexPath.item+_visibleCount/2 inSection:indexPath.section]];
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.itemNumberBlock){
        NSInteger count = self.itemNumberBlock();
        return self.itemCount = count <= 0 ? 0:count+_visibleCount-1;//两边都加上了占位元素
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item < _visibleCount/2 || indexPath.item >= self.itemCount-_visibleCount/2){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YQPlaceholderIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    if(self.cellForItemBlock){
        return self.cellForItemBlock([NSIndexPath indexPathForItem:indexPath.item-_visibleCount/2 inSection:indexPath.section]);
    }
    return nil;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
