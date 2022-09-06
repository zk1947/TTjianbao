//
//  JHPublishReportFalseCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportFalseCell.h"

@interface JHPublishReportFalseCell ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation JHPublishReportFalseCell

- (void)addSelfSubViews {
    _buttonArray = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton jh_buttonWithTitle:@"" fontSize:13 textColor:RGB102102102 target:self action:@selector(clickbuttonMethod:) addToSuperView:self.contentView];
        button.tag = 2000 + i;
        [button jh_cornerRadius:16.f];
        button.backgroundColor = RGB(245,245,245);
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(15 + 44 * i);
            make.height.mas_equalTo(32);
        }];
        [_buttonArray addObject:button];
    }
}

- (void)clickbuttonMethod:(UIButton *)sender {
    if(_clickBlock) {
        _clickBlock(_reasonArray[sender.tag - 2000]);
    }
    for (UIButton *b in self.buttonArray) {
        b.backgroundColor = RGB(245,245,245);
    }
    
    sender.backgroundColor = RGB(252, 236, 157);
}

- (void)reset {
    for (UIButton *b in self.buttonArray) {
        b.backgroundColor = RGB(245,245,245);
    }
}

- (void)setReasonArray:(NSMutableArray *)reasonArray {
    if(IS_ARRAY(_reasonArray) && _reasonArray.count == 3) {
        _reasonArray = reasonArray;
    }
    else {
        _reasonArray = [NSMutableArray arrayWithObjects:@"因涉及到年份因素，不予估价",@"该物品为原石类物品，不予估计",@"因环境条件所限，无法准确界定，不予估价", nil];
    }
    _reasonArray = reasonArray;
        NSInteger i = 0;
    for (NSString *title in _reasonArray) {
        if(IS_STRING(title)) {
            UIButton *button = _buttonArray[i];
            [button setTitle:title forState:UIControlStateNormal];
        }
        i++;
    }
}

@end
