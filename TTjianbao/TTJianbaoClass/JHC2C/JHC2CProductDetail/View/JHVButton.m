//
//  JHVButton.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHVButton.h"
@interface JHVButton()
@property(nonatomic, assign) CGFloat  imageTop;
@property(nonatomic, assign) CGFloat  textBottom;

@property(nonatomic, strong) UIImageView * vImageView;
@property(nonatomic, strong) UILabel * vTextLbl;


@end
@implementation JHVButton

- (instancetype)initWithImageTop:(CGFloat)imageTop textBottom:(CGFloat)textBottom{
    if (self = [super initWithFrame:CGRectZero]) {
        self.imageTop = imageTop;
        self.textBottom = textBottom;
        [self addSubview:self.vImageView];
        [self addSubview:self.vTextLbl];
        [self.vImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(self.imageTop);
            make.centerX.equalTo(@0);
        }];
        [self.vTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.equalTo(@0).offset(-self.textBottom);
            make.left.right.equalTo(@0);
        }];
    }
    return  self;
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (self.normalText && !selected) {
        self.vTextLbl.text = self.normalText;
    }
    if (self.seleteText && selected) {
        self.vTextLbl.text = self.seleteText;
    }

    if (self.seleImage && selected) {
        self.vImageView.image = self.seleImage;
    }else if(self.unseleImage && !selected){
        self.vImageView.image = self.unseleImage;
    }
    
}
#pragma mark -- <set and get>

- (UILabel *)vTextLbl{
    if (!_vTextLbl) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        _vTextLbl = label;
    }
    return _vTextLbl;
}
- (UIImageView *)vImageView{
    if (!_vImageView) {
        UIImageView *view = [UIImageView new];
        _vImageView = view;
    }
    return _vImageView;
}

@end
