//
//  JHCustomerAssoicateBlankCell.m
//  TTjianbao
//
//  Created by lihui on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerAssoicateBlankCell.h"
#import "TTjianbao.h"
#import "UIView+CornerRadius.h"

@interface JHCustomerAssoicateBlankCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *enterLabel;
@property (nonatomic, strong) UIImageView *enterImageView;


@end

@implementation JHCustomerAssoicateBlankCell

- (void)configBlankCell:(NSString *)title {
    if ([title isNotBlank]) {
        _nameLabel.text = title;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [self.contentView addSubview:_bgView];
    [_bgView yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
    
    _circleImageView = ({
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
        [iconImage yd_setCornerRadius:38.f/2 corners:UIRectCornerAllCorners];
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.clipsToBounds = YES;
        iconImage;
    });
    
    _nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"--";
        label.font = [UIFont fontWithName:kFontMedium size:15];
        label;
    });
        
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无关联";
    label.textColor = kColor999;
    label.font = [UIFont fontWithName:kFontMedium size:12];
    _enterLabel = label;
    
    UIImageView *enterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_icon_seller_more_arrow"]];
    enterImage.contentMode = UIViewContentModeScaleAspectFit;
    _enterImageView = enterImage;
    
    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_circleImageView];
    [_bgView addSubview:_nameLabel];
    [_bgView addSubview:_enterLabel];
    [_bgView addSubview:_enterImageView];

    [self makeLayouts];
}

- (void)makeLayouts {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 10, 15));
    }];

    CGFloat iconWidth = 38.f;
    [_circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleImageView.mas_right).offset(10);
        make.centerY.equalTo(self.circleImageView);
        make.width.mas_equalTo(16*11);
    }];

    [_enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.centerY.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [_enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.right.equalTo(self.enterImageView.mas_left).offset(-5);
        make.width.mas_equalTo(50);
    }];
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
