//
//  JHStoneDetailFamilyCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailFamilyCell.h"


@implementation JHStoneDetailFamilyCell

-(void)addSelfSubViews
{
    UIView *view1 = [self creatTipViewWithTitle:@"已成交" color:RGB(252, 66, 0) addToSuperview:self.contentView];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.top.equalTo(self.contentView).offset(5.f);
    }];
    
    UIView *view2 = [self creatTipViewWithTitle:@"寄售中" color:RGB(7, 189, 104) addToSuperview:self.contentView];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right).offset(10.f);
        make.top.equalTo(view1);
    }];
    
    UIView *view3 = [self creatTipViewWithTitle:@"寄回" color:RGB(238,238,238) addToSuperview:self.contentView];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_right).offset(10.f);
        make.top.equalTo(view1);
    }];
    
    UIButton *button = [UIButton jh_buttonWithImage:@"stone_detail_look_info" target:self action:@selector(lookInfoAction) addToSuperView:self.contentView];
    button.jh_title(@"查看大图").jh_font([UIFont systemFontOfSize:13]).jh_titleColor(RGB(51, 51, 51));
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, -55);
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(40.f);
    }];

    
    JHWebView *webview = [[JHWebView alloc] init];
    webview.tag = 22;
    [self.contentView addSubview:webview];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.top.equalTo(view1.mas_bottom).offset(15);
        make.bottom.equalTo(button.mas_top).offset(-15);
        make.height.mas_equalTo(200);
    }];
    self.webView = webview;
    [self loadWebPathString];

}

#pragma mark ---------------------------- action ----------------------------
-(void)lookInfoAction
{
    if(_enterFamilyTreeMethod){
        _enterFamilyTreeMethod();
    }
}

#pragma mark ---------------------------- method ----------------------------
-(UIView *)creatTipViewWithTitle:(NSString *)title color:(UIColor *)color addToSuperview:(UIView *)superView
{
    UIView *view = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:superView];
    
    UILabel *label = [UILabel jh_labelWithText:title font:12 textColor:RGB(102, 102, 102) textAlignment:1 addToSuperView:view];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(view);
    }];
    
    UIView *colorView = [UIView jh_viewWithColor:color addToSuperview:view];
    [colorView jh_cornerRadius:3.f];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(3);
        make.right.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(48, 6));
        make.centerY.equalTo(label);
    }];
    return view;
}

-(void)loadWebPathString{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"familyHtml/passOnApp" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [self.webView loadFileURL:url allowingReadAccessToURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"familyHtml" ofType:nil]]];

}

@end
