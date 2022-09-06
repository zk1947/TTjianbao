//
//  JHUnionPaySectionHeader.m
//  TTjianbao
//
//  Created by lihui on 2021/3/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUnionPaySectionHeader.h"
#import "UIView+CornerRadius.h"

@interface JHUnionPaySectionHeader ()
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation JHUnionPaySectionHeader

- (void)setMessage:(NSString *)message {
    _message = message;
    if ([message isNotBlank]) {
        _messageLabel.text = message;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorFFF;
        [self yd_setCornerRadius:4. corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _alertLabel = [[UILabel alloc] init];
    _alertLabel.text = @"*";
    _alertLabel.textColor = kColorFF4200;
    _alertLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    [self addSubview:_alertLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.text = @"";
    _messageLabel.textColor = kColor999;
    _messageLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    [self addSubview:_messageLabel];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(12);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertLabel.mas_right).offset(3);
        make.centerY.equalTo(self.alertLabel);
        make.right.equalTo(self).offset(-10).priority(225);
    }];
}




@end
