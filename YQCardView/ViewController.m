//
//  ViewController.m
//  YQCardView
//
//  Created by Wang on 15/9/22.
//  Copyright © 2015年 Wang. All rights reserved.
//

#import "ViewController.h"

#import "YQCardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YQCardView *cardView = [[YQCardView alloc] initWithVisibleCount:3 registerInfo:@{@"A":[UICollectionViewCell class]}];
    [self.view addSubview:cardView];
    cardView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 140);
    //    cardView.frame = self.view.bounds;
    cardView.center = self.view.center;
    
    [cardView setItemNumberBlock:^NSInteger{
        return 11;
    }];
    __weak typeof(cardView) weakCardView = cardView;
    [cardView setCellForItemBlock:^UICollectionViewCell *(NSIndexPath *indexPath) {
        UICollectionViewCell *cell = [weakCardView dequeueReusableCellWithReuseIdentifier:@"A" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        return cell;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
