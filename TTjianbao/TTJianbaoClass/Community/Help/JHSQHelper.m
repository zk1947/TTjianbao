//
//  JHSQHelper.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "NTESGrowingInternalTextView.h"

@implementation JHSQHelper

#pragma mark -
#pragma mark - 首页相关

//导航标签
+ (void)configPageTitleView:(JXCategoryTitleView *)titleCategoryView indicator:(JXCategoryIndicatorLineView * _Nullable )indicator {
    titleCategoryView.titleColor = kColor666;
    titleCategoryView.titleSelectedColor = kColor333;
    titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:16];
    //titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:22]; 使用titleLabelZoomScale自动缩放
    
    titleCategoryView.contentEdgeInsetLeft = 15;
    titleCategoryView.contentEdgeInsetRight = 44;
    titleCategoryView.cellSpacing = 25;
    titleCategoryView.titleLabelVerticalOffset = -(kSearchBgHeight/2); //中心位置偏移
    
    titleCategoryView.titleColorGradientEnabled = YES;
    titleCategoryView.titleLabelZoomEnabled = YES;
    titleCategoryView.titleLabelZoomScale = 1.375; //缩放比例，放大后字体大小为 16*1.375 = 22
    
    titleCategoryView.cellWidthZoomEnabled = YES; //cell宽度缩放
    //titleCategoryView.cellWidthZoomScale = 1.3;
    
    titleCategoryView.selectedAnimationEnabled = YES;
    titleCategoryView.averageCellSpacingEnabled = NO; //是否按屏幕宽度居中显示每个cell
    titleCategoryView.defaultSelectedIndex = 0;
    //点击cell进行页面切换时打开动画。默认为YES
    titleCategoryView.contentScrollViewClickTransitionAnimationEnabled = YES;
    
    if (indicator) {
        indicator.indicatorWidth = 28.;
        indicator.indicatorHeight = 4;
        indicator.verticalMargin = kSearchBgHeight+4; //指示器位置偏移
        titleCategoryView.indicators = @[indicator];
        
    } else {
        JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImgView.indicatorImageView.backgroundColor = HEXCOLOR(0xFFD70F);
        indicatorImgView.indicatorImageView.layer.cornerRadius = 2.f;
        indicatorImgView.indicatorImageView.layer.masksToBounds = YES;
        indicatorImgView.indicatorImageViewSize = CGSizeMake(28., 4.);
        indicatorImgView.verticalMargin = kSearchBgHeight+4;
        titleCategoryView.indicators = @[indicatorImgView];
    }
}

#pragma mark - 消息按钮

//消息按钮
+ (UIButton *)messageButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"navi_icon_message"] forState:UIControlStateNormal];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self enterMessageVC];
    }];
    return btn;
}

+ (void)enterMessageVC {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
        
    } else {
        Class class = NSClassFromString(@"JHMessageViewController");
        if (class) {
            UIViewController *vc = [class new];
            [vc setValue:JHFromSQHomeFeedList forKey:@"from"];
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 搜索框

+ (UIView *)searchBgView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
+ (JHEasyPollSearchBar *)searchBar {
    JHEasyPollSearchBar *searchBar = [JHEasyPollSearchBar new];
    searchBar.backgroundColor = kColorF5F6FA;
    searchBar.layer.cornerRadius = kSearchBarHeight/2;
    searchBar.layer.masksToBounds = YES;
    
    return searchBar;
}


#pragma mark - 首页推荐列表

+ (JHSQBannerView *)bannerView {
    JHSQBannerView *bannerView = [JHSQBannerView bannerWithClickBlock:^(BannerCustomerModel * _Nonnull bannerData, NSInteger selectIndex) {
        NSLog(@"点击banner");
        [JHRootController toNativeVC:bannerData.target.componentName withParam:bannerData.target.params from:JHFromSQHomeFeedList];
        //[JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick from:JHTrackMarketSaleClickSaleBanner];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:@"宝友社区" forKey:@"page_position"];
        [params setValue:@(selectIndex) forKey:@"position_sort"];
        [params setValue:bannerData.target.recordComponentName forKey:@"content_url"];
        [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:params type:JHStatisticsTypeSensors];
    }];
    return bannerView;
}

+ (void)setKeyBoardEnable:(BOOL)enable {
    [[IQKeyboardManager sharedManager] setEnable:enable];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

+ (void)configTableView:(UITableView *)table cells:(NSArray<NSString *> *)cells {
    table.backgroundColor = [UIColor whiteColor];
    for (NSString *cellName in cells) {
        [table registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellName];
    }
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

///根据item_type返回相应的cell
+ (Class)cellClassWithItemType:(JHPostItemType)itemType {
    Class cellClass = Nil;
    
    switch (itemType) {
        case JHPostItemTypePost: {
            cellClass = NSClassFromString(@"JHSQPostNormalCell");
            break;
        }
        case JHPostItemTypeDynamic: {
            cellClass = NSClassFromString(@"JHSQPostDynamicCell");
            break;
        }
        case JHPostItemTypeVideo:
        case JHPostItemTypeAppraisalVideo:
        {
            cellClass = NSClassFromString(@"JHSQPostVideoCell");
            break;
        }
        case JHPostItemTypeAD: {
            cellClass = NSClassFromString(@"JHSQPostADCell");
            break;
        }
        case JHPostItemTypeTopic: {
            cellClass = NSClassFromString(@"JHSQPostTopicCell");
            break;
        }
        case JHPostItemTypeLiveRoom: {
            cellClass = NSClassFromString(@"JHSQPostLiveRoomCell");
            break;
        }
        default:
            break;
    }
    return cellClass;
}

@end
