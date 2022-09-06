//
//  JHC2CProductDetailHeader.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailHeader.h"
#import "JHC2CProoductDetailModel.h"
#import "JHUserInfoApiManager.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHUserInfoViewController.h"

@interface JHC2CProductDetailHeader()
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UIImageView * realNameImageView;
@property(nonatomic, strong) UILabel * nameLbl;

@property(nonatomic, strong) UIButton * attentionBtn;
@property(nonatomic, strong) UIButton * unAttentionBtn;


@property(nonatomic, strong) NSString * customID;

@end

@implementation JHC2CProductDetailHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 78)];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.iconImageView];
    [self addSubview:self.realNameImageView];
    [self addSubview:self.nameLbl];
    [self addSubview:self.attentionBtn];
    [self addSubview:self.unAttentionBtn];


}

- (void)layoutItems{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 54));
        make.left.equalTo(@0).offset(12);
        make.top.equalTo(@0).offset(16);
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.top.equalTo(@0).offset(20);
        make.right.equalTo(self.attentionBtn.mas_left).offset(-12);
    }];
    [self.realNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 18));
        make.left.equalTo(self.nameLbl);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(6);
    }];
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 28));
        make.right.equalTo(@0).offset(-12);
        make.top.equalTo(@0).offset(29);
    }];
    
    [self.unAttentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(68, 28));
        make.right.equalTo(@0).offset(-12);
        make.top.equalTo(@0).offset(29);
    }];
}

- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
    self.nameLbl.text = model.seller[@"name"] ?  model.seller[@"name"]  : @"未知";
    [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.seller[@"img"]] placeholder:kDefaultAvatarImage];
    self.nameLbl.text = [model.seller[@"name"] isNotBlank] ? model.seller[@"name"]  :@"暂无昵称";
    NSNumber *realName = model.seller[@"isFaceAuth"];
    self.realNameImageView.hidden = !realName.integerValue;
    NSString *userID = UserInfoRequestManager.sharedInstance.user.customerId;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"user_id"] = userID;
    NSNumber *sellerID = model.seller[@"id"];
    dic[@"followed_user_id"] = sellerID.stringValue;
    self.customID = sellerID.stringValue;
    
    if ([self.customID isEqualToString:userID]) {
        self.attentionBtn.hidden = YES;
    }else{
        [JHC2CProductDetailBusiness requestC2CProductBrowse:dic completion:^(NSError * _Nullable error, BOOL isFollow) {
            if (!error) {
                self.attentionBtn.hidden = isFollow;
                self.unAttentionBtn.hidden = !isFollow;
            }
        }];
    }
}

- (void)followActionWithSender:(UIButton*)sender{
    [SVProgressHUD show];
    [self toFollow];
}
- (void)unfollowActionWithSender:(UIButton*)sender{
    [SVProgressHUD show];
    [self toCancelFollow];

}


///关注用户
- (void)toFollow {
    if (![JHRootController isLogin]) {
        @weakify(self);
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            @strongify(self);
            if (result) {
                [JHUserInfoApiManager followUserAction:self.customID fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
                    [SVProgressHUD dismiss];
                    if (!hasError) {
                        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                        self.attentionBtn.hidden = YES;
                        self.unAttentionBtn.hidden = NO;
                    }
                }];
            }
        }];
    }else{
        [JHUserInfoApiManager followUserAction:self.customID fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            [SVProgressHUD dismiss];
            if (!hasError) {
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
                self.attentionBtn.hidden = YES;
                self.unAttentionBtn.hidden = NO;
            }
        }];
    }

}

///取消关注
- (void)toCancelFollow {
    [JHUserInfoApiManager cancelFollowUserAction:self.customID fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [SVProgressHUD dismiss];
        if (!hasError) {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            self.attentionBtn.hidden = NO;
            self.unAttentionBtn.hidden = YES;
        }
    }];
}

/// 点击头像事件
- (void)userIconClickAction {
    JHUserInfoViewController *vc = [[JHUserInfoViewController alloc] init];
    vc.userId = NONNULL_NUM(self.model.seller[@"id"]);
    [self.viewController.navigationController pushViewController:vc animated:true];
}

#pragma mark -- <set and get>

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(16);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"西藏小当家";
        _nameLbl = label;
    }
    return _nameLbl;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 27;
        view.layer.masksToBounds = YES;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconClickAction)];
        [view addGestureRecognizer:tap];
        _iconImageView = view;
    }
    return _iconImageView;
}
- (UIImageView *)realNameImageView{
    if (!_realNameImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_realname"];
        _realNameImageView = view;
    }
    return _realNameImageView;
}

- (UIButton *)attentionBtn{
    if (!_attentionBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_follow_add"] forState:UIControlStateNormal];
        [btn setTitle:@"关注" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(followActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _attentionBtn = btn;
    }
    return _attentionBtn;
}
- (UIButton *)unAttentionBtn{
    if (!_unAttentionBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"已关注" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        btn.backgroundColor = UIColor.whiteColor;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColor.lightGrayColor.CGColor;
        [btn addTarget:self action:@selector(unfollowActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _unAttentionBtn = btn;
        btn.hidden = YES;
        

    }
    return _unAttentionBtn;
}


//- (UIImage *)imageWithTintColor:(UIColor *)tintColor{
//    UIImage *image = [UIImage imageNamed:@"c2c_pd_follow_add"];
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
//    [tintColor setFill];
//    CGRect bounds = CGRectMake(0, 0, 1, 1);
//    UIRectFill(bounds);
//    //Draw the tinted image in context
//    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
//
//    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return tintedImage;
//}
//
@end
