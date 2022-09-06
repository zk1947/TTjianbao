//
//  JHRecyclingMoneyLayer.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclingMoneyLayer.h"
#import "JHRecycleUploadTypeSeleteViewController.h"

@implementation JHRecyclingMoneyLayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLORA(0x000000, 0.72f);
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"卖钱币" forState:UIControlStateNormal];
    [loginBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.f];
    [loginBtn addTarget:self action:@selector(recyclingMoeneyAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = HEXCOLOR(0xFFD70F);
    loginBtn.layer.cornerRadius  = 4.f;
    loginBtn.layer.masksToBounds = YES;
    [self addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-12.f);
        make.width.mas_equalTo(77.f);
        make.height.mas_equalTo(31.f);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HEXCOLOR(0xFFFFFF);
    titleLabel.font = [UIFont fontWithName:kFontMedium size:14.f];
    titleLabel.text = @"天天回收";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(loginBtn.mas_top).mas_offset(-3.f);
        make.height.mas_equalTo(20.f);
    }];
    
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = HEXCOLORA(0xFFFFFF,0.85f);
    subTitleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    subTitleLabel.text = @"发布宝贝，确认报价，顺丰取件，快速回款";
    [self addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.bottom.mas_equalTo(loginBtn.mas_bottom).mas_offset(3.f);;
        make.height.mas_equalTo(16.f);
    }];

}

- (void)recyclingMoeneyAction:(UIButton *)sender {
    NSString *contentTypeStr = @"";
    switch (self.detailModel.item_type) {
        case JHPostItemTypeDynamic: { ///动态
            contentTypeStr= @"动态";
        }
            break;
        case JHPostItemTypePost: { ///长文章
            contentTypeStr = @"文章";
        }
            break;
        case JHPostItemTypeVideo: { ///小视频
            contentTypeStr = @"小视频";
        }
            break;
        default:
            break;
    }
    NSDictionary *par1 = @{
        @"position":@"floatingLayer",
        @"content_id":NONNULL_STR(self.detailModel.item_id),
        @"content_name":NONNULL_STR(self.detailModel.title),
        @"content_type":NONNULL_STR(contentTypeStr),
        @"source_module":NONNULL_STR(self.detailModel.source),
        @"page_position":@"communityDetails",
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickCoinRecycling"
                                          params:par1
                                            type:JHStatisticsTypeSensors];
    // 回收发布界面
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) { }];
    }else{
        JHRecycleUploadTypeSeleteViewController *releaseVC = [[JHRecycleUploadTypeSeleteViewController alloc] init];
        [JHRootController.currentViewController.navigationController pushViewController:releaseVC animated:YES];
    }
}

@end
