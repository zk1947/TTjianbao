//
//  JHC2CProductDetailTextCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailTextCell.h"
#import "JHC2CProductDetailJianDingStatuView.h"
#import <YYLabel.h>

#import "JHC2CProoductDetailModel.h"

@interface JHC2CProductDetailTextCell()

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UILabel * detailLbl;

@property(nonatomic, assign) BOOL  hasSet;

@end

@implementation JHC2CProductDetailTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.detailLbl];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
//    [self.yearLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.detailLbl.mas_bottom).offset(22);
//        make.left.equalTo(@0).offset(3);
//    }];
//    [self.pingJiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.yearLbl.mas_bottom).offset(10);
//        make.left.equalTo(self.yearLbl);
//    }];
//    [self.chanDiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.pingJiLbl.mas_bottom).offset(10);
//        make.left.equalTo(self.yearLbl);
//    }];
//    [self.pingJiLbl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [self.chanDiLbl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//
//    [self.yearValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.yearLbl);
//        make.right.equalTo(@0).inset(12);
//        make.left.equalTo(self.yearLbl.mas_right).offset(15);
//
//    }];
//    [self.pingJiValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.pingJiLbl);
//        make.right.equalTo(@0).inset(12);
//        make.left.equalTo(self.pingJiLbl.mas_right).offset(15);
//    }];
//    [self.chanDiValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.chanDiLbl);
//        make.right.equalTo(@0).inset(12);
//        make.left.equalTo(self.chanDiLbl.mas_right).offset(15);
//        make.bottom.equalTo(@0).offset(-20);
//    }];

}
- (void)setModel:(JHC2CProoductDetailModel *)model{
    if (self.hasSet) {
        return;
    }
    _model = model;
    self.hasSet = YES;
    self.detailLbl.text = model.productDesc;
    BOOL hasAtt = model.productAttrList.count != 0;
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(10);
        make.left.right.equalTo(@0).inset(12);
        if (!hasAtt) {
            make.bottom.equalTo(@0).offset(-20);
        }
    }];
    if (hasAtt) {
        UIView *lastlabel = nil;
        for (int i = 0; i< model.productAttrList.count; i++) {
            NSDictionary *dic = model.productAttrList[i];
            NSString *name = [NSString stringWithFormat:@"【%@】", dic[@"attrName"]];
            UILabel* titleLbl = [self getTitleLblWithText:name];
            UILabel* valueLbl = [self getValueLblWithText:dic[@"attrValue"]];
            [self.backView addSubview:titleLbl];
            [self.backView addSubview:valueLbl];
            [titleLbl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastlabel) {
                    make.top.equalTo(lastlabel.mas_bottom).offset(10);
                }else{
                    make.top.equalTo(self.detailLbl.mas_bottom).offset(22);
                }
                make.left.equalTo(@0).offset(3);
            }];
            [valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLbl);
                make.left.equalTo(titleLbl.mas_right).offset(15);
                if (i == model.productAttrList.count - 1) {
                    make.bottom.equalTo(@0).offset(-20);
                }
            }];
            lastlabel = valueLbl;
        }
    }
    
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (UILabel *)detailLbl{
    if (!_detailLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(16);
        label.textColor = HEXCOLOR(0x333333);
        label.numberOfLines = 0;
        label.text = @"崇宁重宝批量走货，保真保老包入各种盒子，售出非假不退，无漏翘裂，单枚26元，最小批发量50枚，随机抓获，不挑不选，喜欢的朋友不要错过哦！";
        _detailLbl = label;
    }
    return _detailLbl;
}

- (UILabel *)getTitleLblWithText:(NSString*)text{
    UILabel *label = [UILabel new];
    label.font = JHFont(14);
    label.text = text;
    label.textColor = HEXCOLOR(0x333333);
    label.numberOfLines = 1;
    return label;
}
- (UILabel *)getValueLblWithText:(NSString*)text{
    UILabel *label = [UILabel new];
    label.font = JHFont(14);
    label.text = text;
    label.numberOfLines = 0;
    label.textColor = HEXCOLOR(0x333333);
    return label;
}

@end
