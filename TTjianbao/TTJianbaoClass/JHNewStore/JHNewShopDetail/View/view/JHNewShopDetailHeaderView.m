//
//  JHNewShopDetailHeaderView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//


#import "JHNewShopDetailHeaderView.h"
#import "JHNewShopCouponView.h"
#import "JHNewShopDetailInfoModel.h"
#import "JHNewShopDetailHeaderViewModel.h"
#import "JHCompanyAuthenticationController.h"
#import <UIImage+webP.h>
#import "JHAnimatedImageView.h"

@interface JHNewShopDetailHeaderView ()
@property (nonatomic, weak) UIImageView *pullLoadingView;
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) JHAnimatedImageView *shopHeaderImgView;
@property (nonatomic, strong) UIImageView *authTagImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) JHNewShopCouponView *couponCollectionView;
@property (nonatomic, strong) JHNewShopDetailHeaderViewModel *shopHeaderViewModel;
@property (nonatomic, strong) UIImageView *nameRightImgView;
@property (nonatomic, strong) UILabel *scoreLabel;//综合评分
@property (nonatomic, strong) UILabel *praiseLabel;//好评度
@property (nonatomic, strong) UILabel *fansLabel;//粉丝数


@end

@implementation JHNewShopDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)addSelfSubViews{
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self);
        make.height.mas_offset(self.height);
    }];
    
    UIView *bottomRoundView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenW, 10) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    bottomRoundView.layer.mask = maskLayer;
    [bottomRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(10);
    }];
    
    //优惠券
    [self addSubview:self.couponView];
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    //综合评分 等
    UIView *numberView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_offset(42);
        make.bottom.equalTo(self.couponView.mas_top).offset(-11);
    }];
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0x999999) addToSuperview:numberView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(numberView);
            make.size.mas_offset(CGSizeMake(1, 30));
            make.centerX.equalTo(numberView).offset(-ScreenWidth/6 + i*2*ScreenWidth/6);
        }];
    }
    NSArray *titleArray = @[@"综合评分",@"好评度",@"粉丝数"];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *titleLabel = [UILabel jh_labelWithFont:10.8 textColor:HEXCOLOR(0xFFFFFF) addToSuperView:numberView];
        titleLabel.text = titleArray[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(numberView);
            make.centerX.equalTo(numberView).offset(-ScreenWidth/3 + i*ScreenWidth/3);
        }];
    }
    [numberView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView);
        make.centerX.equalTo(numberView).offset(-ScreenWidth/3);
    }];
    [numberView addSubview:self.praiseLabel];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView);
        make.centerX.equalTo(numberView).offset(0);
    }];
    [numberView addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberView);
        make.centerX.equalTo(numberView).offset(ScreenWidth/3);
    }];
    
    [self addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self).offset(-90);
        make.bottom.equalTo(numberView.mas_top).offset(-10);
        make.height.mas_equalTo(55);
    }];
    //店铺头像
    [self.userView addSubview:self.shopHeaderImgView];
    [self.shopHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userView).offset(12);
        make.centerY.equalTo(self.userView);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    //店铺名称
    [self.userView addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopHeaderImgView.mas_top).offset(4);
        make.left.equalTo(self.shopHeaderImgView.mas_right).offset(10);
    }];
    [self.userView addSubview:self.nameRightImgView];
    [self.nameRightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopNameLabel);
        make.left.equalTo(self.shopNameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    //企业认证
    [self.userView addSubview:self.authTagImageView];
    [self.authTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.shopNameLabel);
        make.size.mas_equalTo(CGSizeMake(52., 16.));
    }];
    
    //关注
    [self addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake(52, 26));
        make.centerY.equalTo(self.shopHeaderImgView);
    }];
}


#pragma mark - loadData
- (void)setShopHeaderInfoModel:(JHNewShopDetailInfoModel *)shopHeaderInfoModel{
    _shopHeaderInfoModel = shopHeaderInfoModel;
///新商城第一版店铺背景图展示写死 ---hzp
//    NSString *bgImagUrl = [shopHeaderInfoModel.shopBgImg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
//    [self.topImageView jh_setImageWithUrl:bgImagUrl placeHolder:@"cover_default_image"];
    
    [self.topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(self.height);
    }];
        
    [self.shopHeaderImgView jh_setImageWithUrl:shopHeaderInfoModel.shopLogoImg placeholder:@"newStore_default_avatar_placehold"];
    
    self.shopNameLabel.text = shopHeaderInfoModel.shopName;
    self.nameRightImgView.hidden = NO;
    CGSize nameSize = [self.shopNameLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:self.shopNameLabel.font} context:nil].size;
    if (nameSize.width >= ScreenWidth-170) {
        [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopHeaderImgView.mas_top).offset(4);
            make.left.equalTo(self.shopHeaderImgView.mas_right).offset(8);
            make.right.equalTo(self.userView).offset(-13);
        }];
    } else {
        [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopHeaderImgView.mas_top).offset(4);
            make.left.equalTo(self.shopHeaderImgView.mas_right).offset(8);
        }];
    }
    self.scoreLabel.text = shopHeaderInfoModel.comprehensiveScore;
    self.fansLabel.text = shopHeaderInfoModel.followNum;
    self.praiseLabel.text = [NSString stringWithFormat:@"%.2f%%",[shopHeaderInfoModel.orderGrades doubleValue]*100];

    self.praiseLabel.attributedText = [self getAcolorfulStringWithSpecialText:@"%" specialColor:HEXCOLOR(0xFFFFFF) specialFont:[UIFont fontWithName:kFontBoldDIN size:11.7] AllText:self.praiseLabel.text];

    
    if ([shopHeaderInfoModel.followed boolValue]) {
        self.followBtn.selected = YES;
    }else{
        self.followBtn.selected = NO;
    }
    
    //店铺优惠券
    [self.couponCollectionView removeFromSuperview];
    if (shopHeaderInfoModel.couponList.count > 0) {
        [self.couponView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(42);
            make.bottom.equalTo(self.mas_bottom).offset(-22);
        }];
        [self.couponView addSubview:self.couponCollectionView];
        //优惠券列表传值
        self.couponCollectionView.couponListArray = shopHeaderInfoModel.couponList;

    }else{
        [self.couponView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
    }
    
    if (_shopHeaderInfoModel.sellerType > 0) {
        ///372小版本新增
        NSString *authImageName = (_shopHeaderInfoModel.sellerType == JHUserAuthTypePersonal)
        ? @"icon_auth_personal" : @"icon_auth_company";
        self.authTagImageView.image = [UIImage imageNamed:authImageName];
        self.authTagImageView.hidden = NO;
    }
    else {
        self.authTagImageView.hidden = YES;
    }
}

#pragma mark - Action
///点击店铺信息
- (void)clickUserViewAction{
    if (self.clickShopInfoBlock) {
        self.clickShopInfoBlock();
    }
}

///关注店铺
- (void)clickAttentionAction:(UIButton *)sender{
    [JHAllStatistics jh_allStatisticsWithEventId:@"storeOperate" params:@{@"operation_type":(self.followBtn.selected ? @"取消关注" : @"关注")} type:JHStatisticsTypeSensors];
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            if (result) {
                [JHNotificationCenter postNotificationName:@"kNewShopLoginSuccess" object:nil];
            }
        }];
    }else{
        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
        dicData[@"shopId"] = @([self.shopHeaderInfoModel.shopId longValue]);
        if (self.followBtn.selected) {
            dicData[@"type"] = @0;
        }else{
            dicData[@"type"] = @1;
        }
        [self.shopHeaderViewModel.followShopCommand execute:dicData];
    }
}

#pragma mark - method

- (void)updateImageHeight:(float)height{
    if(height >= 0){
        [self.topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.height + height);
        }];
    }
}

- (void)showLoading{
    if(!self.pullLoadingView){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pull_loading" ofType:@"webp"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
        self.pullLoadingView = [UIImageView jh_imageViewWithImage:webpImage addToSuperview:self.topImageView];
        [self.pullLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topImageView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
}

- (void)dismissLoading{
    if(self.pullLoadingView){
        [self.pullLoadingView removeFromSuperview];
        self.pullLoadingView = nil;
    }
}

- (void)setIsFollowed:(BOOL)isFollowed{
    _isFollowed = isFollowed;
    if (isFollowed) {
        self.followBtn.selected = YES;
    }else{
        self.followBtn.selected = NO;
    }
    //关注数量更新
    if (isFollowed) {
        self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.shopHeaderInfoModel.followNum intValue]+1];
    }else{
        self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.shopHeaderInfoModel.followNum intValue]-1];
    }
    //动态修改关注状态
    self.shopHeaderInfoModel.followed = isFollowed ? @"1" : @"0";
    self.shopHeaderInfoModel.followNum = self.fansLabel.text;
}

#pragma mark - Lazy
- (JHNewShopDetailHeaderViewModel *)shopHeaderViewModel{
    if (!_shopHeaderViewModel) {
        _shopHeaderViewModel = [[JHNewShopDetailHeaderViewModel alloc] init];
        @weakify(self)
        [_shopHeaderViewModel.followShopSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if (self.followBtn.selected) {
                [JHKeyWindow makeToast:@"取消关注成功~" duration:1.0 position:CSToastPositionCenter];
                self.followBtn.selected = NO;
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.shopHeaderInfoModel.followNum intValue]-1];

            }else{
                [JHKeyWindow makeToast:@"关注成功~" duration:1.0 position:CSToastPositionCenter];
                self.followBtn.selected = YES;
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.shopHeaderInfoModel.followNum intValue]+1];
            }
            //动态修改关注状态
            self.shopHeaderInfoModel.followed = self.followBtn.selected ? @"1" : @"0";
            self.shopHeaderInfoModel.followNum = self.fansLabel.text;
            
            if(self.followSuccessBlock){
                self.followSuccessBlock(@(self.followBtn.selected));
            }
            
        }];
    }
    return _shopHeaderViewModel;
}
- (UIView *)userView{
    if (!_userView) {
        _userView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserViewAction)];
        [_userView addGestureRecognizer:tapGR];
    }
    return _userView;
}
- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = JHImageNamed(@"newStore_shopHeader_default_bg");
    }
    return _topImageView;
}

- (UIView *)couponView{
    if (!_couponView) {
        _couponView = [[UIView alloc] init];
    }
    return _couponView;
}
- (JHAnimatedImageView *)shopHeaderImgView{
    if (!_shopHeaderImgView) {
        _shopHeaderImgView = [[JHAnimatedImageView alloc] init];
        _shopHeaderImgView.image = JHImageNamed(@"newStore_default_avatar_placehold");
        [_shopHeaderImgView jh_cornerRadius:54/2 borderColor:HEXCOLORA(0xFFFFFF, 0.8) borderWidth:1];
    }
    return _shopHeaderImgView;
}
- (UILabel *)shopNameLabel{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.textColor = kColorFFF;
        _shopNameLabel.font = [UIFont fontWithName:kFontMedium size:18];
    }
    return _shopNameLabel;
}
- (UIImageView *)nameRightImgView{
    if (!_nameRightImgView) {
        _nameRightImgView = [[UIImageView alloc] init];
        _nameRightImgView.image = JHImageNamed(@"newStore_shopDetail_right_icon");
        _nameRightImgView.hidden = YES;
    }
    return _nameRightImgView;
}
- (UIImageView *)authTagImageView{
    if (!_authTagImageView) {
        _authTagImageView = [[UIImageView alloc] init];
        _authTagImageView.hidden = YES;
    }
    return _authTagImageView;
}
- (UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setImage:JHImageNamed(@"newStore_attention_yellow_icon") forState:UIControlStateNormal];
        [_followBtn setImage:JHImageNamed(@"newStore_attention_white_icon") forState:UIControlStateSelected];
        [_followBtn addTarget:self action:@selector(clickAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}
- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = HEXCOLOR(0xFFFFFF);
        _scoreLabel.font = [UIFont fontWithName:kFontBoldDIN size:19.8];
    }
    return _scoreLabel;
}
- (UILabel *)praiseLabel{
    if (!_praiseLabel) {
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.textColor = HEXCOLOR(0xFFFFFF);
        _praiseLabel.font = [UIFont fontWithName:kFontBoldDIN size:19.8];
    }
    return _praiseLabel;
}
- (UILabel *)fansLabel{
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textColor = HEXCOLOR(0xFFFFFF);
        _fansLabel.font = [UIFont fontWithName:kFontBoldDIN size:19.8];
    }
    return _fansLabel;
}

- (JHNewShopCouponView *)couponCollectionView{
    if (!_couponCollectionView) {
        _couponCollectionView = [[JHNewShopCouponView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 42)];
    }
    return _couponCollectionView;
}

- (NSMutableAttributedString *)getAcolorfulStringWithSpecialText:(NSString *)text specialColor:(UIColor *)color specialFont:(UIFont *)font AllText:(NSString *)allText{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text) {
        NSRange range1 = [allText rangeOfString:text];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color range:range1];
        if (font) {
            [str addAttribute:NSFontAttributeName value:font range:range1];
        }
    }
    [str endEditing];
    return str;
}
@end
