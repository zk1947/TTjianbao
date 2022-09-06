//
//  JHTableViewExt.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/8.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHTableViewExt.h"
#import "JHRefreshGifHeader.h"
#import "JHRefreshNormalFooter.h"

@interface JHTableViewExt ()

@property (nonatomic, strong) UIImageView* emptyImageView;
@property (nonatomic, strong) UILabel* emptyLabel;
@end

@implementation JHTableViewExt

//是否显示空数据页面
- (void)hiddenEmptyPage:(BOOL)isHidden
{
    [self hideRefreshView];
    [self hideLoadMoreView];
    self.emptyImageView.hidden = isHidden;
    self.emptyLabel.hidden = isHidden;
    if(isHidden)
    {//remove
        [self.emptyLabel removeFromSuperview];
        [self.emptyImageView removeFromSuperview];
    }
    else
    {//add
        [self showEmptyText:@"暂无数据~" image:@"img_default_page"];
    }
}

- (void)showEmptyText:(NSString *)text image:(NSString *)image
{
    [self addSubview:self.emptyImageView];
    [self addSubview:self.emptyLabel];
    
    self.emptyImageView.hidden = NO;
    [self.emptyImageView setImage:[UIImage imageNamed:image]];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-60);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.emptyLabel.hidden = NO;
    self.emptyLabel.text = text;
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.emptyImageView.mas_centerX);
    }];
    
    //数据为空时,footer状态为MJRefreshStateNoMoreData,但不显示文本
    [self setFooterStateTitle:@"" hidden:YES];
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView)
    {
        _emptyImageView = [UIImageView new];
        _emptyImageView.contentMode = UIViewContentModeCenter;
        
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel
{
    if (_emptyLabel == nil)
    {
        _emptyLabel = [UILabel new];
        _emptyLabel.font = [UIFont systemFontOfSize:18];
        _emptyLabel.textColor = HEXCOLOR(0xa7a7a7);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

#pragma mark - up & down pull
- (void)addRefreshView
{
    JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self.delegate refreshingAction:@selector(loadNew)];
    self.mj_header = header;
}

- (void)addLoadMoreView
{
    JHRefreshNormalFooter* footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self.delegate refreshingAction:@selector(loadMore)];
    self.mj_footer = footer;
}

- (void)hideRefreshView
{
    [self.mj_header endRefreshing];
}

- (void)hideLoadMoreView
{
    [self.mj_footer endRefreshing];
}

- (void)hideLoadMoreWithNoData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)noDataEndRefreshing
{
    [self hideRefreshView];
    [self hideLoadMoreView];
    [self setFooterStateTitle:@"—— 已经到底喽~ ——" hidden:NO];
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)setFooterStateTitle:(NSString*)title hidden:(BOOL)hidden
{
    [(JHRefreshNormalFooter*)(self.mj_footer) showStateTitle:title state:MJRefreshStateNoMoreData hidden:hidden];
}

//重写响应事件
- (void)loadNew
{
    DDLogInfo(@"~~~~~loadNew~~~~");
}
//重写响应事件
- (void)loadMore
{
    DDLogInfo(@"~~~~~loadMore~~~~");
}

@end
