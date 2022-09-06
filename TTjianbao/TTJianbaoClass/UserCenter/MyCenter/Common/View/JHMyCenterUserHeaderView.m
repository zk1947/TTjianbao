//
//  JHMyCenterUserHeaderView.m
//  TTjianbao
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHMyCenterMerchantCellModel.h"
#import "JHMyCenterUserHeaderView.h"
#import "UserInfoRequestManager.h"
#import "JHZanHUD.h"
#import "JHStoneResaleViewController.h"

@interface JHMyCenterUserHeaderView ()

@property (nonatomic, weak) UIButton *avatorButton;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *followNumLabel;

@property (nonatomic, weak) UILabel *funsNumLabel;

@property (nonatomic, weak) UILabel *praiseNumLabel;

//@property (nonatomic, weak) UIButton *authButton;

@end

@implementation JHMyCenterUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSelfSubViews];
        
    }
    return self;
}

#pragma mark --------------- method ---------------
- (void)addSelfSubViews
{
    UIImageView *bgImageView = [UIImageView jh_imageViewAddToSuperview:self];
    bgImageView.image = JHImageNamed(@"my_center_home");
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    bgImageView.userInteractionEnabled = YES;
       
    _avatorButton = [UIButton jh_buttonWithTarget:self action:@selector(intoUserInfoAction) addToSuperView:self];
    [_avatorButton jh_cornerRadius:30 borderColor:UIColor.whiteColor borderWidth:1];
    [_avatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:18 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:self];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorButton.mas_right).offset(10);
        make.centerY.equalTo(self.avatorButton);
        make.width.mas_equalTo(162.f);
    }];
    
//MARK: v370新商城 去掉了商家认证
//    _authButton = [UIButton jh_buttonWithImage:@"icon_my_unident" target:self action:@selector(authAction) addToSuperView:self];
//    [_authButton setImage:JHImageNamed(@"icon_my_idented") forState:UIControlStateSelected];
//    [_authButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
//        make.left.equalTo(self.nameLabel);
//        make.size.mas_equalTo(CGSizeMake(49, 15));
//    }];
    
    _followNumLabel = [UILabel jh_labelWithBoldFont:18 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self];
    [_followNumLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followAction)]];
    _followNumLabel.userInteractionEnabled = YES;
    _funsNumLabel = [UILabel jh_labelWithBoldFont:18 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self];
    [_funsNumLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(funsAction)]];
    _funsNumLabel.userInteractionEnabled = YES;
    _praiseNumLabel = [UILabel jh_labelWithBoldFont:18 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self];
    [_praiseNumLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseAction)]];
    _praiseNumLabel.userInteractionEnabled = YES;
    NSArray *viewArray = @[_followNumLabel, _funsNumLabel, _praiseNumLabel];
    
    [viewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:3 tailSpacing:3];
    [viewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorButton.mas_bottom).offset(4);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *tipLabel1 = [UILabel jh_labelWithText:@"关注" font:12 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self];
    
    UILabel *tipLabel2 = [UILabel jh_labelWithText:@"粉丝" font:12 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self];
    
    UILabel *tipLabel3 = [UILabel jh_labelWithText:@"获赞" font:12 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self];
    
    NSArray *tipViewArray = @[tipLabel1, tipLabel2, tipLabel3];
    
    [tipViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:3 tailSpacing:3];
    [tipViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.praiseNumLabel.mas_bottom);
    }];
    
    [self reload];
}

- (void)followAction{
    User *user = [UserInfoRequestManager sharedInstance].user;
    [JHRouterManager pushUserFriendWithController:JHRouterManager.jh_getViewController type:1 userId:user.customerId.integerValue name:user.name];
}

- (void)funsAction{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    [JHRouterManager pushUserFriendWithController:JHRouterManager.jh_getViewController type:2 userId:user.customerId.integerValue name:user.name];
}

- (void)praiseAction{
    [JHZanHUD showText:[NSString stringWithFormat:@"\"%@\"共获得%ld个赞",
    [UserInfoRequestManager sharedInstance].user.name,
    (long)[UserInfoRequestManager sharedInstance].levelModel.like_num]];
}

//MARK: v370新商城 去掉了商家认证
//- (void)authAction{
//    [JHMyCenterMerchantCellButtonModel pushSocialAuthViewController];
//}

- (void)reload{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    JHUserLevelInfoMode *levelModel = [UserInfoRequestManager sharedInstance].levelModel;
    
    [_avatorButton jh_setAvatorWithUrl:user.icon];
    
    _nameLabel.text = user.name;
    
    _followNumLabel.text = OBJ_TO_STRING(@(levelModel.follow_num));
    
    _funsNumLabel.text = OBJ_TO_STRING(@(levelModel.fans_num));
    
    _praiseNumLabel.text = OBJ_TO_STRING(@(levelModel.like_num));
    
//MARK: v370新商城 去掉了商家认证
//    CGFloat centerY = 0.f;
//
//    if(user.type == blRole_communityShop){
//        JHUserLevelInfoMode *model = [UserInfoRequestManager sharedInstance].levelModel;
//        _authButton.selected = (model.sign.sign_type == 1);
//        centerY = -10.f;
//    }
//    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.avatorButton).offset(centerY);
//    }];
//
//    _authButton.hidden = (!user.blRole_communityShop);
}

+ (CGFloat)viewHeight
{
    return 237.f + UI.statusAndNavBarHeight;
}

+ (CGFloat)viewBottom
{
    return 108.f;
}

#pragma mark --------------- action ---------------
- (void)intoUserInfoAction
{
    [JHRouterManager pushMyUserInfoController];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
