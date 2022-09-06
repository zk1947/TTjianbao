//
//  JHGemmologistCertificateCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGemmologistCertificateCell.h"
#import "UIImageView+WebCache.h"
#import "TTjianbaoHeader.h"
@interface JHGemmologistCertificateCell()
/** 图片*/
@property (nonatomic, strong) UIImageView *certificateImageView;
/** 文字*/
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation JHGemmologistCertificateCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self.contentView addSubview:self.certificateImageView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self.certificateImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"authImg"]] placeholderImage:kDefaultCoverImage];
    self.nameLabel.text = dict[@"authTitle"];
}

- (UIImageView *)certificateImageView{
    if (_certificateImageView == nil) {
        _certificateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 27)];
        _certificateImageView.contentMode = UIViewContentModeScaleAspectFill;
        _certificateImageView.clipsToBounds = YES;
        _certificateImageView.layer.cornerRadius = 8;
        _certificateImageView.image = kDefaultCoverImage;
    }
    return _certificateImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.certificateImageView.bottom + 5, self.width, 17)];
        _nameLabel.text = @"";
        _nameLabel.textColor = RGB(51, 51, 51);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _nameLabel;
}
@end
