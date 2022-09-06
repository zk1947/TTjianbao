//
//  JHGuideTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGuideTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHGuideModel.h"
#import "TTjianbaoMarco.h"
#import "UIView+JHShadow.h"

@interface JHGuideTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, weak) UIImageView *fireImage;


@end

@implementation JHGuideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGuideModel:(JHGuideModel *)guideModel {
    _guideModel = guideModel;
    if (!_guideModel) {
        return;
    }
    _iconImageView.image = [UIImage imageNamed:_guideModel.iconName];
    _titleLabel.text = _guideModel.title;
    _detailLabel.text = _guideModel.detail;
    _fireImage.hidden = ![_guideModel.title containsString:@"源头"];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        
    }
    return self;
}

- (void)initSubviews {
    UIImageView * backView=[[UIImageView alloc] init];

    backView.backgroundColor = HEXCOLOR(0xFFFCE7);
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@""];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    titleLabel.font = [UIFont fontWithName:kFontMedium size:18];
    titleLabel.textColor = HEXCOLOR(0x333333);

    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"";
    detailLabel.font = [UIFont fontWithName:kFontNormal size:14];
    detailLabel.textColor = HEXCOLOR(0x666666);

    
    _iconImageView = iconImageView;
    _titleLabel = titleLabel;
    _detailLabel = detailLabel;

    [backView addSubview:_iconImageView];
    [backView addSubview:_titleLabel];
    [backView addSubview:_detailLabel];
    
    backView.sd_layout
    .leftSpaceToView(self.contentView, 27)
    .rightSpaceToView(self.contentView, 27)
    .topEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView, 15);
    
    _iconImageView.sd_layout
    .leftSpaceToView(backView, 18)
    .centerYEqualToView(backView)
    .widthIs(34)
    .heightIs(34);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconImageView, 18)
    .topSpaceToView(backView, 20)
    .heightIs(22)
    .autoWidthRatio(0);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:140]; //label横向自适应
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
    }];

    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"store_icon_seller_more_arrow"];
    [backView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-15);
        make.centerY.equalTo(backView);
    }];

    _fireImage = [UIImageView jh_imageViewWithImage:@"common_fire" addToSuperview:self.contentView];
    [_fireImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(11, 13));
    }];
}

- (void)didSelectButtonAction:(UIButton *)sender {
    NSLog(@"=== didSelectButtonAction ===");
    if (self.guideBlock) {
        self.guideBlock(self.guideModel);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
