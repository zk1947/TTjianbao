//
//  JHIdentyPhotoInfoHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyPhotoInfoHeader.h"

@interface JHIdentyPhotoInfoHeader ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation JHIdentyPhotoInfoHeader


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    _titleLabel.textColor = HEXCOLOR(0x333333);
    _titleLabel.text = JHLocalizedString(@"uploadPhoto");
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _detailLabel.textColor = HEXCOLOR(0x999999);
    _detailLabel.text = JHLocalizedString(@"allowVisitCameraWhenCannotUpload");
    [self addSubview:_detailLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self);
    }];
}











@end
