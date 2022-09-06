//
//  JHSQHotListController.m
//  TaodangpuAuction
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQHotListController.h"
#import "UIView+Blank.h"
#import "JHHotListBoxView.h"

@interface JHSQHotListController ()
@property (nonatomic, strong) JHHotListBoxView *boxView;
@end

@implementation JHSQHotListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(F5F6FA);
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if (self.boxView.headScrollBlock) {
//        self.boxView.headScrollBlock(NO);
//        [self.boxView.collectionView setContentOffset:CGPointZero];
//    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_boxView viewDidDisappearMethod];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HeadSearchStatus" object:self];
    [JHHomeTabController changeStatusWithMainScrollView:nil index:0];
}

#pragma mark -
#pragma mark - UI Methods

- (void)configUI {
    [self boxView];
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark -
#pragma mark - lazy loading

-(JHHotListBoxView *)boxView
{
    if(!_boxView)
    {
        _boxView = [JHHotListBoxView new];
        @weakify(self);
        _boxView.headScrollBlock = ^(BOOL isUp) {
            @strongify(self);
            if (self.headScrollBlock) {
                self.headScrollBlock(isUp);
            }
        };
        [self.view addSubview:_boxView];
        [_boxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(1, 0, 0, 0));
        }];
    }
    return _boxView;
}


@end
