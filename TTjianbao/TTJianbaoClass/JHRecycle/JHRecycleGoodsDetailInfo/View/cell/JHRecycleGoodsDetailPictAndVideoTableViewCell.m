//
//  JHRecycleGoodsDetailPictAndVideoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailPictAndVideoTableViewCell.h"
#import "JHRecycleGoodsInfoViewModel.h"

@interface JHRecycleGoodsDetailPictAndVideoTableViewCell ()
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIImageView *playIconImageView;
@end

@implementation JHRecycleGoodsDetailPictAndVideoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _picImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    _picImageView.clipsToBounds = YES;
    [self.contentView addSubview:_picImageView];
    [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(259.f);
    }];
    
    _playIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_hasVideo"]];
    _playIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _playIconImageView.hidden = YES;
    [self.contentView addSubview:_playIconImageView];
    [_playIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_equalTo(50.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHRecycleDetailInfoProductDetailUrlsModel *model = viewModel;
    if (model.detailType == 0) { /// 图片
        self.playIconImageView.hidden = YES;
        self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.picImageView jhSetImageWithURL:[NSURL URLWithString:model.detailImageUrl.medium] placeholder:kDefaultCoverImage];
        CGFloat picHeight = model.detailImageUrl.aNewHeight;
        [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(picHeight);
        }];
        [self.playIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(50.f);
        }];
    } else  if (model.detailType == 1) {
        self.playIconImageView.hidden = NO;
        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.picImageView jhSetImageWithURL:[NSURL URLWithString:model.detailVideoCoverUrl] placeholder:kDefaultCoverImage];
        CGFloat picHeight = picHeight = 259.f;
        [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(picHeight);
        }];
        [self.playIconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.height.mas_equalTo(50.f);
        }];
    }
}

@end
