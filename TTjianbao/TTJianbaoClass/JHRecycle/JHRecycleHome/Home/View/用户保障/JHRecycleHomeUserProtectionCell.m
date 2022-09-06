//
//  JHRecycleHomeUserProtectionCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeUserProtectionCell.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHRecycleHomeUserProtectionCell ()
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIButton *titleLabelBtn;

@end

@implementation JHRecycleHomeUserProtectionCell


- (void)configUI{
    [self.backView removeFromSuperview];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backImgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.edges.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.offset((ScreenW-24)*54/351.);
    }];
    
    //图片点击
    @weakify(self)
    [self.backImgView jh_addTapGesture:^{
        @strongify(self)
        [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/security.html") title:@"" controller:JHRootController];
                [JHAllStatistics jh_allStatisticsWithEventId:@"clickUserGuarantee" params:@{
                    @"page_position":@"recycleHome"
                } type:JHStatisticsTypeSensors];
    }];
    
}


- (UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] init];
        _backImgView.contentMode = UIViewContentModeScaleAspectFill;
        _backImgView.image = JHImageNamed(@"recycle_home_userProtection_icon");
    }
    return _backImgView;
}

@end
