//
//  JHHonnerCerDetailImageViewTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonnerCerDetailImageViewTableViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"

@interface JHHonnerCerDetailImageViewTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *watermarkImageView;
@end

@implementation JHHonnerCerDetailImageViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius  = 8.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(20.f, 15.f, 20.f, 15.f));
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(230.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    _watermarkImageView = [[UIImageView alloc] init];
    _watermarkImageView.layer.cornerRadius  = 8.f;
    _watermarkImageView.layer.masksToBounds = YES;
    _watermarkImageView.contentMode = UIViewContentModeScaleAspectFill;
    _watermarkImageView.image = [UIImage imageNamed:@"customize_watermark"];
    [self.contentView addSubview:_watermarkImageView];
    [_watermarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconImageView);
    }];
    
}

- (void)setViewModel:(NSString *)viewModel {
    [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:viewModel] placeholder:kDefaultCoverImage];
}

@end
