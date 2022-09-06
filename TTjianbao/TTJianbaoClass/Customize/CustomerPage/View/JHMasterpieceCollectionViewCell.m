//
//  JHMasterpieceCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMasterpieceCollectionViewCell.h"
#import "JHLiveRoomModel.h"
#import "NSObject+Cast.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"

@interface JHMasterpieceCollectionViewCell ()
//@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *reviewStatusView;
@end

@implementation JHMasterpieceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
//    _backView = [[UIView alloc] init];
//    _backView.backgroundColor = self.contentView.backgroundColor;
//    [self.contentView addSubview:_backView];
//    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 8.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.width.height.mas_equalTo(150.f);
    }];
    
    _titleLabel               = [[UILabel alloc] init];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5.f);
        make.height.mas_equalTo(17.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11);
    }];
    
    _reviewStatusView               = [[UILabel alloc] init];
    _reviewStatusView.textColor     = HEXCOLOR(0xFF4200);
    _reviewStatusView.backgroundColor = HEXCOLOR(0xFFEDE7);
    _reviewStatusView.textAlignment = NSTextAlignmentCenter;
    _reviewStatusView.font          = [UIFont fontWithName:kFontNormal size:11.f];
    _reviewStatusView.hidden        = YES;
    [self.contentView addSubview:_reviewStatusView];
    [_reviewStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(26.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHCustomerOpusListInfo *infoModel = [JHCustomerOpusListInfo cast:viewModel];
    if (infoModel) {
        self.titleLabel.text = NONNULL_STR(infoModel.title);
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:infoModel.coverUrl] placeholder:kDefaultCoverImage];
        if (infoModel.status == 2) {
            self.reviewStatusView.hidden = NO;
            self.reviewStatusView.text = @"审核未通过";
        } else {
            self.reviewStatusView.hidden = YES;
        }
    } else {
        self.titleLabel.text = @"";
        self.iconImageView.image = nil;
        self.reviewStatusView.hidden = YES;
    }
}


@end
