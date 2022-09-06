//
//  JHB2CShowProductIntruductView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/8/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHB2CShowProductIntruductView.h"
#import "JHStoreDetailBusiness.h"


@interface JHB2CShowProductIntruductView()<WKNavigationDelegate>

@property(nonatomic, strong) UIButton * backViewBtn;

@property(nonatomic, strong) UIButton * closeBtn;

@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) WKWebView * webView;

@property(nonatomic, strong) UIButton * sureBtn;


@end

@implementation JHB2CShowProductIntruductView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.4);
        
        [self addSubview:self.backViewBtn];
        [self.backViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
//            make.height.equalTo(@500);
        }];
        [self.backViewBtn addSubview:self.closeBtn];
        [self.backViewBtn addSubview:self.titleLbl];
        [self.backViewBtn addSubview:self.webView];
        self.backViewBtn.hidden = true;
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = UIColor.whiteColor;
        [bottomView addSubview:self.sureBtn];
        [self.backViewBtn addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
            make.left.bottom.right.equalTo(@0);
        }];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(15);
            make.left.right.equalTo(@0).inset(30);
            make.centerX.equalTo(@0);
        }];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0).inset(15);
            make.centerY.equalTo(self.titleLbl);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];

        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).offset(15);
            make.left.right.equalTo(@0).inset(15);
            make.bottom.equalTo(bottomView.mas_top);
        }];

        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150, 44));
            make.centerX.equalTo(@0);
            make.top.equalTo(@0).offset(18);
        }];
        
        [RACObserve(self.webView.scrollView, contentSize) subscribeNext:^(id  _Nullable x) {
            NSValue *value = x;
            CGSize size = [value CGSizeValue];
            if (size.width < kScreenWidth) {
                CGFloat minHeight = fmin(410.f, size.height);
                if (minHeight < 63.f) {
                    minHeight = 63.f;
                }
                [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.titleLbl.mas_bottom).offset(15);
                    make.left.right.equalTo(@0).inset(15);
                    make.height.mas_equalTo(minHeight);
                    make.bottom.equalTo(bottomView.mas_top);
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.backViewBtn.hidden = false;
                });
            }
        }];
    }
    return self;
}

- (void)setProductID:(NSString *)productID{
    _productID = productID;
    [JHStoreDetailBusiness requestQueryAttrDecsContentByAttrId:self.productID completion:^(NSError * _Nullable error, JHProductIntrductModel * _Nullable model) {
        [self.webView loadHTMLString:model.attrDescContent baseURL:nil];
    }];
}
- (void)setAttTitle:(NSString *)attTitle{
    _attTitle = attTitle;
    self.titleLbl.text = attTitle;
}

- (void)closeActionWithSender{
    [self removeFromSuperview];
}


- (void)sureActionWithSender{
    [self closeActionWithSender];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeActionWithSender];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
     [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '230%'"completionHandler:nil];
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'"completionHandler:nil];
}

- (UIButton *)backViewBtn{
    if (!_backViewBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = HEXCOLOR(0xFFFFFF);
        btn.layer.cornerRadius = 8;
        _backViewBtn = btn;
    }
    return _backViewBtn;
}


- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"orderPopView_closeIcon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeActionWithSender) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(17);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"作用说明";
        label.textAlignment = NSTextAlignmentCenter;
        _titleLbl = label;
    }
    return _titleLbl;
}


- (UIButton *)sureBtn{
    if (!_sureBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 22;
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        [btn setTitle:@"知道了" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(15);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sureActionWithSender) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn = btn;
    }
    return _sureBtn;
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebView *web = [[WKWebView alloc] init];
        web.navigationDelegate = self;
//        label.font = JHFont(14);
//        label.textColor = HEXCOLOR(0x666666);
//        label.numberOfLines = 0;
        _webView = web;
    }
    return _webView;
}

@end
