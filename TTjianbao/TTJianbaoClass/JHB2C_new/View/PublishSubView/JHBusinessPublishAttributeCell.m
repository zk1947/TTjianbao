//
//  JHBusinessPublishAttributeCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishAttributeCell.h"
#import "JHBusinessGoodsAttributeModel.h"

@interface JHBusinessPublishTextAttributeCell ()
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UIButton * starImageView;
@property(nonatomic, strong) JHBusinessGoodsAttributeSelectModel *model;
@end
@implementation JHBusinessPublishTextAttributeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;

        [self setItems];
    }
    return self;
}

- (void)setCellModel:(JHBusinessGoodsAttributeSelectModel *)model{
    self.model = model;
    self.titleLbl.text = model.attrName;
    if (model.isSelect) {
        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];

    }else{
        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
    }
    
    //icon_user_auth_select_sel  icon_user_auth_select_nor
}
//- (void)selectBtnAction{
//    self.model.isSelect = !self.model.isSelect;
//    if (self.model.isSelect) {
//        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];
//
//    }else{
//        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
//    }
//}

- (void)setItems{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.starImageView];
    [self layoutItems];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self);
    }];
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.lessThanOrEqualTo(@50);
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).inset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"材质1";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UIButton *)starImageView{
    if (!_starImageView) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.userInteractionEnabled = NO;
//        [view addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _starImageView = view;
    }
    return _starImageView;
}

@end

@interface JHBusinessPublishAttributeCell()<UITextFieldDelegate>
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UIButton * starImageView;
@property(nonatomic, strong) JHBusinessGoodsAttributeSelectModel *model;
@property(nonatomic, strong) UITextField * textView;
@end
@implementation JHBusinessPublishAttributeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];

        [self setItems];
    }
    return self;
}

- (void)setCellModel:(JHBusinessGoodsAttributeSelectModel *)model{
    self.model = model;
    self.titleLbl.text = model.attrName;
    
    self.textView.text = model.textStr;
    if (model.isSelect) {
        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];

    }else{
        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
    }
    
    //icon_user_auth_select_sel  icon_user_auth_select_nor
}
//- (void)selectBtnAction{
//    self.model.isSelect = !self.model.isSelect;
//    if (self.model.isSelect) {
//        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];
//
//    }else{
//        [self.starImageView setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
//    }
//}

- (void)setItems{
    self.contentView.clipsToBounds = YES;
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.starImageView];
    [self.contentView addSubview:self.textView];
    [self layoutItems];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self);
    }];
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.lessThanOrEqualTo(@50);
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(self.contentView).inset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.equalTo(@24);
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(24);
        make.left.mas_equalTo(15);
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger maxlenth = 20;
    if (textField.text.length + string.length > maxlenth) {return NO;}

    
    return YES;
}
-(void)textFieldChanged:(NSNotification *)obj{
    self.model.textStr = self.textView.text;
}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"材质1";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UIButton *)starImageView{
    if (!_starImageView) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.userInteractionEnabled = NO;
//        [view addTarget:self action:@selector(selectBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _starImageView = view;
    }
    return _starImageView;
}
- (UITextField *)textView{
    if (!_textView) {
        UITextField *view = [UITextField new];
        view.font = JHFont(13);
        view.placeholder = @"请输入属性";
        view.delegate = self;
        view.textColor = HEXCOLOR(0x222222);
        view.tintColor = HEXCOLOR(0xFED73A);
        _textView = view;
    }
    return _textView;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
