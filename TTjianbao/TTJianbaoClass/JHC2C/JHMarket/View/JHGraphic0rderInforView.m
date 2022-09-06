//
//  JHGraphic0rderInforView.m
//  TTjianbao
//
//  Created by miao on 2021/6/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphic0rderInforView.h"

@interface JHGraphic0rderInforView ()

@property (nonatomic , weak) UILabel *titleLable;


@end

@implementation JHGraphic0rderInforView

- (void)p_addTitleLable {
    
    UILabel *titleLable = [UILabel jh_labelWithFont:13 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
    titleLable.text = @"订单信息";
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    _titleLable = titleLable;
    
}

- (UIButton *)p_getCopyOrderNumberButton {
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
   [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:HEXCOLOR(0x408ffe) forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [copyButton addTarget:self action:@selector(p_copyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return copyButton;
}

- (void)p_copyButtonClick {
    if (self.copyOrderNumberBlock) {
        self.copyOrderNumberBlock();
    }
}

- (void)updateGraphic0rderInforView:(NSArray <NSString *> *)titles {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self p_addTitleLable];
    
    UIView *lastView = _titleLable;
    for (NSInteger titleNum = 0; titleNum < titles.count; titleNum ++ ) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        UILabel *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = HEXCOLOR(0xFF666666);
        [bgView addSubview:title];
        [title setText:[titles objectAtIndex:titleNum]];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lastView.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(10);
            make.top.equalTo(bgView);
            make.centerY.equalTo(bgView);
        }];
        
        if (titleNum == 0) {
            UIButton *copyButton = [self p_getCopyOrderNumberButton];
            [bgView addSubview:copyButton];
            [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(15);
                make.centerY.equalTo(bgView);
                make.size.mas_equalTo(CGSizeMake(35, 15));
            }];
        }
        
        lastView = bgView;
    }
}

@end
