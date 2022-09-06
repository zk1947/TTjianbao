//
//  JHEmptyCollectionCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEmptyCollectionCell.h"

@implementation JHEmptyCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xf5f6fa);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        
        [self.imageView setImage:[UIImage imageNamed:@"img_default_page"]];
        self.label.text = @"暂无数据~";
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-60);
            make.centerX.equalTo(self.contentView.mas_centerX);

        }];

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.centerX.equalTo(self.imageView.mas_centerX);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)label{
    if (_label == nil) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textColor = HEXCOLOR(0xa7a7a7);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
