//
//  JHC2CProductUploadTextInfoView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductUploadTextInfoView.h"
#import "NSString+Common.h"
@interface JHC2CProductUploadTextInfoView()<UITextViewDelegate>
@property(nonatomic, strong) UIView * titleBackView;
@property(nonatomic, strong) UILabel * countLbl;



@end

@implementation JHC2CProductUploadTextInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleBackView];
    [self addSubview:self.textView];
    [self.titleBackView addSubview:self.titleLbl];
    [self addSubview:self.countLbl];
    [self.textView addSubview:self.placeholderLbl];
}

- (void)layoutItems{
    [self.titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@60);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.right.left.equalTo(@0).inset(12);
        make.top.equalTo(self.titleBackView.mas_bottom);
        make.height.mas_equalTo(122);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(12);
        make.centerY.equalTo(@0);
        make.right.equalTo(@0);
    }];
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-20);
        make.bottom.equalTo(@0).offset(-8);
    }];

    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).inset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];

}

- (void)refreshTextViewHeight{
    NSString *text = self.textView.text;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(ScreenWidth - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : JHFont(12)} context:nil].size.height;
    height += 40;
    if (height < 122) {
        height = 122;
    }
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0).inset(12);
        make.top.equalTo(self.titleBackView.mas_bottom);
        make.height.mas_equalTo(height);
        make.bottom.equalTo(@0);
    }];
}
#pragma mark -- <UITextViewDelegate>

- (void)textViewDidChange:(YYTextView *)textView{
    [self refreshTextViewHeight];
    NSString *countStr = [NSString stringWithFormat:@"%ld/300",textView.text.length];
    self.countLbl.text = countStr;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSInteger maxlenth = 300;
    if (textView.text.length + text.length > maxlenth) {return NO;}
    if ([text isContainsEmoji]){return NO;}
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = textView.text.length;
}
#pragma mark -- <set and get>
- (UIView *)titleBackView{
    if (!_titleBackView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _titleBackView = view;
    }
    return _titleBackView;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"钱币邮票-古钱币-古钱币";
        _titleLbl = label;
    }
    return _titleLbl;
}


- (UITextView *)textView{
    if (!_textView) {
        UITextView *view = [UITextView new];
        view.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
        view.layer.cornerRadius = 5;
        view.font = JHFont(14);
        view.delegate = self;
        view.scrollEnabled = NO;
        view.textColor = HEXCOLOR(0x333333);
        view.tintColor = HEXCOLOR(0xFED73A);
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = HEXCOLOR(0xE3E3E3).CGColor;
        view.backgroundColor = HEXCOLOR(0xF9F9F9);
        view.returnKeyType = UIReturnKeyDone;
        _textView = view;
    }
    return _textView;
}

- (UILabel *)countLbl{
    if (!_countLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0xCCCCCC);
        label.text = @"0/300";
        _countLbl = label;
    }
    return _countLbl;
}

- (UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 2;
        NSString *placeStr = @"* 请描述一下您要卖的宝贝（注：实物要与宝贝的图文信息一致）";
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:placeStr
                                                                                   attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999),
                                                                                                NSFontAttributeName:JHFont(14)
                                                                                   }];
        NSRange range = [placeStr rangeOfString:@"*"];
        [attstr setAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xF23730),NSFontAttributeName:JHFont(14)} range:range];

        label.attributedText = attstr;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}


@end
