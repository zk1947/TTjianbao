//
//  JHOnlineTopicHeader.m
//  TTjianbao
//
//  Created by lihui on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOnlineTopicHeader.h"
#import "JHOnlineAppraiseTopicView.h"

@interface JHOnlineTopicHeader ()
///展示话题列表的view
@property (nonatomic, strong) JHOnlineAppraiseTopicView *topicListView;
@end

@implementation JHOnlineTopicHeader

- (void)setTopicInfo:(NSArray<JHOnlineAppraiseModel *> *)topicInfo {
    if (!topicInfo) {
        return;
    }
    _topicInfo = topicInfo;
    self.topicListView.topicInfo = _topicInfo;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return  self;
}

- (void)initViews {
    [self addSubview:self.topicListView];
    [self.topicListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (JHOnlineAppraiseTopicView *)topicListView {
    if (!_topicListView) {
        _topicListView = [[JHOnlineAppraiseTopicView alloc] init];
    }
    return _topicListView;
}


@end
