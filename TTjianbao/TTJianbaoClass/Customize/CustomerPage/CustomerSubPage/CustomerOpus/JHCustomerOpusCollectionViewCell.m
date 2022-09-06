//
//  JHCustomerOpusCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerOpusCollectionViewCell.h"
#import "JHLiveRoomModel.h"
#import "NSObject+Cast.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"

@interface JHCustomerOpusCollectionViewCell ()
@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView      *contentBackView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *subTitleLabel;

@property (nonatomic, strong) UIView      *statusView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel     *statusLabel;
@end

@implementation JHCustomerOpusCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xF5F6FA);

    _backView                        = [[UIView alloc] init];
    _backView.backgroundColor        = self.contentView.backgroundColor;
    _backView.layer.cornerRadius     = 8.f;
    _backView.layer.masksToBounds    = YES;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    _iconImageView                   = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.backView);
        make.height.mas_equalTo((ScreenWidth - 25.f)/2.f);
    }];

    _contentBackView                 = [[UIView alloc] init];
    _contentBackView.backgroundColor = HEXCOLOR(0xffffff);
    [_backView addSubview:_contentBackView];
    [_contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom);
        make.left.bottom.right.equalTo(self.backView);
    }];

    _titleLabel                      = [[UILabel alloc] init];
    _titleLabel.textColor            = HEXCOLOR(0x333333);
    _titleLabel.textAlignment        = NSTextAlignmentLeft;
    _titleLabel.font                 = [UIFont fontWithName:kFontMedium size:13.f];
    [_contentBackView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBackView.mas_top).offset(10.f);
        make.left.equalTo(self.contentBackView.mas_left).offset(10.f);
        make.right.equalTo(self.contentBackView.mas_right).offset(-10.f);
        make.height.mas_equalTo(19.f);
    }];


    _subTitleLabel                   = [[UILabel alloc] init];
    _subTitleLabel.textColor         = HEXCOLOR(0x666666);
    _subTitleLabel.textAlignment     = NSTextAlignmentLeft;
    _subTitleLabel.font              = [UIFont fontWithName:kFontNormal size:12.f];
    [_contentBackView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.contentBackView.mas_left).offset(10.f);
        make.right.equalTo(self.contentBackView.mas_right).offset(-10.f);
        make.height.mas_equalTo(19.f);
    }];


    _statusView                      = [[UIView alloc] init];
    _statusView.backgroundColor      = HEXCOLORA(0x000000, 0.4f);
    _statusView.layer.cornerRadius   = 10.f;
    _statusView.layer.masksToBounds  = YES;
    [_iconImageView addSubview:_statusView];
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(10.f);
        make.left.equalTo(self.iconImageView.mas_left).offset(10.f);
        make.width.mas_equalTo(61.f);
        make.height.mas_equalTo(20.f);
    }];

    _statusImageView                 = [[UIImageView alloc] init];
    [_statusView addSubview:_statusImageView];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusView.mas_left).offset(5.f);
        make.centerY.equalTo(self.statusView.mas_centerY);
        make.width.height.mas_equalTo(11.8f);
    }];

    _statusLabel                     = [[UILabel alloc] init];
    _statusLabel.textColor           = HEXCOLOR(0xffffff);
    _statusLabel.textAlignment       = NSTextAlignmentLeft;
    _statusLabel.font                = [UIFont fontWithName:kFontNormal size:12.f];
    [_statusView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusView.mas_centerY);
        make.left.equalTo(self.statusImageView.mas_right).offset(3.f);
        make.height.mas_equalTo(18.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHCustomerWorksListInfo *listInfoModel = [JHCustomerWorksListInfo cast:viewModel];
    if (listInfoModel) {
        self.titleLabel.text       = NONNULL_STR(listInfoModel.feeName);
        if (!isEmpty(listInfoModel.anchorName)) {
            self.subTitleLabel.text = [NSString stringWithFormat:@"定制师：%@",listInfoModel.anchorName];
        } else {
            self.subTitleLabel.text = @"";
        }
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:listInfoModel.cover] placeholder:kDefaultCoverImage];
        switch (listInfoModel.status) {
            case JHCustomerWorksListInfoStatus_HasApplicationed: {
                self.statusLabel.hidden = YES;
                self.statusImageView.hidden = YES;
                self.statusView.hidden = YES;
//                self.statusLabel.text = @"已申请";
//                self.statusImageView.image = [UIImage imageNamed:@"icon_draft_edit_selected"];
            }
                break;
            case JHCustomerWorksListInfoStatus_Processing: {
                self.statusLabel.hidden = NO;
                self.statusImageView.hidden = NO;
                self.statusView.hidden = NO;
                
                self.statusLabel.text = @"进行中";
                self.statusImageView.image = [UIImage imageNamed:@"custmoize_ing_logo"];
                
//                [self.statusView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.statusImageView.mas_right).offset(3.f);
//                }];
//                [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.statusView.mas_left).offset(3.f);
//                }];
            }
                break;
            case JHCustomerWorksListInfoStatus_completed: {
                self.statusLabel.hidden = NO;
                self.statusImageView.hidden = NO;
                self.statusView.hidden = NO;

                self.statusLabel.text = @"已完成";
                self.statusImageView.image = [UIImage imageNamed:@"customize_completeIcon"];
                
//                [self.statusView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.width.mas_equalTo(46.f);
//                }];
//                [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self.statusView.mas_left).offset(5.f);
//                }];
                
            }
                break;
            default:
                self.statusLabel.hidden = YES;
                self.statusImageView.hidden = YES;
                self.statusView.hidden = YES;
                self.statusLabel.text = @"";
                self.statusImageView.image = nil;
                break;
        }
    }
}

@end
