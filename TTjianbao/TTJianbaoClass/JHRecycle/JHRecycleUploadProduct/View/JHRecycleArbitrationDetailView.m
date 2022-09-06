//
//  JHRecycleArbitrationDetailView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleArbitrationDetailView.h"
#import "JHRecyclePhotoInfoModel.h"
#import "NSString+Common.h"

@interface JHRecycleArbitrationDetailView()<UITextViewDelegate>
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * placeholderLbl;

/// ※号
@property(nonatomic, strong) UIImageView * starImageView;

@end

@implementation JHRecycleArbitrationDetailView

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
    [self addSubview:self.titleLbl];
    [self addSubview:self.starImageView];
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
        make.right.bottom.left.equalTo(@0);
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.height.mas_equalTo(79);
        make.bottom.equalTo(@0);
    }];
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@0).inset(10);
    }];
}

- (void)refreshTextViewHeight{
    NSString *text = self.textView.text;
    CGFloat height = [text boundingRectWithSize:CGSizeMake(ScreenWidth - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : JHFont(12)} context:nil].size.height;
    height += 25;
    if (height < 79) {
        height = 79;
    }
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0);
        make.top.equalTo(self.titleLbl.mas_bottom);
        make.height.mas_equalTo(height);
        make.bottom.equalTo(@0);
    }];
}
#pragma mark -- <UITextViewDelegate>
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = textView.text.length;
}
- (void)textViewDidChange:(UITextView *)textView{
    [NSNotificationCenter.defaultCenter postNotificationName:JHNotificationRecycleUploadImageInfoChanged object:nil];
    [self refreshTextViewHeight];
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger maxlenth = 200;
    if (textView.text.length + text.length > maxlenth) {return NO;}
    if ([text isContainsEmoji]){return NO;}
    return YES;
}
#pragma mark -- <set and get>


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"仲裁说明：";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        NSString *placeStr = @"请描述仲裁理由，字数限制200字";
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x999999);
        label.text = placeStr;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}


- (UITextView *)textView{
    if (!_textView) {
        UITextView *view = [UITextView new];
        view.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        view.layer.cornerRadius = 5;
        view.font = JHFont(12);
        view.delegate = self;
        view.scrollEnabled = NO;
        view.textColor = HEXCOLOR(0x333333);
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
