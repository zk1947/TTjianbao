//
//  JHPublishGoodsNameCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/7/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishGoodsNameCell.h"
#import "NSString+Common.h"

@interface JHPublishGoodsNameCell()<UITextViewDelegate>
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UITextView * textView;
@property(nonatomic, strong) UILabel * placeholderLbl;
@property(nonatomic, strong) UIImageView * starImageView;

@end

@implementation JHPublishGoodsNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;

        [self creatCellItem];
    }
    return self;
}

- (void)creatCellItem{
    [self setItems];
}

- (void)setItems{
    [self.contentView addSubview:self.starImageView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.textView];
    [self.textView addSubview:self.placeholderLbl];
    [self layoutItems];
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.starImageView);
        
        make.left.equalTo(@0).offset(12);
    }];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(self.titleLbl.mas_right).offset(2);
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
        NSString *placeStr = @"命名规范：二级分类（材质）+款式/制式（如吊坠、手串）+规格（如宽+高+厚）+特性（如玻璃种、大师雕工等";
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.text = placeStr;
        label.numberOfLines = 0;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
