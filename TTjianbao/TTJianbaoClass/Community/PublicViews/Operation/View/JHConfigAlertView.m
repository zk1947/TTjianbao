//
//  JHConfigAlertView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHConfigAlertView.h"
#import "UIImage+JHColor.h"

@interface JHConfigAlertView ()

@property (nonatomic, copy) dispatch_block_t complete;

@end


@implementation JHConfigAlertView

+ (void)jh_showConfigAlertViewWithBanned:(BOOL)isBanned
                                typeName:(NSString *)typeName
                                  reason:(NSString *)reason
                                timeType:(NSInteger )timeType
                                complete:(dispatch_block_t)complete {

    JHConfigAlertView *alert = [JHConfigAlertView jh_viewWithColor:RGBA(0, 0, 0, 0.5) addToSuperview:JHKeyWindow];
    alert.frame = JHKeyWindow.bounds;
    alert.complete = complete;
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:alert];
    [whiteView jh_cornerRadius:8];
    CGFloat height = (isBanned ? 0 : 30);
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alert);
        make.size.mas_equalTo(CGSizeMake(260, 228 - height));
    }];
    
    UILabel *titleLabel = [UILabel jh_labelWithBoldText:[NSString stringWithFormat:@"确认队这篇内容进行%@操作",typeName] font:15 textColor:RGB515151 textAlignment:1 addToSuperView:whiteView];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(whiteView).offset(30);
        make.right.equalTo(whiteView).offset(-30);
    }];
    
    UILabel *titleLabel2 = [UILabel jh_labelWithText:[NSString stringWithFormat:@"理由为：%@",reason] font:15 textColor:RGB515151 textAlignment:1 addToSuperView:whiteView];
    titleLabel2.adjustsFontSizeToFitWidth = YES;
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(titleLabel);
    }];
    
    if(isBanned)
    {
        NSString *day = @"永久";
        if(timeType > 0)
        {
            day = [NSString stringWithFormat:@"天数：%@天",@(timeType)];
        }
        UILabel *titleLabel3 = [UILabel jh_labelWithText:day font:15 textColor:RGB515151 textAlignment:1 addToSuperView:whiteView];
        titleLabel3.adjustsFontSizeToFitWidth = YES;
        [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel2.mas_bottom).offset(12);
            make.left.right.equalTo(titleLabel);
        }];
    }
    
    UIButton *configButton = [UIButton jh_buttonWithTitle:@"确认提交" fontSize:15 textColor:RGB515151 target:alert action:@selector(configAction) addToSuperView:whiteView];
    [configButton setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(200, 40) radius:20] forState:UIControlStateNormal];
    [configButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.bottom.equalTo(whiteView).offset(-65);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    UIButton *cancleButton = [UIButton jh_buttonWithTitle:@"取消" fontSize:15 textColor:RGB515151 target:alert action:@selector(removeFromSuperview) addToSuperView:whiteView];
    [cancleButton jh_cornerRadius:20 borderColor:RGB(189, 191, 194) borderWidth:1];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.height.equalTo(configButton);
        make.bottom.equalTo(whiteView).offset(- 15);
    }];
}

- (void)configAction {
    if(self.complete)
    {
        self.complete();
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
