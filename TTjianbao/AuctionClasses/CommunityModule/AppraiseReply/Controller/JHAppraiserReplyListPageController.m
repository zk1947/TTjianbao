//
//  JHAppraiserReplyListPageController.m
//  TTjianbao
//
//  Created by lihui on 2020/3/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiserReplyListPageController.h"
#import "JHAppraiserReplyListController.h"
#import "JHAppraiseReplyViewModel.h"
#import "JHAppraiserReplyChannelData.h"
#import "UIView+Blank.h"
#import "UITitleBarBackgroundView.h"

@interface JHAppraiserReplyListPageController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSMutableArray *channelList;

@property (nonatomic, strong) JXCategoryIndicatorBackgroundView *indicatorBackgroundView;

@end

@implementation JHAppraiserReplyListPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    [self loadChannelData];
    [self setupTitleCategoryView];
}

#pragma mark -
#pragma mark - JXCategoryView Methods

- (JXCategoryBaseView *)preferredCategoryView {
    return [[UITitleBarBackgroundView alloc] init];
}

- (void)setupTitleCategoryView {
    self.titleCategoryBgView.backgroundColor = [UIColor whiteColor];
    self.titleCategoryBgView.titleColor = kColor666;
    self.titleCategoryBgView.titleSelectedColor = kColor333;
    self.titleCategoryBgView.titleFont = [UIFont fontWithName:kFontNormal size:12];
    self.titleCategoryBgView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:12];
    self.titleCategoryBgView.titleColorGradientEnabled = NO;
    //self.titleCategoryBgView.indicators = @[self.indicatorBackgroundView];
    //cell背景设置
    self.titleCategoryBgView.bgHeight = 26;
    self.titleCategoryBgView.bgCornerRadius = 13;

    self.titleCategoryBgView.sd_resetLayout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs([self preferredCategoryViewHeight]);
    
    self.listContainerView.sd_resetLayout
    .topSpaceToView(self.titleCategoryBgView,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, UI.bottomSafeAreaHeight);
}

- (JXCategoryIndicatorBackgroundView *)indicatorBackgroundView {
    if (!_indicatorBackgroundView) {
        _indicatorBackgroundView = [[JXCategoryIndicatorBackgroundView alloc] initWithFrame:CGRectZero];
        _indicatorBackgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
        _indicatorBackgroundView.indicatorWidthIncrement = 26; //背景色块的额外宽度
        _indicatorBackgroundView.indicatorHeight = 26;
        _indicatorBackgroundView.indicatorCornerRadius = 13;
        _indicatorBackgroundView.backgroundColor = kColorEEE;
        _indicatorBackgroundView.indicatorColor = kColorMain;
    }
    return _indicatorBackgroundView;
}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index >= self.channelList.count) {
        return nil;
    }
    JHAppraiserReplyChannelData *model = self.channelList[index];
    JHAppraiserReplyListController *vc = [JHAppraiserReplyListController new];
    vc.applyType = self.applyType;
    vc.channelId = [NSString stringWithFormat:@"%ld", (long)model.channel_id];
    return vc;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXCategoryListCollectionContentViewDelegate
- (UIView *)listView {
    return self.view;
}


#pragma mark -
#pragma mark - data

- (void)loadChannelData {
    [JHAppraiseReplyViewModel getAppraiseChannelList:^(id  _Nullable respObj, BOOL hasError) {
        RequestModel *responseObj = respObj;
        if (!hasError) {
            self.titleCategoryBgView.backgroundColor = [UIColor whiteColor];
            NSArray *arr = [JHAppraiserReplyChannelData mj_objectArrayWithKeyValuesArray:responseObj.data];
            self.channelList = [NSMutableArray arrayWithArray:arr];
        
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:self.channelList.count];
            
            [self.channelList enumerateObjectsUsingBlock:^(JHAppraiserReplyChannelData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titleArray addObject:obj.channel_name];
            }];
            
            self.titleCategoryBgView.backgroundColor = [UIColor whiteColor];
            self.titles = titleArray.copy;
            self.titleCategoryBgView.titles = self.titles;
            [self.titleCategoryBgView reloadData];
        }
        else {
            self.titleCategoryBgView.backgroundColor = [UIColor clearColor];
            [self.view toast:responseObj.message image:nil];
            
            [self.view configBlankType:YDBlankTypeNone hasData:self.titles.count > 0 hasError:hasError offsetY:self.titleCategoryBgView.height reloadBlock:^(id sender) {
                NSLog(@"点击刷新按钮");
                //[self refresh];
            }];
        }
    }];
}


@end
