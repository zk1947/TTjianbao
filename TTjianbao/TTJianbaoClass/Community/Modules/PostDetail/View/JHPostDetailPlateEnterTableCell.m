//
//  JHPostDetailPlateEnterTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailPlateEnterTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "UIView+CornerRadius.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHPostDetailPlateEnterTableCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *plateImageView;
///方形的图标
@property (nonatomic, strong) UILabel *plateNameLabel;
@property (nonatomic, strong) UILabel *plateDetailLabel;
@property (nonatomic, strong) UIView *enterView;
@property (nonatomic, strong) UILabel *enterLabel;
@property (nonatomic, strong) UIImageView *enterImageView;

@end


@implementation JHPostDetailPlateEnterTableCell

- (void)setDetailModel:(JHPostDetailModel *)detailModel {
    if (!detailModel) {
        return;
    }
    
    _detailModel = detailModel;
    
    [_plateImageView jhSetImageWithURL:[NSURL URLWithString:_detailModel.plateInfo.image] placeholder:kDefaultCoverImage];
    _plateNameLabel.text = [_detailModel.plateInfo.name isNotBlank] ? _detailModel.plateInfo.name : @"暂无名称";
    NSString *str = [NSString stringWithFormat:@"%ld位宝友加入 · %ld篇内容", (long)_detailModel.plateInfo.join_num, (long)_detailModel.plateInfo.post_num];
    _plateDetailLabel.text = str;
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
        
    ///板块的图标
    _plateImageView = ({
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.clipsToBounds = YES;
        iconImage;
    });
        
    _plateNameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"琥珀蜜蜡";
        label.font = [UIFont fontWithName:kFontMedium size:15];
        label;
    });

    _plateDetailLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"389位宝友加入 · 8182片内容";
        label.font = [UIFont fontWithName:kFontNormal size:11];
        label.textColor = kColor999;
        label;
    });
    
    [_bgView addSubview:_plateImageView];
    [_bgView addSubview:_plateNameLabel];
    [_bgView addSubview:_plateDetailLabel];

    UIView *enterView = [[UIView alloc] init];
    [_bgView addSubview:enterView];
    _enterView = enterView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"进版块";
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
    
    [_plateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    [_plateNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.plateImageView.mas_right).offset(10);
        make.top.equalTo(self.plateImageView).offset(9);
        make.width.mas_equalTo(16*11);
    }];
    
    [_plateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.plateNameLabel);
        make.bottom.equalTo(self.plateImageView).offset(-8);
        make.right.equalTo(self.plateNameLabel);
    }];
    
    [self layoutIfNeeded];
    [_plateImageView yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
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
