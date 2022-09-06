//
//  JHUserTitleUpHUD.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUserTitleUpHUD.h"
#import "JHWebViewController.h"

#import "NSMutableAttributedString+Html.h"


@interface JHUserTitleUpHUD ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation JHUserTitleUpHUD

+ (void)showTitle:(NSString *)title desc:(NSString *)desc {
    JHUserTitleUpHUD *hud = [[JHUserTitleUpHUD alloc] initWithFrame:[UIScreen mainScreen].bounds title:title desc:desc];
    [hud show];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        CGFloat contentViewH = 345.0;
        
        _contentView = [UIView new];
        _contentView.frame = CGRectMake(0, 0, ScreenWidth, contentViewH);
        _contentView.centerY = self.centerY;
        _contentView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_contentView addGestureRecognizer:tapContent];
        //_contentView.userInteractionEnabled = NO;
        
        //1.
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_icon_upgrade"]];
        imgView.top = 0;
        imgView.centerX = _contentView.centerX;
        imgView.size = CGSizeMake(194, 177);
        [_contentView addSubview:imgView];
        
        //2.
        UILabel *titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:24] textColor:[UIColor colorWithHexString:@"FEE100"]];
        titleLabel.top = CGRectGetMaxY(imgView.frame) + 5.0;
        titleLabel.left = 15.0;
        titleLabel.size = CGSizeMake(ScreenWidth-30, 45);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [_contentView addSubview:titleLabel];
        
        //3.
        NSMutableAttributedString *textStr = [NSMutableAttributedString yd_loadHtmlString:desc];
        textStr.font = [UIFont fontWithName:kFontNormal size:14];
        textStr.alignment = NSTextAlignmentCenter;
        textStr.lineSpacing = 2.0;
        //textStr.paragraphSpacing = 5.0;
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) text:textStr];
        YYLabel *textLabel = [YYLabel new];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.top = CGRectGetMaxY(titleLabel.frame);
        textLabel.left = 15.0;
        textLabel.size = CGSizeMake(ScreenWidth-30, layout.textBoundingSize.height);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        textLabel.numberOfLines = 0;
        //textLabel.attributedText = textStr;
        textLabel.textLayout = layout; //赋值
        [_contentView addSubview:textLabel];
        
        //button
        CGFloat btnW = 140;
        CGFloat btnH = 45;
        
        UIButton *leftBtn = [UIButton buttonWithTitle:@"知道了" titleColor:kColorMain];
        leftBtn.top = textLabel.bottom + 25.0;
        leftBtn.left = (ScreenWidth - btnW*2 - 25)/2;
        leftBtn.size = CGSizeMake(btnW, btnH);
        leftBtn.layer.borderColor = kColorMain.CGColor;
        leftBtn.layer.borderWidth = 1.0;
        leftBtn.layer.cornerRadius = 4.0;
        leftBtn.layer.masksToBounds = YES;
        [_contentView addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithTitle:@"去查看" titleColor:kColor333];
        rightBtn.top = leftBtn.top;
        rightBtn.left = CGRectGetMaxX(leftBtn.frame) + 25.0;
        rightBtn.size = CGSizeMake(btnW, btnH);
        [rightBtn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateHighlighted];
        rightBtn.layer.cornerRadius = 4.0;
        rightBtn.layer.masksToBounds = YES;
        [_contentView addSubview:rightBtn];
        
        @weakify(self);
        [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self hide];
        }];
        
        [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self hide];
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.titleString = @"任务中心";
            //@"http://106.75.64.151/jianhuo/app/myTitle.html";
            webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/myTitle.html");
            [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
        }];
        
    }
    return self;
}


- (void)show {
    @synchronized (self) {
        self.alpha = 0;
        _contentView.alpha = 0;
        [JHKeyWindow addSubview:self];
        [JHKeyWindow addSubview:_contentView];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
            _contentView.alpha = 1.0;
        }];
    }
}

- (void)hide {
    @synchronized (self) {
        [UIView animateWithDuration:0.25 animations:^{
            //self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
            _contentView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                [_contentView removeFromSuperview];
            }
        }];
    }
}

- (void)dealloc {
    _contentView = nil;
    DDLogDebug(@"JHUserTitleUpHUD::dealloc");
}

@end
