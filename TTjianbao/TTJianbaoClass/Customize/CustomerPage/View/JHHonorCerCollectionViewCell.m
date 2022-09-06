//
//  JHHonorCerCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonorCerCollectionViewCell.h"
#import "JHLiveRoomModel.h"
#import "NSObject+Cast.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@interface JHHonorCerCollectionViewCell ()
@property (nonatomic, strong) UILabel     *reviewStatusView;
@end

@implementation JHHonorCerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
//    self.contentView.layer.cornerRadius = 8.f;
//    self.contentView.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 8.f;
//    self.layer.masksToBounds = YES;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(111.5f);
    }];
    
    _watermarkImageView = [[UIImageView alloc] init];
    _watermarkImageView.contentMode = UIViewContentModeScaleAspectFill;
    _watermarkImageView.image = [UIImage imageNamed:@"customize_watermark"];
    [_iconImageView addSubview:_watermarkImageView];
    [_watermarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconImageView);
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
    _iconImageView.layer.cornerRadius = 8.f;
    _iconImageView.layer.masksToBounds = YES;
    _watermarkImageView.layer.cornerRadius  = 8.f;
    _watermarkImageView.layer.masksToBounds = YES;
}

- (void)setCornerOnTop {
    
}

- (void)setViewModel:(id)viewModel {
    JHCustomerCertificateListInfo *infoModel = [JHCustomerCertificateListInfo cast:viewModel];
    if (infoModel) {
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:infoModel.img] placeholder:kDefaultCoverImage];
        if (infoModel.status == 2) {
            self.reviewStatusView.hidden = NO;
            self.reviewStatusView.text = @"审核未通过";
        } else {
            self.reviewStatusView.hidden = YES;
        }
    } else {
        self.iconImageView.image = nil;
        self.reviewStatusView.hidden = YES;
    }
}


@end
