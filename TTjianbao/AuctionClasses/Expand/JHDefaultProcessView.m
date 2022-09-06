//
//  JHDefaultProcessView.m
//  TTjianbao
//
//  Created by apple on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDefaultProcessView.h"
#import "MBProgressHUD.h"

@interface JHDefaultProcessView()
@property(nonatomic,strong)MBProgressHUD *processView;
@property(nonatomic,strong)UIView *superV;
@end

@implementation JHDefaultProcessView
static JHDefaultProcessView *instance = nil;
+ (JHDefaultProcessView *)shareInstance{
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        instance = [[JHDefaultProcessView alloc] init];
    });
    
    return instance;
}
//- (instancetype)init
//{
//    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    if (self) {
//        self.backgroundColor = RGBA(0, 0, 0, 0.6);
//        [self creatAppealAlertView];
//    }
//    return self;
//}
-(void)showProgressHUDWithProgress:(CGFloat)progress{

    CGFloat proF = [NSString stringWithFormat:@"%.2f",progress].floatValue;
    NSString *proS = [NSString stringWithFormat:@"%.0f",proF*100];
//    self.processView.label.text = [NSString stringWithFormat:@"加载中 %@%%",proS];
    self.processView.progress = proF;
}

-(void)showProgressHUDSuperView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.superV = view;
        [view addSubview:self.processView];
        [self showProgressHUDWithProgress:0];
    });
    
}
-(void)hideProgressHUD{

    if (_processView != nil) {
        _processView.removeFromSuperViewOnHide = YES;
        [_processView hideAnimated:YES];
    }
}
-(MBProgressHUD *)processView{
    if (!_processView) {
        _processView = [[MBProgressHUD alloc] initWithView:self.superV];
        _processView.mode = MBProgressHUDModeDeterminate;
        _processView.removeFromSuperViewOnHide = YES;
        [_processView showAnimated:YES];
        //设置菊花框为白色
        _processView.contentColor = [UIColor whiteColor];
        //背景色黑色半透明
        _processView.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _processView.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _processView.label.font = [UIFont systemFontOfSize:15];
        _processView.label.textColor = kColorFFF;
    }
    return _processView;
}
@end
