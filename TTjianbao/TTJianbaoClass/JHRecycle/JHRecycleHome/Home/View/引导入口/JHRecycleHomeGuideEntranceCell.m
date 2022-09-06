//
//  JHRecycleHomeGuideEntranceCell.m
//  TTjianbao
//
//  Created by jiangchao on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGuideEntranceCell.h"
#import "JHRecycleHomeModel.h"
#import "JHRecycleItemViewModel.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHWebViewController.h"
#import "JHRecycleSquareHomeViewController.h"

@interface JHRecycleHomeGuideEntranceCell ()
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) JHHomeOperatingPositionModel *positionModel;


@end

@implementation JHRecycleHomeGuideEntranceCell

- (void)configUI{

    self.backView.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:self.leftImgView];
    [self.backView addSubview:self.rightImgView];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backView);
        make.left.equalTo(self.backView).offset(10);
       // make.width.offset((ScreenW-24-10)/2.);
        make.width.equalTo(self.rightImgView);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-10);
        make.left.equalTo(self.leftImgView.mas_right).offset(10);
        make.width.equalTo(self.leftImgView);
    }];
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"新手指引" forState:UIControlStateNormal];
    [leftButton setTitleColor:HEXCOLOR(0x59401E) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:16];
    [leftButton setImage:[UIImage imageNamed:@"guideentrance_arrow"] forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    leftButton.userInteractionEnabled = NO;
    [self.leftImgView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImgView);
        make.left.equalTo(self.leftImgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"成为回收商" forState:UIControlStateNormal];
    [rightButton setTitleColor:HEXCOLOR(0x59401E) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:16];
    [rightButton setImage:[UIImage imageNamed:@"guideentrance_arrow"] forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
    rightButton.userInteractionEnabled = NO;
    [self.rightImgView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightImgView);
        make.left.equalTo(self.rightImgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    //图片点击
//    @weakify(self)
    [self.leftImgView jh_addTapGesture:^{
//        @strongify(self)
        [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/security.html") title:@"" controller:JHRootController];
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickNoviceGuide" params:@{
            @"page_position":@"天天回收首页"
        } type:JHStatisticsTypeSensors];
        
    }];

    //图片点击
    [self.rightImgView jh_addTapGesture:^{
//        @strongify(self)
        /// 已开通店铺的去回收广场
        User *user = [UserInfoRequestManager sharedInstance].user;
        if ([JHRootController isLogin] && user.blRole_recycleBusiness ) {
            JHRecycleSquareHomeViewController *vc = [[JHRecycleSquareHomeViewController alloc] init];
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        } else {
            [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/applyOpenShop.html") title:@"" controller:JHRootController];
        }
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickToBeRecycler" params:@{
            @"page_position":@"天天回收首页"
        } type:JHStatisticsTypeSensors];
        
    }];
   
}

- (void)bindViewModel:(id)dataModel{
//    JHRecycleItemViewModel *itemViewModel = dataModel;
//    self.positionModel = itemViewModel.dataModel;
//
//    [self.leftImgView jh_setImageWithUrl:self.positionModel.imageUrl placeHolder:@"newStore_default_placehold"];


}


- (UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideentrance_icon_left"]];
        _leftImgView.backgroundColor = UIColor.clearColor;
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _leftImgView;
}
- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideentrance_icon_right"]];
        _rightImgView.backgroundColor = UIColor.clearColor;
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _rightImgView;
}
@end
