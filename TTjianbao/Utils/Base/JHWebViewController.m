//
//  JHWebViewController.m
//  TTjianbao
//
//  Created by apple on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHWebViewController.h"
#import "PanNavigationController.h"
@interface JHWebViewController ()

@end

@implementation JHWebViewController

- (void)backActionButton:(UIButton *)sender
{
    if(self.navigationController == nil){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.isNeedPop) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.isNeedPoptoRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        if (self.webView.canGoBack == YES) {
            [self.webView goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)showRightHelpButtonTitle:(NSString *)title targetUrl:(NSString *)targetUrl
{
    [self initRightButtonWithName:title action:@selector(helpAction)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 44));
    }];
    self.jhRightButton.jh_fontNum(13);
    
    @weakify(self);
    [[self.jhRightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        NSString *prefixStr = @"javascript:";
        if ([targetUrl hasPrefix:prefixStr]) {
            NSString *funcStr = [targetUrl substringFromIndex:prefixStr.length];
            [self.webView jh_nativeCallJSMethod:funcStr param:@""];
        } else {
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.title = title;
            vc.urlString = targetUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

-(void)helpAction{}

- (void)shareAction:(UIButton *)btn {
    [self.webView jh_nativeCallJSMethod:@"doShare" param:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_BACKGROUND_COLOR;

    [self initLeftButton];
    
    self.jhNavView.hidden = self.isHiddenNav;
    if (self.htmlString) {
        [self.webView jh_loadWithHtml:self.htmlString];

    }else if (self.urlString){
        [self.webView jh_loadWebURL:self.urlString];
    }
    
    RAC(self,title) = RACObserve(self.webView, title);
    @weakify(self)
    self.webView.jh_webViewDidFailBlock = ^(JHBaseWKWebView * _Nullable webView) {
        @strongify(self)
        if (self.jhNavView.hidden) {
            self.jhNavView.hidden = false;
        }
    };
    
}

- (void)popGestureRecognizerClose:(BOOL)isClose
{
    if(self.urlString && IS_STRING(self.urlString) && [self.urlString containsString:@"slideBack=false"])
    {
        if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
            PanNavigationController *nav = (PanNavigationController *)self.navigationController;
            nav.isForbidDragBack = isClose;
            [nav setShouldReceiveTouchViewController:isClose ? self : nil];
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self popGestureRecognizerClose:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self popGestureRecognizerClose:YES];
}

#pragma mark - LAZY

- (JHWebView *)webView
{
    if(!_webView)
    {
        JHWebView *webView = [JHWebView new];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self.view);
            make.top.equalTo(self.view).offset(self.isHiddenNav ? UI.statusBarHeight : UI.statusAndNavBarHeight);
        }];
        @weakify(self);
        webView.closeViewOrVC = ^{
            @strongify(self);
            if (self.navigationController == nil) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        webView.titleChangeBlock = ^(NSString * _Nonnull title) {
            @strongify(self);
            self.title = title;
        };
        webView.showShareButtonBlock = ^{
            @strongify(self);
            [self initRightButtonWithImageName:@"navi_icon_share_black" action:@selector(shareAction:)];
        };
        webView.showHelpButtonBlock = ^(NSString * _Nonnull title, NSString * _Nonnull target) {
            @strongify(self);
            [self showRightHelpButtonTitle:title targetUrl:target];
        };
        webView.hidenNavi = ^(BOOL isHiden) {
            @strongify(self)
            self.jhNavView.hidden = isHiden;
            [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(isHiden ? 0 : UI.statusAndNavBarHeight);
            }];
        };
        _webView = webView;
        
    }
    return _webView;
}
#pragma mark - js 交互方法
//
//- (appIOS *)object {
//    if (!_object) {
//        _object = [[appIOS alloc] init];
//        MJWeakSelf
//        _object.operateCloseWeb = ^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        };
//        _object.operateOpenWeb = ^(OpenWebModel * _Nonnull model) {
//            [weakSelf openNewWeb:model];
//        };
//        _object.operateSetTitle = ^(NSString * _Nonnull title) {
//            if (weakSelf.navbar) {
//                [weakSelf.navbar setTitle:title];
//            }
//        };
//
//        _object.operatePrivateMsg = ^(NSString * _Nonnull param) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePrivateSocketMsg object:param];
//        };
//
//        _object.operateCallBack = ^(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull data) {
//            if (callname.length) {
//                [weakSelf.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@','%@')",callname,tag,data]];
//            }
//        };
//
//        _object.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
//            if (weakSelf.operateGetRoomInfo) {
//                return  weakSelf.operateGetRoomInfo(callname, tag, param);
//            }
//            return @"";
//        };
//        _object.operateShowRightHelpButton = ^(NSString * _Nonnull title, NSString * _Nonnull toUrl) {
//            [weakSelf showRightHelpButtonTitle:title targetUrl:toUrl];
//        };
//        _object.operateStartNative = ^(NSString * _Nonnull type, NSString * _Nonnull param) {
//            NSLog(@"type - %@  param : - %@", type, param);
//
//
//        };
//
//        _object.operateShowShareBtn = ^(NSString * _Nonnull string) {
//            [weakSelf showShareBtn];
//        };
//        _object.operateHideClose = ^(NSString * _Nonnull string) {
//            weakSelf.closeBtn.hidden = YES;
//        };
//
//        _object.operateShowImage = ^(NSInteger index, NSArray * _Nonnull thumArray, NSArray * _Nonnull imageArray) {
//            NSMutableArray *arr = [NSMutableArray array];
//            for (int i = 0; i < thumArray.count; i ++) {
//                UIImageView *imgView = [[UIImageView alloc] init];
//                [arr addObject:imgView];
//            }
//            [JHPhotoBrowserManager showPhotoBrowserThumbImages:thumArray origImages:imageArray sources:arr.copy currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleNone];
//        };
//
//        @weakify(self);
//        _object.operateShowInputView = ^(NSString * _Nonnull callname) {
//            @strongify(self);
//            [self showInputTextWithCallName:callname];
//        };
//    }
//    return _object;
//}
//
//-(void)showInputTextWithCallName:(NSString *)callName
//{
//    if(IS_LOGIN){
//        JHInputTextView *textView = [[JHInputTextView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:textView];
//        [textView starInput];
//        @weakify(self);
//        @weakify(textView);
//        textView.inputTextViewBlock = ^(NSString * _Nonnull text) {
//            @strongify(self);
//            @strongify(textView);
//
//            if(callName && callName.length) {
//                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('comment','%@')",callName,text]];
//            }
//            [textView endEditing:YES];
//            [textView removeFromSuperview];
//        };
//    }
//
//}
- (void)openNewWeb:(OpenWebModel *)model {
    if ([model.target isEqualToString:@"blank"]) {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.isHiddenNav = (model.windowSizetype == 2 || model.fullScreen);
        vc.urlString = model.url;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.target isEqualToString:@"self"]) {
        JHWebView *web = [[JHWebView alloc] init];
        [self.view addSubview:web];
        web.model = model;
    }
}


@end

