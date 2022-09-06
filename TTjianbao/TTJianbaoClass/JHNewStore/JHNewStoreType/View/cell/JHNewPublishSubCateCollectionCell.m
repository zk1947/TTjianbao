//
//  JHNewPublishSubCateCollectionCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewPublishSubCateCollectionCell.h"
#import "TTjianbaoHeader.h"
#import "JHNewStoreTypeTableCellViewModel.h"

@interface JHNewPublishSubCateCollectionCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHNewPublishSubCateCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.imgView = [UIImageView new];
        self.imgView.backgroundColor = UIColor.whiteColor;
        [self.imgView setClipsToBounds:YES];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(3);
            make.centerX.equalTo(self.contentView);
            make.width.height.equalTo(@59);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(6);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setViewModel:(JHNewStoreTypeTableCellViewModel *)viewModel{
    _viewModel = viewModel;
    [self.imgView jhSetImageWithURL:[NSURL URLWithString:viewModel.cateIcon] placeholder:[UIImage imageNamed:@"jh_newStore_type_defaulticon"]];
    self.titleLabel.text = viewModel.cateName;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imgView.image = nil;
    self.titleLabel.text = nil;
}


@end
