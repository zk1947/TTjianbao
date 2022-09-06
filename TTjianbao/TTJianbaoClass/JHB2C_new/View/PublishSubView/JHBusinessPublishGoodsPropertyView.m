//
//  JHBusinessPublishGoodsPropertyView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishGoodsPropertyView.h"
#import "JHC2CPickView.h"
#import "JHBusinessGoodsAttributeModel.h"

@interface JHBusinessPublishGoodsPropertyView ()
@property(nonatomic, strong) UIImageView * starImageView;
@property(nonatomic, strong) UILabel * propetyLabel;
@property(nonatomic, strong) NSMutableArray * propetyLabelArray;
@end
@implementation JHBusinessPublishGoodsPropertyView

- (instancetype)initWithFrame:(CGRect)frame withModelArr:(NSArray<BackAttrRelationResponse*>*)arr{
    self = [super initWithFrame:frame];
    if (self) {

        [self setItems];
    }
    return self;
}

- (void)setItems{
    
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    [self creatUI];

}


- (void)creatUI{
    UILabel * cateLabel = [[UILabel alloc] init];
    cateLabel.font = JHMediumFont(15);
    cateLabel.textColor = HEXCOLOR(0x222222);
    cateLabel.text = @"商品分类";
    [self addSubview:cateLabel];
    [cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.height.equalTo(@22);
        make.left.equalTo(@0).offset(12);
    }];
    [self addSubview:self.starImageView];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cateLabel);
        make.left.equalTo(cateLabel.mas_right).offset(2);
    }];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cateLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    UIControl * control = [[UIControl alloc] init];
    [self addSubview:control];
    [control addTarget:self action:@selector(controlAction1) forControlEvents:UIControlEventTouchUpInside];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    self.seleLabel = [[UILabel alloc] init];
    self.seleLabel.font = JHFont(13);
    self.seleLabel.textColor = HEXCOLOR(0x999999);
    self.seleLabel.text = @"请选择商品分类";
    [control addSubview:self.seleLabel];
    [self.seleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.height.equalTo(@22);
        make.left.equalTo(@0);
    }];
    UIImageView * seleImage = [[UIImageView alloc] init];
    seleImage.image = [UIImage imageNamed:@"icon_cell_arrow"];
    [control addSubview:seleImage];
    [seleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(18);
        make.right.equalTo(self).inset(10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];

    
    self.propetyLabel = [[UILabel alloc] init];
    self.propetyLabel.font = JHMediumFont(15);
    self.propetyLabel.textColor = HEXCOLOR(0x222222);
    self.propetyLabel.text = @"商品属性";
    [self addSubview:self.propetyLabel];
    [self.propetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(14);
        make.height.equalTo(@22);
        make.left.equalTo(@0).offset(12);
    }];
    
    UIControl * control2 = [[UIControl alloc] init];
    [self addSubview:control2];
    [control2 addTarget:self action:@selector(controlAction2) forControlEvents:UIControlEventTouchUpInside];
    [control2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
        make.top.equalTo(line);
        make.bottom.equalTo(@0).offset(-12);
    }];
    
    self.seleLabel2 = [[UILabel alloc] init];
    self.seleLabel2.font = JHFont(13);
    self.seleLabel2.textColor = HEXCOLOR(0x999999);
    self.seleLabel2.text = @"请选择商品属性";
    [control2 addSubview:self.seleLabel2];
    [self.seleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0);
        make.height.equalTo(@22);
    }];
    UIImageView * seleImage2 = [[UIImageView alloc] init];
    seleImage2.image = [UIImage imageNamed:@"icon_cell_arrow"];
    [control2 addSubview:seleImage2];
    [seleImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(18);
        make.right.equalTo(self).inset(10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
}

- (void)resetGoodsCate:(NSString *)cateStr{
    self.seleLabel.textColor = HEXCOLOR(0x222222);
    self.seleLabel.text = cateStr;
    [self.seleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.height.equalTo(@22);
        make.right.equalTo(@-30);
    }];
}

- (void)resetGoodsAttribute:(NSString *)cateStr{
    self.seleLabel2.textColor = HEXCOLOR(0x222222);
    self.seleLabel2.text = cateStr;
    [self.seleLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.height.equalTo(@22);
        make.right.equalTo(@-30);
    }];
}

- (void)controlAction1{
    [self.superview endEditing:YES];
    if (self.btnClickedBlock2) {
        self.btnClickedBlock2();
    }
    
}
- (void)controlAction2{
    [self.superview endEditing:YES];
    if (self.btnClickedBlock) {
        self.btnClickedBlock();
    }
}
- (void)reloadNullProperty{
    for (UIView * view in self.propetyLabelArray) {
        [view removeFromSuperview];
    }
    self.seleLabel2.textColor = HEXCOLOR(0x999999);
    self.seleLabel2.text = @"请选择商品属性";
    [self.seleLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0);
        make.height.equalTo(@22);
    }];
}
- (void)reloadWithArray:(NSArray *)array{
    
    for (UIView * view in self.propetyLabelArray) {
        [view removeFromSuperview];
    }
    NSMutableArray * showArray = [[NSMutableArray alloc] init];
    for (JHBusinessGoodsAttributeModel *temp in array) {
        if (temp.showValue.length>0) {
            [showArray addObject:temp];
        }
    }
    if (showArray.count>0) {
        [self resetGoodsAttribute:@"已选择"];
    }
    for (int i = 0; i<showArray.count; i++) {
        JHBusinessGoodsAttributeModel *temp = showArray[i];
        UILabel * propetyLabel = [[UILabel alloc] init];
        propetyLabel.font = JHMediumFont(15);
        propetyLabel.textColor = HEXCOLOR(0x222222);
        propetyLabel.text = temp.attrName;
        propetyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:propetyLabel];
        [propetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(100+i*30);
            make.height.equalTo(@40);
            make.width.equalTo(@85);
            make.left.equalTo(@0).offset(0);
            if (i == showArray.count-1) {
                make.bottom.equalTo(@0).offset(-12);
            }
        }];
        
        if (temp.attrRequired == 1) {
            UIImageView *starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
            [self addSubview:starImage];
            [starImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(propetyLabel);
                make.left.mas_equalTo(propetyLabel.mas_right).offset(2);
            }];
            [self.propetyLabelArray addObject:starImage];
        }
        
        
        UILabel * valueLabel = [[UILabel alloc] init];
        valueLabel.font = JHFont(15);
        valueLabel.textColor = HEXCOLOR(0x222222);
        valueLabel.text = temp.showValue;
        if([temp.showValue containsString:@"其它-"]){
            valueLabel.text = [temp.showValue substringFromIndex:3];
        }
        [self addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(propetyLabel.mas_right).offset(30);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self).offset(100+i*30);
            make.height.equalTo(@40);
        }];
        [self.propetyLabelArray addObject:propetyLabel];
        [self.propetyLabelArray addObject:valueLabel];
    }
}
#pragma mark -- <set and get>
- (UIImageView *)starImageView{
    if (!_starImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
        _starImageView = view;
    }
    return _starImageView;
}
- (NSMutableArray *)propetyLabelArray{
    if (!_propetyLabelArray) {
        _propetyLabelArray = [[NSMutableArray array] init];
    }
    return _propetyLabelArray;
}
@end
