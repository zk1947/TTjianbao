//
//  JHPublishReportTrueOtherCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportTrueOtherCell.h"

@interface JHPublishReportTrueOtherCell ()

@end

@implementation JHPublishReportTrueOtherCell

- (void)addSelfSubViews {
    
    _priceTf = [JHPublishReportTrueOtherCell creatTextFieldWithTitle:@"价格" placeHolder:@"请输入预估价格" top:15 addSupView:self.contentView];
    
    _descTf = [JHPublishReportTrueOtherCell creatTextFieldWithTitle:@"报告" placeHolder:@"请输入评估报告" top:15 + 45 addSupView:self.contentView];
    
    @weakify(self);
    [_priceTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if(self.priceBlock) {
            self.priceBlock(x);
        }
    }];
    
    [_descTf.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if(self.descBlock) {
            self.descBlock(x);
        }
    }];
}

+ (UITextField *)creatTextFieldWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder top:(CGFloat)top addSupView:(UIView *)superView {
    
    UIView *view = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:superView];
    [view jh_cornerRadius:2 borderColor:RGB(218, 218, 218) borderWidth:0.5];
    
    UITextField *tf = [UITextField jh_textFieldWithFont:13 textAlignment:0 textColor:RGB515151 placeholderText:placeHolder placeholderColor:RGB153153153 addToSupView:view];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    UILabel *label = [UILabel jh_labelWithFont:14 textColor:RGB515151 addToSuperView:superView];
    label.text = title;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(15);
        make.height.mas_equalTo(35);
        make.top.equalTo(superView).offset(top);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(53);
        make.right.equalTo(superView).offset(-15);
        make.centerY.height.equalTo(label);
    }];
    
    return tf;
}

@end
