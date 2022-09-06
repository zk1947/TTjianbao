//
//  JHC2CSureMoneyAlertController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSureMoneyAlertController.h"

@interface JHC2CSureMoneyAlertController ()

@property(nonatomic, strong) UIButton * closeBtn;
@end

@implementation JHC2CSureMoneyAlertController

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jhNavView.hidden = YES;
    self.view.backgroundColor = UIColor.clearColor;
    UIButton *backView = [UIButton new];
    backView.backgroundColor = UIColor.whiteColor;
    backView.layer.cornerRadius = 10;
    [self.view addSubview:backView];
    CGFloat height = 209 + UI.bottomSafeAreaHeight + 220;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0).offset(10);
        make.height.mas_equalTo(height);
    }];

    
    [backView addSubview:self.closeBtn];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    UILabel *titleLbl = [self getLabelWithFont:JHMediumFont(16) andColor:HEXCOLOR(0x222222) andText:@"买家参拍保证金"];
    [backView addSubview:titleLbl];

    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(16);
        make.centerX.equalTo(@0);
    }];

    NSString* str = @"保证金是指，为了保证交易的正常开展，商家（又称“卖家”）要求买家缴纳的用于提供履约保证的资金。如缴纳保证金的一方出现违约、违规等行为，天天鉴宝将扣除买家保证金并赔偿给卖家98%，2%作为交易手续费。";
    UILabel *detailLbl = [self getLabelWithFont:JHFont(13) andColor:HEXCOLOR(0x666666) andText:str];
    detailLbl.numberOfLines = 0;
    [backView addSubview:detailLbl];

    [detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom).offset(31);
        make.left.right.equalTo(@0).inset(15);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeAction];
}
- (void)closeAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (UILabel*)getLabelWithFont:(UIFont*)font andColor:(UIColor*)color andText:(NSString*)text{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    label.text = text;
    return label;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"orderPopView_closeIcon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
