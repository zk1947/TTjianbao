//
//  JHCustomerMpEditInstroTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerMpEditInstroTableViewCell.h"
#import "UITextView+PlaceHolder.h"
#import "UIView+Toast.h"

@interface JHCustomerMpEditInstroTableViewCell ()<UITextViewDelegate>
@end

@implementation JHCustomerMpEditInstroTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _textView               = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-30.f, 225.f)];
    _textView.delegate      = self;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font          = [UIFont fontWithName:kFontNormal size:15.f];
    _textView.placeholder   = @"请输入代表作描述（100字以内）";
    _textView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(225.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    /// 只要前100个字
    if (textView.text.length > 100) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 100)];
    }
}


@end
