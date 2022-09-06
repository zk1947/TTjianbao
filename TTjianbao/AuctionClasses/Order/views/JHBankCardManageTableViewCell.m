//
//  JHBankCardManageTableViewCell.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBankCardManageTableViewCell.h"
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"
#import "CommAlertView.h"
#import <SDWebImage/SDWebImage.h>
#import "UIButton+zan.h"

@interface JHBankCardManageTableViewCell()
@property(strong, nonatomic) UIView *cellBGView;
@property(strong, nonatomic) UIImageView *iconIV;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *typeLabel;
@property(strong, nonatomic) UILabel *cardNoLabel;
@property(strong, nonatomic) UILabel *subNameLabel;
@property(strong, nonatomic) UIButton *updateBtn;

@end

@implementation JHBankCardManageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        
        [self.cellBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.f);
            make.height.mas_equalTo(144.f);
        }];
        
        [self setupSubView];
    
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
//    frame.origin.x = 10;    //这里间距为10，可以根据自己的情况调整
//    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setupSubView {
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(14.f);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconIV);
        make.left.mas_equalTo(self.iconIV.mas_right).mas_equalTo(12.f);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(2.f);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    [self.cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(16.f);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    UIView *bgView = [UIView jh_viewWithColor:RGBA(255, 255, 255, 0.1) addToSuperview:self.cellBGView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-11.f);
        make.left.mas_equalTo(self.iconIV);
    }];
    
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.subNameLabel);
        make.right.mas_equalTo(-4.f);
        make.width.mas_equalTo(50.f);
        make.left.mas_equalTo(self.subNameLabel.mas_right).mas_offset(10.f);
    }];
}

-(void)updateBtnAction {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"修改开户行" andDesc:@"" cancleBtnTitle:@"确定"];
    [alert displayTextFiledWithPlaceHoldStr:@"请输入正确的开户行信息"];
    @weakify(alert)
    [alert setCancleHandle:^{
        @strongify(alert)
        [self updateOpenBankName:alert];
    }];
    
    [alert setTextFieldShouldReturnBlock:^Boolean(UITextField * _Nonnull textField) {
        [textField resignFirstResponder];
        @strongify(alert)
        [self updateOpenBankName:alert];
        return NO;
    }];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
}

- (void)setBankCardModel:(JHBankCardModel *)bankCardModel {
    _bankCardModel = bankCardModel;
    
    self.nameLabel.text = _bankCardModel.bankName;
    self.typeLabel.text = _bankCardModel.bankType;
    self.cardNoLabel.text = _bankCardModel.accountNo;
    self.subNameLabel.text = _bankCardModel.bankBranch;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:_bankCardModel.iconUrl]];
}

- (void)updateOpenBankName:(CommAlertView *)alert {
    if (![alert getTextFiledText].length &&
        [alert getTextFiledText].length < 30) {
        [self makeToast:@"请输入正确的开户行信息"duration:1.0 position:CSToastPositionCenter];
        return;
    }
    self.bankCardModel.editBankBranch = [alert getTextFiledText];
    if (self.bankCardUpdateOpenBankBlock) {
        self.bankCardUpdateOpenBankBlock(self.bankCardModel);
    }
}

- (UIView *)cellBGView {
    if (!_cellBGView) {
        _cellBGView = [UIView jh_viewWithColor:RGBA(255, 255, 255, 0.1) addToSuperview:self.contentView];
        [_cellBGView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFFF8639),HEXCOLOR(0xFFF2B333)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
        _cellBGView.layer.cornerRadius = 5;
    }
    return _cellBGView;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.contentView];
        _iconIV.layer.borderWidth = 0.5;
        _iconIV.layer.borderColor = HEXCOLOR(0xFFFFFFFF).CGColor;
        _iconIV.layer.cornerRadius = 22.f;
        _iconIV.layer.masksToBounds = YES;
    }
    return _iconIV;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel jh_labelWithBoldFont:18 textColor:UIColor.whiteColor addToSuperView:self.cellBGView];
//        _nameLabel.text = @"建设银行";
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel jh_labelWithFont:13 textColor:UIColor.whiteColor addToSuperView:self.cellBGView];
//        _typeLabel.text = @"储蓄卡";
        _typeLabel.numberOfLines = 1;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _typeLabel;
}

-(UILabel *)cardNoLabel {
    if (!_cardNoLabel) {
        _cardNoLabel = [UILabel jh_labelWithBoldFont:18 textColor:UIColor.whiteColor addToSuperView:self.cellBGView];
//        _cardNoLabel.text = @"**** **** **** 3277";
        _cardNoLabel.numberOfLines = 1;
//        _cardNoLabel.backgroundColor = UIColor.redColor;
        _cardNoLabel.textAlignment = NSTextAlignmentCenter;
//        _cardNoLabel.contentMode = UIViewContentModeCenter;
    }
    return _cardNoLabel;
}

- (UILabel *)subNameLabel {
    if (!_subNameLabel) {
        _subNameLabel = [UILabel jh_labelWithFont:13 textColor:UIColor.whiteColor addToSuperView:self.cellBGView];
//        _subNameLabel.text = @"招商银行大望路支行招商银行大望路支行招商银行大望路支行招商银行大望路支行";
        _subNameLabel.numberOfLines = 1;
        _subNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subNameLabel;
}

- (UIButton *)updateBtn {
    if (!_updateBtn) {
        _updateBtn = [UIButton jh_buttonWithImage:[UIImage imageNamed:@""] target:self action:@selector(updateBtnAction) addToSuperView:self.cellBGView];
        [_updateBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_updateBtn setImage:[UIImage imageNamed:@"icon_bank_manager_update"] forState:UIControlStateNormal];
        [_updateBtn refresh_leftTitle_rightImv_space:-4.f];
        _updateBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _updateBtn.adjustsImageWhenDisabled = NO;
        _updateBtn.adjustsImageWhenHighlighted = NO;
    }
    return _updateBtn;
}

//-(void)btnClick:(UIButton*)sender {
//     [self.delegate buttonPress:sender cellIndex:self.cellIndex];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
