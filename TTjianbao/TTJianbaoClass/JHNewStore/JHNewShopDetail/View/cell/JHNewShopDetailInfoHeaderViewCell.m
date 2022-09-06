//
//  JHNewShopDetailInfoHeaderViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailInfoHeaderViewCell.h"
#import "JHNewShopDetailInfoModel.h"
#import "JHNewShopDetailHeaderViewModel.h"
#import "JHAuthAlertView.h"
#import "JHUserAuthVerificationView.h"
#import "JHWebViewController.h"
#import "JHAnimatedImageView.h"


@interface JHNewShopDetailInfoHeaderItemView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
- (void)setTitleStr:(NSString *)str subtitleStr:(NSString *)subStr;
@end

@implementation JHNewShopDetailInfoHeaderItemView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel               = [[UILabel alloc] init];
    _titleLabel.textColor     = kColor333;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font          = [UIFont fontWithName:kFontBoldDIN size:22.f];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(26.f);
    }];
    
    _subTitleLabel               = [[UILabel alloc] init];
    _subTitleLabel.textColor     = kColor666;
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9.f);
        make.height.mas_equalTo(17.f);
    }];
}

- (void)setTitleStr:(NSString *)str subtitleStr:(NSString *)subStr {
    self.titleLabel.text    = str;
    self.subTitleLabel.text = subStr;
}

@end


@interface JHNewShopDetailInfoHeaderViewCell ()
@property (nonatomic, strong) UIImageView                       *topImageView;
@property (nonatomic, strong) JHAnimatedImageView               *shopHeaderImgView;
@property (nonatomic, strong) UIImageView                       *authTagImageView;
@property (nonatomic, strong) UILabel                           *shopNameLabel;
@property (nonatomic, strong) UIButton                          *followBtn;
@property (nonatomic, strong) UIView                            *couponView;
@property (nonatomic, strong) JHNewShopDetailHeaderViewModel    *shopHeaderViewModel;
@property (nonatomic, strong) NSMutableArray                    *itemViewArray;
@end

@implementation JHNewShopDetailInfoHeaderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (NSMutableArray *)itemViewArray {
    if (!_itemViewArray) {
        _itemViewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemViewArray;
}

- (void)setupUI {
    self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.contentView.layer.cornerRadius = 6.f;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = YES;

    JHAnimatedImageView *shopHeaderImgView = [JHAnimatedImageView jh_imageViewWithImage:kDefaultAvatarImage addToSuperview:self.contentView];
    self.shopHeaderImgView = shopHeaderImgView;
    shopHeaderImgView.backgroundColor = UIColor.blackColor;
    [shopHeaderImgView jh_cornerRadius:54/2 borderColor:UIColor.whiteColor borderWidth:1];
    [shopHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(11.f);
        make.left.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    
    self.shopNameLabel = [[UILabel alloc] init];
    self.shopNameLabel.textColor = kColor333;
    self.shopNameLabel.font = [UIFont fontWithName:kFontMedium size:18];
    [self addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(shopHeaderImgView.mas_right).offset(8);
        make.width.lessThanOrEqualTo(@(144.f));
        make.height.mas_equalTo(25.f);
    }];

    /// 企业认证，个人认证
    UIImageView *authTagImgView = [UIImageView jh_imageViewWithImage:@"" addToSuperview:self];
    authTagImgView.userInteractionEnabled = YES;
    self.authTagImageView = authTagImgView;
    self.authTagImageView.hidden = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__enterAuthentationPage)];
    [authTagImgView addGestureRecognizer:tapGR];
    [authTagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.shopHeaderImgView.mas_bottom).offset(-3.f);
        make.left.equalTo(self.shopNameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(52., 16.));
    }];
    
    
    //关注
    UIButton *followBtn = [UIButton jh_buttonWithImage:@"newStore_attention_yellow_icon" target:self action:@selector(clickAttentionAction:) addToSuperView:self];
    self.followBtn = followBtn;
    [self.followBtn setImage:JHImageNamed(@"newStore_attention_black_icon") forState:UIControlStateSelected];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake(52, 26));
        make.centerY.equalTo(shopHeaderImgView);
    }];
    
    CGFloat itemWidth = (ScreenW - 2.f)/3.f;
    NSArray *subStrArr = @[@"综合评分", @"好评度", @"粉丝数"];
    [self.itemViewArray removeAllObjects];
    for (int i = 0; i < 3; i++) {
        JHNewShopDetailInfoHeaderItemView *itemView = [[JHNewShopDetailInfoHeaderItemView alloc] init];
        [self.contentView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(0+ itemWidth *i);
            make.top.equalTo(self.shopHeaderImgView.mas_bottom).offset(9.f);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(47.f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-11.f);
        }];
        [itemView setTitleStr:@"" subtitleStr:subStrArr[i]];
        if (i<2) {
            UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xF5F5F5) addToSuperview:self.contentView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(itemView.mas_right);
                make.centerY.equalTo(itemView.mas_centerY);
                make.width.mas_equalTo(1.f);
                make.height.mas_equalTo(33.f);
            }];
        }
        [self.itemViewArray addObject:itemView];
    }
}

- (JHNewShopDetailHeaderViewModel *)shopHeaderViewModel {
    if (!_shopHeaderViewModel) {
        _shopHeaderViewModel = [[JHNewShopDetailHeaderViewModel alloc] init];
        @weakify(self)
        [_shopHeaderViewModel.followShopSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            int follow0,follow1;
            if ([self.shopHeaderInfoModel.followed boolValue]) {
                follow0 = 0;
                follow1 = 1;
            } else {
                follow0 = 1;
                follow1 = 0;
            }
            if (self.followBtn.selected) {
                [[UIApplication sharedApplication].keyWindow makeToast:@"取消关注成功~" duration:1.0 position:CSToastPositionCenter];
                self.followBtn.selected = NO;
                NSString *fansNum = [NSString stringWithFormat:@"%d",[self.shopHeaderInfoModel.followNum intValue]-follow1];
                NSString *goodNum = [NSString stringWithFormat:@"%.2f%%",[self.shopHeaderInfoModel.orderGrades doubleValue]*100];
                NSString *allScore = isEmpty(self.shopHeaderInfoModel.comprehensiveScore)?@"0.0":self.shopHeaderInfoModel.comprehensiveScore;
                NSArray *arr = @[allScore,goodNum,fansNum];
                [self changeItemData:arr];
            } else {
                [[UIApplication sharedApplication].keyWindow makeToast:@"关注成功~" duration:1.0 position:CSToastPositionCenter];
                self.followBtn.selected = YES;
                NSString *fansNum = [NSString stringWithFormat:@"%d",[self.shopHeaderInfoModel.followNum intValue]+follow0];
                NSString *goodNum = [NSString stringWithFormat:@"%.2f%%",[self.shopHeaderInfoModel.orderGrades doubleValue]*100];
                NSString *allScore = isEmpty(self.shopHeaderInfoModel.comprehensiveScore)?@"0.0":self.shopHeaderInfoModel.comprehensiveScore;
                NSArray *arr = @[allScore,goodNum,fansNum];
                [self changeItemData:arr];
            }
            if (self.followSuccessBlock){
                self.followSuccessBlock(@(self.followBtn.selected));
            }
        }];
    }
    return _shopHeaderViewModel;
}

- (void)changeItemData:(NSArray <NSString *>*)dataArr {
    NSArray *subStrArr = @[@"综合评分", @"好评度", @"粉丝数"];
    for (int i = 0; i < self.itemViewArray.count; i++) {
        JHNewShopDetailInfoHeaderItemView *itemView = self.itemViewArray[i];
        [itemView setTitleStr:dataArr[i] subtitleStr:subStrArr[i]];
    }
}

#pragma mark - Action
- (void)__enterAuthentationPage {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

///关注店铺
- (void)clickAttentionAction:(UIButton *)sender{
    [JHAllStatistics jh_allStatisticsWithEventId:@"storeOperate" params:@{@"operation_type":(self.followBtn.selected ? @"已关注" : @"关注")} type:JHStatisticsTypeSensors];
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            if (result) {
                [JHNotificationCenter postNotificationName:@"kNewShopLoginSuccess" object:nil];
            }
        }];
    } else {
        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
        dicData[@"shopId"] = @([self.shopHeaderInfoModel.shopId longValue]);
        if (self.followBtn.selected) {
            dicData[@"type"] = @0;
        } else {
            dicData[@"type"] = @1;
        }
        [self.shopHeaderViewModel.followShopCommand execute:dicData];
       
    }
    
}

#pragma mark - loadData
- (void)setShopHeaderInfoModel:(JHNewShopDetailInfoModel *)shopHeaderInfoModel {
    _shopHeaderInfoModel = shopHeaderInfoModel;
    [self.topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(self.height);
    }];

    [self.shopHeaderImgView jh_setImageWithUrl:shopHeaderInfoModel.shopLogoImg
                                   placeholder:@"newStore_default_avatar_placehold"];
    
    self.shopNameLabel.text = shopHeaderInfoModel.shopName;
    
    NSString *goodNum = [NSString stringWithFormat:@"%.2f%%",[shopHeaderInfoModel.orderGrades doubleValue]*100];
    NSString *fansNum = [NSString stringWithFormat:@"%@",shopHeaderInfoModel.followNum];
    NSString *allScore = isEmpty(shopHeaderInfoModel.comprehensiveScore)?@"0.0":shopHeaderInfoModel.comprehensiveScore;
    NSArray *arr = @[allScore,goodNum,fansNum];
    [self changeItemData:arr];
    
    if ([shopHeaderInfoModel.followed boolValue]) {
        self.followBtn.selected = YES;
    } else {
        self.followBtn.selected = NO;
    }

    if (_shopHeaderInfoModel.sellerType > 0) {
        ///372小版本新增
        NSString *authImageName = (_shopHeaderInfoModel.sellerType == JHUserAuthTypePersonal)
        ? @"icon_auth_personal" : @"icon_auth_company";
        self.authTagImageView.image = [UIImage imageNamed:authImageName];
        self.authTagImageView.hidden = NO;
    } else {
        self.authTagImageView.hidden = YES;
    }
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
