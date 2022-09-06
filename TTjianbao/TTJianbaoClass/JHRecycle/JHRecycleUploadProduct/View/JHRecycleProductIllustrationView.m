//
//  JHRecycleProductIllustrationView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleProductIllustrationView.h"
#import "NSString+Common.h"
#import "JHRecyclePhotoInfoModel.h"

@interface JHRecycleProductIllustrationView()<UITextViewDelegate>


@property(nonatomic, strong) UIImageView * starImageView;

@end

@implementation JHRecycleProductIllustrationView

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
    [self addSubview:self.starImageView];
    [self addSubview:self.titleLbl];
    [self addSubview:self.textView];
    [self.textView addSubview:self.placeholderLbl];
}

- (void)layoutItems{
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView);
        make.left.equalTo(self.starImageView.mas_right).offset(2);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0).inset(12);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(14);
    }];
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@0).inset(10);
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
    if ([text isContainsEmoji]){return NO;}
    if ( (textView.text.length == 0 || textView.text == nil) && [text isEqualToString: @"\n"]){
        return NO;
    }

    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [NSNotificationCenter.defaultCenter postNotificationName:JHNotificationRecycleUploadImageInfoChanged object:nil];
}
#pragma mark -- <set and get>


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"宝贝描述";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        NSString *placeStr = @"有故事的宝贝一定不简单，说出你的故事…";
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.numberOfLines = 0;
        label.text = placeStr;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}


- (UITextView *)textView{
    if (!_textView) {
        UITextView *view = [UITextView new];
        view.backgroundColor = HEXCOLOR(0xF9F9F9);
        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
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
