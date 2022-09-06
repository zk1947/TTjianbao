//
//  JHRecommendTopicCollectionCell.m
//  TTjianbao
//
//  Created by lihui on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecommendTopicCollectionCell.h"
#import "JHRecommendTopicListView.h"

#define LIST_HEIGHT (174/3.)

@interface JHRecommendTopicCollectionCell ()
@property (nonatomic, strong) NSMutableArray <JHRecommendTopicListView *>*listViewArray;
@end

@implementation JHRecommendTopicCollectionCell

- (void)setTopicArray:(NSArray<JHTopicInfo *> *)topicArray {
    if (!(topicArray && topicArray.count > 0)) {
        return;
    }
    _topicArray = topicArray;

    for (int i = (int)_topicArray.count; i < self.listViewArray.count; i ++) {
        JHRecommendTopicListView *list = self.listViewArray[i];
        [list.layer cancelCurrentImageRequest];
        [list setHidden:YES];
    }
    
    for (int i = 0; i < _topicArray.count; i ++) {
        JHRecommendTopicListView *list = self.listViewArray[i];
        list.hidden = NO;
        list.showLine = (i != _topicArray.count-1);
        list.topicInfo = _topicArray[i];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    for (int i = 0; i < 3; i ++) {
        JHRecommendTopicListView *list = [[JHRecommendTopicListView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:list];
        [self.listViewArray addObject:list];
        [list mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(i*LIST_HEIGHT);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(LIST_HEIGHT);
        }];
    }
}

- (NSMutableArray<JHRecommendTopicListView *> *)listViewArray {
    if (!_listViewArray) {
        _listViewArray = [NSMutableArray array];
    }
    return _listViewArray;
}

@end
