//
//  JHBusinessPublishNameView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishNameView.h"
#import "NSString+Common.h"

@interface JHBusinessPublishNameView ()<UITextViewDelegate>
@property(nonatomic, strong) UILabel * titleLbl;


@property(nonatomic, strong) UIImageView * starImageView;

@end

@implementation JHBusinessPublishNameView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;

        [self creatCellItem];
    }
    return self;
}

- (void)creatCellItem{
    [self setItems];
}

- (void)setItems{
    [self addSubview:self.starImageView];
    [self addSubview:self.titleLbl];
    [self addSubview:self.textView];
    [self.textView addSubview:self.placeholderLbl];
    [self layoutItems];
    
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.titleLbl.mas_right).offset(2);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0).inset(12);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(12);
        make.height.mas_equalTo(75);
    }];
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).inset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
}

#pragma mark -- <UITextViewDelegate>
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = textView.text.length;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger maxlenth = 60;
    if (textView.text.length + text.length > maxlenth) {return NO;}
    if ([text isContainsEmoji]){return NO;}
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    self.publishModle.productName = textView.text;
}

#pragma mark -- <set and get>


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"商品名称";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.numberOfLines = 3;
        NSString *placeStr = @"命名规范：二级分类（材质）+款式/制式（如吊坠、手串）+规格（如宽+高+厚）+特性（如玻璃种、大师雕工等）";
        label.text = placeStr;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}


- (UITextView *)textView{
    if (!_textView) {
        UITextView *view = [UITextView new];
        view.backgroundColor = HEXCOLOR(0xF9F9F9);
//        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        view.layer.cornerRadius = 5;
        view.font = JHFont(13);
        view.delegate = self;
        view.textColor = HEXCOLOR(0x222222);
        view.tintColor = HEXCOLOR(0xFED73A);
        _textView = view;
    }
    return _textView;
}

- (UIImageView *)starImageView{
    if (!_starImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
        _starImageView = view;
    }
    return _starImageView;
}
@end
