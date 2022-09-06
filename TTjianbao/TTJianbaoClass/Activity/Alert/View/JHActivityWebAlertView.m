//
//  JHActivityWebAlertView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/10/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHActivityWebAlertView.h"
#import "JHWebView.h"
@interface JHActivityWebAlertView ()

@property (nonatomic, strong) JHWebView *webView;
@end

@implementation JHActivityWebAlertView

+ (void)showWithUrl : (NSString *)url {
    JHActivityWebAlertView *view = [[JHActivityWebAlertView alloc] initWithFrame:CGRectZero];
    view.urlString = url;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    @weakify(view)
    view.webView.jh_webViewDidFinishBlock = ^(JHBaseWKWebView * _Nullable webView) {
        @strongify(view)
        [window bringSubviewToFront:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    };
    [window addSubview:view];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)dealloc {
    
}
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    @weakify(self)
    self.webView.jh_webViewDidFailBlock = ^(JHBaseWKWebView * _Nullable webView) {
        @strongify(self )
        [self removeFromSuperview];
    };
}
#pragma mark - LAZY
- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    if (_urlString) {
        [self.webView jh_loadWebURL:self.urlString];
    }
}
- (JHWebView *)webView {
    if(!_webView)
    {
        JHWebView *webView = [JHWebView new];
        [self addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.top.equalTo(self).offset(0);
        }];
        @weakify(self);
        webView.closeViewOrVC = ^{
            @strongify(self);
            [self removeFromSuperview];
        };
        _webView = webView;
    }
    return _webView;
}
@end
