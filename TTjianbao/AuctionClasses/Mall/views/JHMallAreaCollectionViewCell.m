//
//  JHMallAreaCollectionViewCell.m
//  TaodangpuAuction
//
//  Created by jiang on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallAreaCollectionViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoHeader.h"

@interface JHMallAreaCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;          ///标题
@property (nonatomic, strong) UILabel *descLabel;           ///描述
@property (nonatomic, strong) UIImageView *coverImageView;  ///封面

@end

@implementation JHMallAreaCollectionViewCell




-(void)setSpecialAreaMode:(JHMallSpecialAreaModel *)specialAreaMode{
    
    _specialAreaMode=specialAreaMode;
    [_coverImageView jhSetImageWithURL:[NSURL URLWithString:specialAreaMode.icon] placeholder:kDefaultCoverImage];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xffffff);
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = @"dfdfdfdf";
//        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
//        _titleLabel.textColor = HEXCOLOR(0x333333);
//        [self.contentView addSubview:_titleLabel];
//    }
//
//    if (!_descLabel) {
//        _descLabel = [[UILabel alloc] init];
//        _descLabel.text = @"dafafafafa";
//        _descLabel.font = [UIFont fontWithName:kFontNormal size:12];
//        _descLabel.textColor = HEXCOLOR(0x666666);
//        [self.contentView addSubview:_descLabel];
//    }
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@""];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_coverImageView];
    }
    
    [self makeLayouts];
}

#pragma mark -
- (void)makeLayouts {
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView).offset(10);
//        make.right.equalTo(self.contentView).offset(-10);
//    }];
//
//    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel);
//        make.right.equalTo(self.contentView).offset(-5);
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
       
    }];
}
@end
