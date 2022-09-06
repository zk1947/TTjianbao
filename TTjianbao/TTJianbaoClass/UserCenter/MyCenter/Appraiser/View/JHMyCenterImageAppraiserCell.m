//
//  JHMyCenterImageAppraiserCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterImageAppraiserCell.h"
#import "JHMyCenterDotModel.h"
#import "JHMyCenterButtonModel.h"
#import "JHSwitch.h"

@interface JHMyCenterImageAppraiserCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *secLabel;

@property (nonatomic, strong) JHSwitch  *switchView;

@property (nonatomic, assign) BOOL  switchValue;
@end

@implementation JHMyCenterImageAppraiserCell

-(void)addSelfSubViews
{
    _iconView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    _descLabel = [UILabel jh_labelWithFont:16 textColor:RGB(51, 51, 51) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(10.f);
        make.centerY.equalTo(self.iconView);
    }];
    
    
    
//    UIImageView *pushIcon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_push_gray" addToSuperview:self.contentView];
//    [pushIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-15.f);
//        make.centerY.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(6, 10));
//    }];
    
    self.switchView = [[JHSwitch alloc] init];
    self.switchView.onTintColor= kColorMain;
//    [self.switchView addTarget:self action:@selector(switchViewChange) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-9);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *tapView = [[UIView alloc]init];
    tapView.backgroundColor = [UIColor clearColor];
    [self.switchView addSubview:tapView];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.switchView).offset(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchViewChange)];
    [tapView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
    [tapView addGestureRecognizer:pan];
    
    _secLabel = [UILabel jh_labelWithFont:13 textColor:HEXCOLOR(0x999999) addToSuperView:self.contentView];
    [_secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchView.mas_left).offset(-6.f);
        make.centerY.equalTo(self.iconView);
    }];
}


- (void)setModel:(JHMyCenterButtonModel *)model{
    
    _descLabel.text = model.name;
    _iconView.image = JHImageNamed(model.icon);
    
//    self.switchView.on = [JHMyCenterDotModel shareInstance].imageTextAppraiserSwitch;
    self.switchValue = [JHMyCenterDotModel shareInstance].imageTextAppraiserSwitch;
//    if (self.switchValue) {
//        _secLabel.text = @"已开启";
//    }else{
//        _secLabel.text = @"已关闭";
//    }
}

- (void)panEvent:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state ==UIGestureRecognizerStateEnded) {
        [self switchViewChange];
    }
}

- (void)switchViewChange{
    @weakify(self);
    NSDictionary * dic = @{@"orderReceiveStatus" : @(self.switchValue?0:1)};
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisalImageText/capi/auth/appraisalPersonInfoExt/updateOrderReceiveStatus") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        self.switchValue = !self.switchValue;
//        self.switchView.on = self.switchValue;
//        if (self.switchValue) {
//            self.secLabel.text = @"已开启";
//        }else{
//            self.secLabel.text = @"已关闭";
//        }
        [JHMyCenterDotModel shareInstance].imageTextAppraiserSwitch = self.switchValue?1:0;
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            [SVProgressHUD dismiss];
            [self.contentView makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
}

- (void)setSwitchValue:(BOOL)switchValue{
    _switchValue = switchValue;
    self.switchView.on = _switchValue;
    self.secLabel.text = _switchValue ? @"已开启" : @"已关闭";
}

@end
