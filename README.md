# YQCardView
个人项目中用于展示当前头像 当然也可做他用

###展示
[](!https://github.com/yuyedaidao/YQCardView/blob/master/carView.gif)

###获取

 > pod 'YQCardView'

###使用

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
