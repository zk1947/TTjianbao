//
//  JHTaskHUD.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTaskHUD.h"
#import "JHUserTitleUpHUD.h"
#import "JHOldUserTitleUpHUD.h"
#import "YYKit.h"
#import <YDCategoryKit/YDCategoryKit.h>

#import "JHWebViewController.h"


#define kHudTag (999)

@interface JHTaskHUD ()
@property (nonatomic, strong) UIView *contentView;
@end


@implementation JHTaskHUD

+ (void)showTitle:(NSString *)title desc:(NSString *)desc toNum:(NSInteger)toNum {
    UIView *hudV = [JHKeyWindow viewWithTag:kHudTag];
    if (hudV) {
        [hudV removeFromSuperview];
        hudV = nil;
    }
    JHTaskHUD *hud = [[JHTaskHUD alloc] initWithTitle:title desc:desc];
    hud.to = toNum;
    [hud show];
}

//正常称号升级提示
+ (void)showUserTitleUp:(NSString *)title desc:(NSString *)desc {
    [JHUserTitleUpHUD showTitle:title desc:desc];
}

//老用户升级提示
+ (void)showOldUserTitleUp:(NSString *)title desc:(NSString *)desc levelIcon:(NSString *)levelIcon {
    [JHOldUserTitleUpHUD showTitle:title desc:desc levelIcon:levelIcon];
}

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc {
    self = [super init];
    if (self) {
        //size
        CGSize titleSize = [title getSizeWithFont:[UIFont fontWithName:kFontNormal size:17.0] constrainedToSize:CGSizeMake(ScreenWidth-80, 25.0)];
        CGSize descSize = [desc getSizeWithFont:[UIFont fontWithName:kFontNormal size:15.0] constrainedToSize:CGSizeMake(ScreenWidth-80, 22.0)];
        CGFloat contentW = descSize.width >= titleSize.width ? descSize.width + 30.0 : titleSize.width + 30.0;
        
        //descSize = [desc sizeForFont:[UIFont fontWithName:kFontNormal size:15.0] size:CGSizeMake(ScreenWidth-80, 25.0) mode:NSLineBreakByTruncatingTail];
        
        //label
        UILabel *titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:17.0] textColor:[UIColor colorWithHexString:@"FEE100"]];
        titleLabel.frame = CGRectMake(0, 20, contentW, 25.0);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        
        UILabel *descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15.0] textColor:[UIColor whiteColor]];
        descLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+3.0, contentW, 22.0);
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.text = desc;
        
        //contentView
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentW, 90.0)];
        _contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _contentView.center = JHKeyWindow.center;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentView.layer.cornerRadius = 8.0;
        _contentView.layer.masksToBounds = YES;
        _contentView.tag = kHudTag;
        _contentView.alpha = 0;
        
        [_contentView addSubview:titleLabel];
        [_contentView addSubview:descLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView)];
        [_contentView addGestureRecognizer:tap];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:)
//                                                     name:UIDeviceOrientationDidChangeNotification
//                                                   object:[UIDevice currentDevice]];

        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
            @strongify(self);
            [self hideAnimation];
        }];
    }
    return self;
}


//- (void)deviceOrientationDidChanged:(NSNotification *)notify {
//    [self hideAnimation];
//}

#pragma mark -
#pragma mark pravite methods
- (void)show {
    _contentView.center = JHKeyWindow.center;
    [JHKeyWindow addSubview:_contentView];
    [JHKeyWindow bringSubviewToFront:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:3.0];
}

- (void)showAnimation {
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.contentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)hideAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

- (void)dismiss {
    [_contentView removeFromSuperview];
    _contentView = nil;
}

- (void)tapContentView {
    if (self.to == 1) {
        //进入任务中心
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVC];
            return;
        }
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.titleString = @"任务中心";
        vc.urlString = H5_BASE_STRING(@"/jianhuo/app/myTitle.html");
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    [self hideAnimation];
}

- (void)dealloc {
    DDLogDebug(@"JHTaskHUD::dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
