//
//  JHDiscoverAppraiseReplyViewController.m
//  TTjianbao
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHDiscoverAppraiseReplyViewController.h"
#import "JHAppraiserReplyListPageController.h"
#import "JHAppraiserUserReplyListController.h"

@interface JHDiscoverAppraiseReplyViewController ()
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) JHAppraiserUserReplyListController *userReplyVC;
@end


@implementation JHDiscoverAppraiseReplyViewController

- (void)backActionButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initToolsBar];
//    [self.navbar setTitle:@"鉴定贴回复"];
    [self showNavView];
    self.title = @"鉴定贴回复";
//    self.navbar.ImageView.layer.shadowColor = [UIColor clearColor].CGColor;
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTitleCategoryView];
}


#pragma mark -
#pragma mark - JXCategoryView Methods

- (void)setupTitleCategoryView {
    self.titles = @[@"未回复", @"宝友回复", @"已回复"];
    self.titleCategoryView.titles = self.titles;
    self.titleCategoryView.cellSpacing = 20;
    self.titleCategoryView.titleColorGradientEnabled = YES;
    self.titleCategoryView.averageCellSpacingEnabled = YES;
    
    JXCategoryIndicatorLineView *indicatorView = self.indicatorView;
    indicatorView.indicatorWidth = 25;
    self.titleCategoryView.indicators = @[indicatorView];
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if (index == 1) {
        _userReplyVC = [JHAppraiserUserReplyListController new];
        return _userReplyVC;
        
    } else {
        //0未回复、1已回复
        JHAppraiserReplyListPageController *vc = [JHAppraiserReplyListPageController new];
        NSString *typeStr = (index == 0 ? @(index).stringValue : @(index-1).stringValue);
        vc.applyType = typeStr;
        return vc;
    }
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (index == 1 && _curIndex == index) {
        [_userReplyVC scrollToTop];
    }
    _curIndex = index;
}

@end
