//
//  JHCustomizeDescStuffInfoCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeDescStuffInfoCollectionViewCell.h"

@interface JHCustomizeDescStuffInfoCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation JHCustomizeDescStuffInfoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    self.backgroundColor = HEXCOLOR(0xffffff);
    
    _titleLabel                      = [[UILabel alloc] init];
    _titleLabel.textColor            = HEXCOLOR(0x333333);
    _titleLabel.textAlignment        = NSTextAlignmentLeft;
    _titleLabel.font                 = [UIFont fontWithName:kFontMedium size:16.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(20.f);
        make.height.mas_equalTo(22.f);
    }];
    
    _infoLabel                      = [[UILabel alloc] init];
    _infoLabel.textColor            = HEXCOLOR(0x333333);
    _infoLabel.textAlignment        = NSTextAlignmentLeft;
    _infoLabel.font                 = [UIFont fontWithName:kFontNormal size:14.f];
    _infoLabel.lineBreakMode        = NSLineBreakByWordWrapping;
    _infoLabel.numberOfLines        = 2;
    [_infoLabel setPreferredMaxLayoutWidth:ScreenW - 40.f];
    [self.contentView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(20.f);
        make.width.mas_equalTo(ScreenWidth - 40.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

- (void)setViewModel:(id)viewModel {
    NSDictionary *dict = [NSDictionary cast:viewModel];
    if (isEmpty(dict[@"worksName"])) {
        self.titleLabel.text = @"";
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    } else {
        self.titleLabel.text = dict[@"worksName"];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10.f);
            make.height.mas_equalTo(22.f);
        }];
    }
    
    if (!isEmpty(dict[@"worksDes"])) {
        CGSize size = [self calculationTextWidthWith:dict[@"worksDes"] font:[UIFont fontWithName:kFontNormal size:14.f]];
        if (size.width > (ScreenWidth - 40.f)) {
            [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(42.f);
            }];
        } else {
            [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(21.f);
            }];
        }
        self.infoLabel.text = dict[@"worksDes"];
    } else {
        if (!isEmpty(dict[@"worksName"])) {
            [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
            }];
        } else {
            [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(0.f);
            }];
        }
    }
}

@end
