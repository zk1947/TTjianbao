//
//  JHPostDtailEnterTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDtailEnterTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "UIView+CornerRadius.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"
#import "UIButton+ImageTitleSpacing.h"

#define iconWidth 34.f
#define iconBorderWidth 38.f

@interface JHPostDtailEnterTableCell ()

@property (nonatomic, strong) UIView *bgView;
///店铺直播间相关
@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UIImageView *iconBorderImageView;
@property (nonatomic, strong) UIImageView *livingGifView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *enterView;
@property (nonatomic, strong) UILabel *enterLabel;
@property (nonatomic, strong) UIImageView *enterImageView;
@property (nonatomic, strong) JHPostDetailModel *detailModel;

@end

@implementation JHPostDtailEnterTableCell

//JHAnchorLiveState
- (void)setIcon:(NSString *)icon
           name:(NSString *)name
           desc:(NSString *)desc
      liveState:(JHAnchorLiveState)state
           type:(JHDetailEnterType)type {

    NSString *enterTitle = nil;
    CGSize iconSize = CGSizeZero;
    BOOL showLiving = NO;
    if (type == JHDetailEnterTypeShop) {
        iconSize = CGSizeMake(iconBorderWidth, iconBorderWidth);
        enterTitle = @"进店铺";
        showLiving = NO;
    }
    else {
        BOOL isLiving = (state == JHAnchorLiveStatePlaying);
        CGFloat width = isLiving ? iconWidth : iconBorderWidth;
        iconSize = CGSizeMake(width, width);
        enterTitle = isLiving? @"进直播间" : @"休息中";
        showLiving = isLiving;
    }
    
    ///头像
    [_circleImageView jhSetImageWithURL:[NSURL URLWithString:icon] placeholder:kDefaultAvatarImage];
    _nameLabel.text = [name isNotBlank] ? name : @"暂无名称";
    _detailLabel.text = [desc isNotBlank] ? desc : @"暂无描述";
    _enterLabel.text = enterTitle;
    _iconBorderImageView.hidden = !showLiving;
    _livingGifView.hidden = !showLiving;
    [_circleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(iconSize);
    }];
    
    [self layoutIfNeeded];
    [_circleImageView yd_setCornerRadius:self.circleImageView.height/2 corners:UIRectCornerAllCorners];
}

- (void)setDetailModel:(JHPostDetailModel *)detailModel SectionType:(JHPostDetailSectionType)type {
    if (!detailModel) {
        return;
    }
    
    _detailModel = detailModel;
    
    NSString *icon = nil;
    NSString *title = nil;
    NSString *detail = nil;
    NSString *enterTitle = nil;
    if (type == JHPostDetailSectionTypeShop) {
        icon = _detailModel.shopInfo.head_img;
        title = _detailModel.shopInfo.name;
        detail = [NSString stringWithFormat:@"共%ld件商品", (long)[_detailModel.shopInfo.publish_num integerValue]];
        enterTitle = @"进店铺";
        _iconBorderImageView.hidden = YES;
        _livingGifView.hidden = YES;
        [_circleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(iconBorderWidth, iconBorderWidth));
        }];
    }
    else {
        icon = _detailModel.archorInfo.head_img;
        title = _detailModel.archorInfo.live_name;
        detail = [NSString stringWithFormat:@"共%ld热度", (long)_detailModel.archorInfo.watching_num];
        enterTitle = _detailModel.archorInfo.status > 0 ? @"进直播间" : @"休息中";
        _iconBorderImageView.hidden = !_detailModel.archorInfo.status;
        _livingGifView.hidden = !_detailModel.archorInfo.status;
        if (_detailModel.archorInfo.status > 0) {
            [_circleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
            }];
        }
        else {
            [_circleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(iconBorderWidth, iconBorderWidth));
            }];
        }
    }
    [_circleImageView jhSetImageWithURL:[NSURL URLWithString:icon] placeholder:kDefaultAvatarImage];
    _nameLabel.text = [title isNotBlank] ? title : @"暂无名称";
    _detailLabel.text = [detail isNotBlank]?detail : @"暂无描述";
    _enterLabel.text = enterTitle;
    
    [self layoutIfNeeded];
    [_circleImageView yd_setCornerRadius:self.circleImageView.height/2 corners:UIRectCornerAllCorners];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configViews];
    }
    return self;
}

- (void)configViews {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [self.contentView addSubview:_bgView];
    [_bgView yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
    
    ///直播间和店铺相关
    _iconBackView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HEXCOLOR(0xffffff);
        view;
    });
    
    _circleImageView = ({
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.clipsToBounds = YES;
        iconImage;
    });
    
    _nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无昵称";
        label.font = [UIFont fontWithName:kFontMedium size:15];
        label;
    });
    
    _detailLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"共0件商品";
        label.font = [UIFont fontWithName:kFontNormal size:11];
        label.textColor = kColor999;
        label;
    });
    
    [_bgView addSubview:_iconBackView];
    [_bgView addSubview:_circleImageView];
    [_bgView addSubview:_nameLabel];
    [_bgView addSubview:_detailLabel];
    [_bgView addSubview:self.iconBorderImageView];
    [_bgView addSubview:self.livingGifView];

    UIView *enterView = [[UIView alloc] init];
    [_bgView addSubview:enterView];
    _enterView = enterView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"进店铺";
    label.textColor = HEXCOLOR(0xFE9100);
    label.font = [UIFont fontWithName:kFontMedium size:12];
    [_enterView addSubview:label];
    _enterLabel = label;
    
    UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user_info_arrow_orange"]];
    enterImage.contentMode = UIViewContentModeScaleAspectFit;
    [_enterView addSubview:enterImage];
    _enterImageView = enterImage;
    
    [self makeLayouts];
}

- (void)makeLayouts {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 10, 15));
    }];

    [_enterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.top.bottom.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView);
    }];
    [_enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.enterView).offset(-10);
        make.centerY.equalTo(self.enterView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [_enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.enterView);
        make.left.equalTo(self.enterView).offset(10);
        make.right.equalTo(self.enterImageView.mas_left).offset(-5);
    }];
    
    [_circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(iconBorderWidth, iconBorderWidth));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleImageView.mas_right).offset(10);
        make.top.equalTo(self.circleImageView);
        make.width.mas_equalTo(16*11);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.circleImageView);
        make.right.equalTo(self.nameLabel);
    }];
    
    [_iconBorderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconBorderWidth, iconBorderWidth));
        make.centerX.equalTo(self.circleImageView);
        make.centerY.equalTo(self.circleImageView);
    }];
    
    [_livingGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconBorderImageView);
        make.bottom.equalTo(self.iconBorderImageView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self layoutIfNeeded];
    [_circleImageView yd_setCornerRadius:self.circleImageView.height/2 corners:UIRectCornerAllCorners];
}

- (UIImageView *)iconBorderImageView {
    if (!_iconBorderImageView) {
        _iconBorderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
        _iconBorderImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconBorderImageView];
        _iconBorderImageView.hidden = YES;
    }
    return _iconBorderImageView;
}

- (UIImageView *)livingGifView {
    if (!_livingGifView) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        YYImage *image = [YYImage imageWithData:data];
        _livingGifView = [[YYAnimatedImageView alloc] initWithImage:image];
        _livingGifView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_livingGifView];
        _livingGifView.hidden = YES;
    }
    return _livingGifView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
