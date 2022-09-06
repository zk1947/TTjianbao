//
//  JHTopicTallyView.m
//  TTjianbao
//
//  Created by lihui on 2020/8/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicTallyView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHPostDetailModel.h"
#import "JHTopicDetailController.h"

#define topicTag 1000

@interface JHTopicTallyView ()

///话题标签数组
@property (nonatomic, strong) NSMutableArray *topicBtns;

@end

@implementation JHTopicTallyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configTopicInfo:(NSArray <NSString *>*)topics {
    if (!topics || topics.count == 0) {
        return;
    }

    CGFloat space = 30.f;
    CGFloat btnHeight = 18.f;
    CGFloat allWidth = 0;
    for (int i = 0; i < topics.count; ++i) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = HEXCOLOR(0xEEF3FA);
        [self addSubview:bottomView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"dis_videoBaby"] forState:UIControlStateNormal];
        [btn setTitle:topics[i] forState:UIControlStateNormal];
        [btn setTitleColor:kColorTopicTitle forState:UIControlStateNormal];
        [bottomView addSubview:btn];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [btn addTarget:self action:@selector(enterTopicDetail:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = topicTag + i;
        
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25 + i*space + allWidth);
            make.bottom.equalTo(self).offset(-15);
            make.height.mas_equalTo(btnHeight);
        }];
        [btn layoutIfNeeded];
        allWidth += btn.width;
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(btn).insets(UIEdgeInsetsMake(-5, -10, -5, -10));
        }];
        
        [bottomView layoutIfNeeded];
        bottomView.layer.cornerRadius = bottomView.height/2.f;
        bottomView.layer.masksToBounds = YES;
    }
}

- (void)setTopicInfos:(NSArray<JHTopicInfo *> *)topicInfos {
    _topicInfos = topicInfos;
    NSMutableArray *arr = [NSMutableArray array];
    for (JHTopicInfo *info in topicInfos) {
        [arr addObject:info.name];
    }
    [self configTopicInfo:arr.copy];
}

- (void)enterTopicDetail:(UIButton *)sender {
    if (_topicInfos.count == 0) return;

    NSInteger index = sender.tag - topicTag;
    JHTopicInfo *info = _topicInfos[index];
#warning - 参数待确认 ！！！！！！！！！！
    ///340埋点 - 话题进入事件
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailTopicEnter params:@{@"page_from":JHFromSQPostDetail,
                                                                    @"topic_id" : info.ID} type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
    JHTopicDetailController *vc = [JHTopicDetailController new];
    vc.topicId = info.ID;
    vc.pageFrom = JHFromSQPicDetail;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}


@end
