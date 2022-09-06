//
//  JHRecycleOrderPageController.m
//  TTjianbao
//
//  Created by lihui on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderPageController.h"
#import "JHRecyclePublishedViewController.h"
#import "JHRecycleSoldOutViewController.h"

@interface JHRecycleOrderPageController ()
///我发布的
@property (nonatomic, strong) UIButton *publishButton;
///我卖出的
@property (nonatomic, strong) UIButton *soldOutButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation JHRecycleOrderPageController

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self createContentView];
}

- (void)createContentView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight)];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.scrollEnabled = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(ScreenW * 2, self.view.bounds.size.height);
    [self.view addSubview:_contentScrollView];
    
    JHRecyclePublishedViewController *publishVC = [[JHRecyclePublishedViewController alloc] init];
    publishVC.view.frame = CGRectMake(0, 0, ScreenW, _contentScrollView.bounds.size.height);
    [self addChildViewController:publishVC];
    [_contentScrollView addSubview:publishVC.view];
    
    JHRecycleSoldOutViewController *soldVC = [[JHRecycleSoldOutViewController alloc] init];
    soldVC.view.frame = CGRectMake(ScreenW, 0, ScreenW, _contentScrollView.bounds.size.height);
    [self addChildViewController:soldVC];
    [_contentScrollView addSubview:soldVC.view];
    
    
    //默认选中的下标
    if (self.selectIndex == 0) {
        [self __handlePublishButtonAction];
    }else{
        [self __handleSoldOutButtonAction];
    }
}

- (void)configNav {
    [self showNavView];
    UIView *segmentView = [[UIView alloc] init];
    segmentView.backgroundColor = kColorFFF;
    [self.jhNavView addSubview:segmentView];
    
    _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishButton setTitle:@"我发布的" forState:UIControlStateNormal];
    [_publishButton setTitle:@"我发布的" forState:UIControlStateSelected];
    [_publishButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [_publishButton setTitleColor:kColor333 forState:UIControlStateSelected];
    _publishButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.];
    [_publishButton addTarget:self action:@selector(__handlePublishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _publishButton.selected = !self.selectIndex;
    [segmentView addSubview:_publishButton];
    
    _soldOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_soldOutButton setTitle:@"我卖出的" forState:UIControlStateNormal];
    [_soldOutButton setTitle:@"我卖出的" forState:UIControlStateSelected];
    [_soldOutButton setTitleColor:kColor666 forState:UIControlStateNormal];
    [_soldOutButton setTitleColor:kColor333 forState:UIControlStateSelected];
    _soldOutButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.];
    [_soldOutButton addTarget:self action:@selector(__handleSoldOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _soldOutButton.selected = self.selectIndex;
    [segmentView addSubview:_soldOutButton];
    
    _lineView = [UIView jh_viewWithColor:HEXCOLOR(0xFFDB27) addToSuperview:segmentView];
    [_lineView jh_cornerRadius:1.5];
    [segmentView addSubview:_lineView];
    
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jhNavView);
        make.left.equalTo(self.jhNavView).offset(50);
        make.right.equalTo(self.jhNavView).offset(-50);
        make.height.mas_equalTo(44.);
    }];
    
    [_publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(segmentView.mas_centerX).offset(-20);
        make.height.mas_equalTo(15.);
        make.centerY.equalTo(segmentView);
    }];

    [_soldOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(segmentView.mas_centerX).offset(20);
        make.centerY.width.height.equalTo(self.publishButton);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 3.f));
        make.centerX.equalTo(self.publishButton);
        make.top.equalTo(self.publishButton.mas_bottom).offset(5);
    }];
}

- (void)__handlePublishButtonAction {
    self.selectIndex = 0;
    [self changeScrollViewOffset];
    _publishButton.selected = YES;
    _soldOutButton.selected = NO;
    _publishButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:17.];
    _soldOutButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];

    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publishButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.publishButton);
        make.size.mas_equalTo(CGSizeMake(20, 3.f));
    }];
}

- (void)__handleSoldOutButtonAction {
    self.selectIndex = 1;
    [self changeScrollViewOffset];
    _publishButton.selected = NO;
    _soldOutButton.selected = YES;
    _soldOutButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:17.];
    _publishButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.soldOutButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.soldOutButton);
        make.size.mas_equalTo(CGSizeMake(20, 3.f));
    }];
}

- (void)changeScrollViewOffset {
    [_contentScrollView setContentOffset:CGPointMake(self.selectIndex*ScreenW, 0) animated:YES];
}

@end
