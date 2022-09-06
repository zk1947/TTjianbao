//
//  JHBusinessFansEquityEditTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansEquityEditTableViewCell.h"
#import "TTjianbao.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHBusinessFansEquityEditTableViewCell ()<UITextFieldDelegate>
@end

@implementation JHBusinessFansEquityEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnArray;
}

- (NSMutableArray *)textFieldArray {
    if (!_textFieldArray) {
        _textFieldArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _textFieldArray;
}

- (void)setupViews {
    _titleNameLabel                          = [[UILabel alloc] init];
    _titleNameLabel.textColor                = HEXCOLOR(0x333333);
    _titleNameLabel.textAlignment            = NSTextAlignmentLeft;
    _titleNameLabel.font                     = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    
    CGFloat btnLeft                = 12.f;
    CGFloat btnWidthFirst          = 14.f + 44.f;
    CGFloat btnWidth               = 19.f + 44.f;
    CGFloat btnSpace               = (ScreenW - btnLeft*2 - btnWidth*3)/2.f;
    NSArray *names                 = @[@"代金券",@"专属商品",@"进场特效"];
    NSArray *textFieldPlaceholders = @[@"输入代金券ID",@"输入奖品名称"];
    for (int i = 0; i < 3; i++) {
        UIButton *button           = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:button];
        [button setTitle:names[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font     = [UIFont fontWithName:kFontNormal size:12.f];
        [button addTarget:self action:@selector(settingBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"fans_setting_business_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
        [button setImageInsetStyle:MRImageInsetStyleLeft spacing:5.f];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(10.f);
            make.left.equalTo(self.contentView.mas_left).offset(btnLeft+(btnSpace + btnWidth)*i);
            if (i == 0) {
                make.width.mas_equalTo(btnWidthFirst);
            } else {
                make.width.mas_equalTo(btnWidth);
            }
            make.height.mas_equalTo(17.f);
        }];
        button.selected = YES;
        [self.btnArray addObject:button];
        
        if (i<2) {
            UITextField *textField        = [[UITextField alloc] init];
            textField.placeholder         = textFieldPlaceholders[i];
            textField.textAlignment       = NSTextAlignmentCenter;
            textField.delegate            = self;
            textField.layer.borderWidth   = 0.5f;
            textField.layer.borderColor   = HEXCOLOR(0xBDBFC2).CGColor;
            textField.layer.cornerRadius  = 2.f;
            textField.layer.masksToBounds = YES;
            textField.font                = [UIFont fontWithName:kFontNormal size:14.f];
            if (i == 0) {
                textField.keyboardType    = UIKeyboardTypeNumberPad;
            }
            textField.hidden              = i == 0;
            [self.contentView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_left);
                make.top.equalTo(button.mas_bottom).offset(9.f);
                make.width.mas_equalTo(116.f);
                make.height.mas_equalTo(30.f);
            }];
            [self.textFieldArray addObject:textField];
        }
        if (i == 0) {
            [self.contentView addSubview:self.addView];
            [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_left);
                make.top.equalTo(button.mas_bottom).offset(3.f);
                make.width.mas_equalTo(100.f);
                make.height.mas_equalTo(41.f);
            }];
        }
        
    }

    _lineView                    = [[UIView alloc] init];
    _lineView.backgroundColor    = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.top.equalTo(self.titleNameLabel.mas_bottom).offset(81.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)settingBtnClickAction:(UIButton *)button {
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
    [self changeBtnAndTextFiledUI];
    [self equityEditInfoCallBack];
}

- (void)setIsLastLine:(BOOL)isLastLine {
    _isLastLine = isLastLine;
    _lineView.hidden = isLastLine;
}

- (void)changeBtnAndTextFiledUI {
    CGFloat lineTop = 81.f;
    for (int i = 0; i<self.btnArray.count -1; i++) {
        UIButton *btn = self.btnArray[i];
        UITextField *textField = self.textFieldArray[i];
        if (btn.selected) {
            textField.hidden = NO;
        } else {
            textField.hidden = YES;
        }
        if(i == 0){
            self.addView.hidden  = !btn.selected;
            textField.hidden = YES;
        }
    }
    for (int i = 0; i<self.btnArray.count -1; i++) {
        UIButton *btn = self.btnArray[i];
        if (btn.selected) {
            lineTop = 81.f;
            break;
        } else {
            lineTop = 41.f;
        }
    }
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleNameLabel.mas_bottom).offset(lineTop);
    }];
    [[self tableView] beginUpdates];
    [[self tableView] endUpdates];
}


- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

/// 回显
- (void)setModel:(JHBusinessFansRewardConfigVoListApplyModel *)model {
    _model = model;
    _titleNameLabel.text = [NSString stringWithFormat:@"粉丝等级Lv.%@",model.levelType];
    if (model.fansRewardConfigList.count >0) {
        CGFloat lineTop = 41.f;
        for (UIButton *btn in self.btnArray) {
            btn.selected = NO;
        }
        for (UITextField *textField in self.textFieldArray) {
            textField.hidden = YES;
        }
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(lineTop);
        }];

        for (int i = 0; i< model.fansRewardConfigList.count; i++) {
            JHBusinessFansRewardConfigListApplyModel *applyModel = model.fansRewardConfigList[i];
            if (!isEmpty(applyModel.rewardType)) {
                NSInteger index = [applyModel.rewardType integerValue];
                UIButton *btn = _btnArray[index];
                btn.selected = YES;
            } else {
                UIButton *btn = _btnArray[i];
                btn.selected = NO;
            }
            if (i < model.fansRewardConfigList.count - 1) {
                if (!isEmpty(applyModel.rewardName)) {
                    NSInteger index = [applyModel.rewardType integerValue];
                    UITextField *textField = _textFieldArray[index];
                    textField.text = applyModel.rewardName;
                    textField.hidden = NO;
                    
                    if ([applyModel.rewardType isEqualToString:@"0"]) {
                        self.codeLbl.text = [NSString stringWithFormat:@"券ID：%@",applyModel.rewardName] ;
                    }
                } else {
                    UITextField *textField = _textFieldArray[i];
                    textField.text = @"";
                    textField.hidden = YES;
                }
            }
        }
        
        for (int i = 0; i<self.btnArray.count -1; i++) {
            UIButton *btn = self.btnArray[i];
            if (btn.selected) {
                lineTop = 81.f;
                break;
            } else {
                lineTop = 41.f;
            }
        }
        for (UITextField *textField in self.textFieldArray) {
            if (lineTop == 81.f) {
                textField.hidden = NO;
                self.addView.hidden  = NO;
            } else {
                textField.hidden = YES;
                self.addView.hidden  = YES;
            }
        }
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleNameLabel.mas_bottom).offset(lineTop);
        }];
    }
    [self equityEditInfoCallBack];
}

/// 赋值
- (void)equityEditInfoCallBack {
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.btnArray.count; i++) {
        JHBusinessFansRewardConfigListApplyModel *subModel = [[JHBusinessFansRewardConfigListApplyModel alloc] init];
        UIButton *btn = (UIButton *)self.btnArray[i];
        if (btn.selected) {
            subModel.rewardType = [NSString stringWithFormat:@"%d",i];
        } else {
            subModel.rewardType = @"";
        }
        if (i<2) {
            UITextField *textField = (UITextField *)self.textFieldArray[i];
            if (!isEmpty(textField.text)) {
                subModel.rewardName = textField.text;
            } else {
                subModel.rewardName = @"";
            }
            if(i == 0){
                textField.hidden = YES;
            }
        }
        [muArr addObject:subModel];
    }
    self.model.fansRewardConfigList = muArr;
    if (self.changeBlock) {
        self.changeBlock();
    }
}

- (void)addYouHuiQuanActionWithSender:(UIButton*)sender{
    if (self.showYouHuiQuanBlock) {
        self.showYouHuiQuanBlock();
    }
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self equityEditInfoCallBack];
}

- (UIView *)addView{
    if (!_addView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_user_info_arrow_orange"] forState:UIControlStateNormal];
        [btn setTitle:@"选择代金券" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0xFFB715) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(14);
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:12];

        [btn addTarget:self action:@selector(addYouHuiQuanActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.text = @"";
        label.textColor = HEXCOLOR(0x333333);
        [view addSubview:label];
        self.codeLbl = label;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@0);
            make.width.equalTo(@75);
            make.height.equalTo(@22);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
        }];
        
        _addView = view;
    }
    return _addView;
}


@end
