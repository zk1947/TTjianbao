//
//  JHOnlineAppraiseTopicView.m
//  TTjianbao
//
//  Created by lihui on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseTopicView.h"
#import "JHOnlineTopicListView.h"
#import "JHTopicDetailController.h"
#import "JHAllTopicsViewController.h"
#import "JHOnlineAppraiseModel.h"
#import "JHGrowingIO.h"
#import "JHOnlineAppraiseHeader.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"

#define kListViewCount  5
#define kIconMargin  15.f
//#define kListViewWidth ((ScreenW - 2*kIconMargin)/kListViewCount)
#define kListViewMargin ((ScreenW - 30 - kListViewCount*kTopicIconWidth)/(kListViewCount-1))

@interface JHOnlineAppraiseTopicView ()
@property (nonatomic, strong) NSMutableArray <JHOnlineTopicListView *>*listViews;
@end

@implementation JHOnlineAppraiseTopicView

- (NSMutableArray<JHOnlineTopicListView *> *)listViews {
    if (!_listViews) {
        _listViews = [NSMutableArray array];
    }
    return _listViews;
}

- (void)setTopicInfo:(NSArray<JHOnlineAppraiseModel *> *)topicInfo {
    if (!topicInfo) {
        return;
    }

    _topicInfo = topicInfo;
    if (topicInfo.count < kListViewCount) {
        for (int i = (int)_topicInfo.count; i < self.listViews.count; i ++) {
            JHOnlineTopicListView *view = self.listViews[i];
            [view.layer cancelCurrentImageRequest];
            view.hidden = YES;
        }
    }

    int count = _topicInfo.count < kListViewCount ? (int)_topicInfo.count : kListViewCount;
    for (int i = 0; i < count; i ++) {
        JHOnlineTopicListView *topicView = self.listViews[i];
        topicView.hidden = NO;
        JHOnlineAppraiseModel *model = _topicInfo[i];
        if (i == kListViewCount - 1) {
            [topicView setIcon:[NSString stringWithFormat:@"%ld+", (long)_topicInfo.count] name:@"查看全部" iconType:JHOnlineTopicIconTypeText];
        }
        else {
            [topicView setIcon:model.bg_img name:model.name iconType:JHOnlineTopicIconTypeImg];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorFFF;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    JHOnlineTopicListView *tempListView = nil;
    for (int i = 0; i < kListViewCount; i ++) {
        JHOnlineTopicListView *listView = [[JHOnlineTopicListView alloc] init];
        [self addSubview:listView];
        [self.listViews addObject:listView];
        listView.hidden = YES;
        
        if (i == kListViewCount-1) {
            [listView setIcon:@"0+" name:@"查看全部" iconType:JHOnlineTopicIconTypeText];
        }
        else {
            [listView setIcon:@"" name:@"未知" iconType:JHOnlineTopicIconTypeImg];
        }
        
        [listView topicCellClick:^{
            if (i == kListViewCount-1) {
                ///查看全部鉴定师
                [self __enterAllTopicList];
            }
            else {
                ///跳转到话题主页
                [self __enterTopicHomePage:i];
            }
        }];
                
        if (tempListView == nil) {
            ///第一个view
            [listView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kIconMargin);
                make.top.equalTo(self).offset(15);
                make.bottom.equalTo(self).offset(-12);
                make.width.mas_equalTo(kTopicIconWidth);
            }];
        }
        else {
            [listView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempListView.mas_right).offset(kListViewMargin);
                make.centerY.width.height.equalTo(tempListView);
            }];
        }
        
        tempListView = listView;
    }
}

///查看全部鉴定师
- (void)__enterAllTopicList {
    JHAllTopicsViewController *vc = [[JHAllTopicsViewController alloc] init];
    vc.topicInfo = self.topicInfo.mutableCopy;
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_allhead_click" params:@{} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
    
}

///进入话题主页
- (void)__enterTopicHomePage:(NSInteger)index {
    JHOnlineAppraiseModel *model = self.topicInfo[index];
//    [JHGrowingIO trackEventId:@"appraisal_people_in" variables:@{@"user_id":model.Id}];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_headc_click" params:@{@"appraisal_name":model.name,@"appraisal_id":model.Id,@"index":@(index)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
    
    if ([model.Id integerValue] > 0) {
        JHTopicDetailController *vc = [[JHTopicDetailController alloc] init];
        vc.topicId = model.Id;
        vc.pageFrom = @"online_appraise";   ///需要替换页面来源  ！！！！  ----- MARK： TODO lihui
        vc.supportEnterVideo = YES; ///不支持进入帖子详情页
        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}
@end
