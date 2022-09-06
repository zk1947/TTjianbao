//
//  JHTableViewController.m
//  TTjianbao
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHTableViewController.h"
#import "JHRefreshNormalFooter.h"
#import "JHRefreshGifHeader.h"

#define kJHTableViewControllerIdentifer @"kJHTableViewControllerIdentifer"

@interface JHTableViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation JHTableViewController
- (void)dealloc
{
    DDLogInfo(@"JHTableViewController dealloc~~~%@", [self description]);
}

- (UITableView*)jhTableView
{
    if(!_jhTableView)
    {
        _jhTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _jhTableView.backgroundColor = HEXCOLOR(0xf8f8f8);
        _jhTableView.delegate = self;
        _jhTableView.dataSource = self;
        _jhTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _jhTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _jhTableView;
}

- (void)addRefreshView
{
    JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    _jhTableView.mj_header = header;
}

- (void)hideRefreshView
{
    [_jhTableView.mj_header endRefreshing];
}

- (void)addLoadMoreView
{
    JHRefreshNormalFooter* footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _jhTableView.mj_footer = footer;
}

- (void)hideLoadMoreView
{
    [_jhTableView.mj_footer endRefreshing];
}

- (void)hideLoadMoreWithNoData
{
    [_jhTableView.mj_footer endRefreshingWithNoMoreData];
}

//重写响应事件
- (void)loadMore
{
    DDLogInfo(@"~~~~~loadMore~~~~");
}
//重写响应事件
- (void)loadNew
{
    DDLogInfo(@"~~~~~loadNew~~~~");
}

#pragma mark - table view delegate & dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //子类重写
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kJHTableViewControllerIdentifer];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJHTableViewControllerIdentifer];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //子类重写
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //子类重写
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //子类重写
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //子类重写
    CGPoint point = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if(point.y > 0)
    {
//        DDLogInfo(@"JHTableViewController~~~~~~~scroll向下");
        if(self.scrollDirectType == JHScrollDirectTypeDefault)
            self.scrollDirectType = JHScrollDirectTypeDown;
    }
    else
    {
//        DDLogInfo(@"JHTableViewController~~~~~~~scroll向上");
        if(self.scrollDirectType == JHScrollDirectTypeDefault)
            self.scrollDirectType = JHScrollDirectTypeUp;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollDirectType = JHScrollDirectTypeDefault;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
        self.scrollDirectType = JHScrollDirectTypeEnd;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.scrollDirectType = JHScrollDirectTypeEnd;
}

#pragma mark - empty page
- (void)showImageName:(NSString *)imageName title:(NSString *)string superview:(UIView *)view
{
    [view addSubview:self.imageView];
    [view addSubview:self.label];
    self.imageView.hidden = NO;
    self.label.hidden = NO;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    self.label.text = string;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY).offset(-60);
        make.centerX.equalTo(view.mas_centerX);
        
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.imageView.mas_centerX);
    }];
    
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
        
    }
    return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textColor = HEXCOLOR(0xa7a7a7);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)showDefaultImageWithView:(UIView *)superView
{
    [self showImageName:@"img_default_page" title:@"暂无数据~" superview:superView];
}

- (void)hiddenDefaultImage
{
    _imageView.hidden = YES;
    _label.hidden = YES;
}
@end
