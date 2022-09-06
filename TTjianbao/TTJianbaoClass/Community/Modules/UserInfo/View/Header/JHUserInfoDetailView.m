//
//  JHUserInfoDetailView.m
//  TTjianbao
//
//  Created by lihui on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoDetailView.h"
#import "TTjianbaoMarcoUI.h"

@interface JHUserInfoDetailView ()

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *detailCountLabel;

@end

@implementation JHUserInfoDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _detailCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width, self.height / 2)];
    _detailCountLabel.text = @"0";
    _detailCountLabel.textColor = kColor333;
    _detailCountLabel.textAlignment = NSTextAlignmentLeft;
    _detailCountLabel.font = [UIFont fontWithName:kFontBoldDIN size:18];
    [self addSubview:_detailCountLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.detailCountLabel.bottom, self.width, self.height / 2)];
    _detailLabel.text = @"";
    _detailLabel.textColor = kColor999;
    _detailLabel.textAlignment = NSTextAlignmentLeft;
    _detailLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [self addSubview:_detailLabel];
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    if (title) {
        _detailLabel.text = title;
    }
    if (value) {
        _detailCountLabel.text = value;
    }
    
    [self rebuildUI];
}

- (void)setTitle:(NSString *)title {
    if (!title) {
        return;
    }
    _title = title;
    _detailLabel.text = _title;
    [self rebuildUI];
}

- (void)setValue:(NSString *)value {
    if (!value) {
        return;
    }
    _value = value;
    _detailCountLabel.text = value;
    [self rebuildUI];
}

- (void)rebuildUI{
    if (self.detailCountLabel.text.length > 0 && self.detailLabel.text.length > 0) {
        CGFloat countWidth = [self.detailCountLabel.text widthForFont:[UIFont fontWithName:kFontBoldDIN size:18]];
        CGFloat nameWidth = [self.detailLabel.text widthForFont:[UIFont fontWithName:kFontNormal size:12]];
        if (countWidth < nameWidth) {
            self.detailCountLabel.frame = CGRectMake((nameWidth - countWidth) / 2, 0, self.width, self.height / 2);
            self.detailLabel.frame = CGRectMake(0, self.detailCountLabel.bottom, self.width, self.height / 2);
        }else{
            self.detailCountLabel.frame = CGRectMake(0, 0, self.width, self.height / 2);
            self.detailLabel.frame = CGRectMake((countWidth - nameWidth) / 2, self.detailCountLabel.bottom, self.width, self.height / 2);
        }
    }
}

@end
