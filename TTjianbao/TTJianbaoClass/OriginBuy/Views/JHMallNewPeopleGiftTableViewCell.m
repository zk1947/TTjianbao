//
//  JHMallNewPeopleGiftTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/1/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMallNewPeopleGiftTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHNewUserRedPacketAlertView.h"
#import "JHAnimatedImageView.h"
@interface JHMallNewPeopleGiftTableViewCell ()

@property (nonatomic, strong) JHAnimatedImageView *giftImageView;

@end

@implementation JHMallNewPeopleGiftTableViewCell

- (void)addSelfSubViews {
    _giftImageView = [JHAnimatedImageView new];
    [self.contentView addSubview:_giftImageView];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([JHMallNewPeopleGiftTableViewCell cellHeight]);
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 0, 12));
    }];
    @weakify(self);
    [_giftImageView jh_addTapGesture:^{
        @strongify(self);
        [self enterWeb];
    }];
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    _giftImageView.backgroundColor = UIColor.clearColor;
}

- (void)setModel:(JHNewUserRedPacketAlertViewSubModel *)model {
    _model = model;
    [self.giftImageView jh_setImageWithUrl:_model.img];
}

- (void)enterWeb {
    [JHGrowingIO trackEventId:@"xr_xq_click" from:@"1"];
    
    NSDictionary *dic2 = @{
                @"page_position":@"直播购物",
                @"model_type":@"新人福利",
                @"button_name":@""
            };
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbgwNewWelfareClick" params:dic2 type:JHStatisticsTypeSensors];
    
    [JHRouterManager pushWebViewWithUrl:self.model.url title:@""];
}

/// cell 高度
+ (CGFloat)cellHeight {
    return (NSInteger)((ScreenW - 24) / 351.0 * 156.0 + 10);
}

@end
