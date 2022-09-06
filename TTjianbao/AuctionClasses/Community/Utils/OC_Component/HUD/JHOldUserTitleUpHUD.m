//
//  JHOldUserTitleUpHUD.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOldUserTitleUpHUD.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "JHWebViewController.h"

#import "NSMutableAttributedString+Html.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"

#define kContentLeft    JHScaleToiPhone6(48)

@interface JHOldUserTitleUpHUD ()
@property (nonatomic,   copy) NSString *iconUrl;
@property (nonatomic,   copy) NSString *titleStr;
@property (nonatomic,   copy) NSString *descStr;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *container;
@end

@implementation JHOldUserTitleUpHUD

+ (void)showTitle:(NSString *)title desc:(NSString *)desc levelIcon:(NSString *)levelIcon {
    JHOldUserTitleUpHUD *hud = [[JHOldUserTitleUpHUD alloc] initWithFrame:[UIScreen mainScreen].bounds title:title desc:desc levelIcon:levelIcon];
    [hud show];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title desc:(NSString *)desc levelIcon:(NSString *)levelIcon {
    self = [super initWithFrame:frame];
    if (self) {
        _iconUrl = levelIcon;
        _titleStr = title;
        _descStr = desc;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        CGFloat contentViewH = 300;
        
        _contentView = [UIView new];
        _contentView.frame = CGRectMake(0, 0, ScreenWidth-45*2, contentViewH);
        _contentView.centerY = self.centerY;
        _contentView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_contentView addGestureRecognizer:tapContent];
        //_contentView.userInteractionEnabled = NO;
        
        [self addHeadView];
        [self addCloseBtn];
        [self addContainer];
    }
    return self;
}

- (void)addHeadView {
    //1.
    _headView = [UIView new];
    //_headView.backgroundColor = [UIColor getRandomColor];
    [_contentView addSubview:_headView];
    _headView.sd_layout
    .topSpaceToView(_contentView, 0)
    .centerXEqualToView(_contentView)
    .widthIs(136)
    .heightIs(130+10);
    
    //1.0
    UIImageView *avatarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_icon_avatar_bg"]];
    [_headView addSubview:avatarBg];
    avatarBg.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 10, 0));
    
    //1.1
    UIImageView *avatarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImgView.sd_cornerRadiusFromHeightRatio = @(0.5);
    User *user = [UserInfoRequestManager sharedInstance].user;
    [avatarImgView jhSetImageWithURL:[NSURL URLWithString:user.icon] placeholder:nil];//kDefaultAvatarImage
    [avatarBg addSubview:avatarImgView];
    avatarImgView.sd_layout
    .centerXEqualToView(avatarBg)
    .centerYEqualToView(avatarBg)
    .widthIs(78).heightEqualToWidth();
    
    //1.2
    UIImageView *levelImgView = [UIImageView new];
    levelImgView.contentMode = UIViewContentModeScaleAspectFit;
    [levelImgView jhSetImageWithURL:[NSURL URLWithString:_iconUrl] placeholder:nil];
    [_headView addSubview:levelImgView];
    levelImgView.sd_layout
    .topSpaceToView(avatarBg, -(25+10))
    .centerXEqualToView(_headView)
    .widthIs(108)
    .heightIs(45);
}

- (void)addCloseBtn {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"hud_icon_close"] forState:UIControlStateNormal];
    [closeBtn setAdjustsImageWhenHighlighted:NO];
    closeBtn.userInteractionEnabled = NO;
    [_contentView addSubview:closeBtn];
    closeBtn.sd_layout
    .topSpaceToView(_contentView, 15)
    .rightSpaceToView(_contentView, 0)
    .widthIs(30.0).heightEqualToWidth();
}

- (void)addContainer {
    _container = [UIView new];
    _container.backgroundColor = [UIColor whiteColor];
    _container.sd_cornerRadius = @(8);
    [_contentView addSubview:_container];
    [_contentView sendSubviewToBack:_container];
    _container.sd_layout.spaceToSuperView(UIEdgeInsetsMake((_headView.height-10)/2, 0, 0, 0));
    
    //title
    UILabel *titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:kColor333];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _titleStr;
    [_container addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(_container, (_headView.height-10)/2 + 10 + 15)
    .leftSpaceToView(_container, 15)
    .rightSpaceToView(_container, 15)
    .heightIs(22);
    
    //desc
    NSMutableAttributedString *textStr = [NSMutableAttributedString yd_loadHtmlString:_descStr];
    textStr.font = [UIFont fontWithName:kFontNormal size:15];
    textStr.alignment = NSTextAlignmentCenter;
    textStr.lineSpacing = 2.0;
    //textStr.paragraphSpacing = 5.0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth-kContentLeft*2-30, CGFLOAT_MAX) text:textStr];
    YYLabel *textLabel = [YYLabel new];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textLayout = layout; //赋值
    //textLabel.attributedText = textStr;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    textLabel.numberOfLines = 0;
    [_container addSubview:textLabel];
    textLabel.sd_layout
    .topSpaceToView(titleLabel, 8)
    .leftEqualToView(titleLabel)
    .rightEqualToView(titleLabel)
    .heightIs(layout.textBoundingSize.height);
    
    //button
    UIButton *btn = [UIButton buttonWithTitle:@"前往查看" titleColor:kColor333];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FEE100"]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FEE100"]] forState:UIControlStateHighlighted];
    [_container addSubview:btn];
    btn.sd_layout
    .leftEqualToView(_container)
    .rightEqualToView(_container)
    .bottomEqualToView(_container)
    .heightIs(50);
    
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self hide];
        JHWebViewController *webVC = [JHWebViewController new];
        webVC.titleString = @"任务中心";
        //@"http://106.75.64.151/jianhuo/app/myTitle.html";
        webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/myTitle.html");
        [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
    }];
}

- (void)show {
    if (_contentView) {
        [self removeFromSuperview];
        [_contentView removeFromSuperview];
    }
    @synchronized (self) {
        self.alpha = 0;
        _contentView.alpha = 0;
        [JHKeyWindow addSubview:self];
        [JHKeyWindow addSubview:_contentView];
        _contentView.sd_layout
        .leftSpaceToView(JHKeyWindow, kContentLeft)
        .rightSpaceToView(JHKeyWindow, kContentLeft)
        .centerYEqualToView(JHKeyWindow).offset(-40);
        
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
    DDLogDebug(@"JHOldUserTitleUpHUD::dealloc");
}

@end
