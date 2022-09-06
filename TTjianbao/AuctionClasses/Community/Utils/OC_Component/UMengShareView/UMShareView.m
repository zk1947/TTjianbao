//
//  UMengShareView.m
//  TTjianbao
//
//  Created by wuyd on 2019/10/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UMShareView.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "LEEAlert.h"
#import "UMShareButton.h"
#import "TTjianbaoHeader.h"

#define kViewSafeAreaInsets(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

static const CGFloat kTitleHeight       = 34.0; //标题栏高度
static const CGFloat kShareScrollHeight = 130.0; //单组分享栏高度

@interface UMShareView ()

@property (nonatomic, strong) UIView *contentView; //背景视图
@property (nonatomic, strong) YYLabel *titleLabel; //标题信息
@property (nonatomic, strong) UIScrollView *shareScrollView; //分享视图
@property (nonatomic, strong) UIScrollView *moreScrollView; //更多视图
@property (nonatomic, strong) UIView *lineView; //分隔线

@property (nonatomic, strong) NSArray *shareInfoArray; //分享信息数组
@property (nonatomic, strong) NSArray *moreInfoArray; //更多信息数组

@property (nonatomic, strong) NSMutableArray *shareButtonArray; //分享按钮数组
@property (nonatomic, strong) NSMutableArray *moreButtonArray; //更多按钮数组

@end

@implementation UMShareView
{
    BOOL _isShowMore; //是否显示更多
    BOOL _isMe; //是否本人发帖
}

- (void)dealloc {
    _contentView = nil;
    _shareScrollView = nil;
    _shareInfoArray = nil;
    _shareButtonArray = nil;
    _lineView = nil;
    _moreScrollView = nil;
    _moreInfoArray = nil;
    _moreButtonArray = nil;
}

- (instancetype)initWithFrame:(CGRect)frame showMore:(BOOL)showMore isMe:(BOOL)isMe {
    self = [super initWithFrame:frame];
    if (self) {
        _isShowMore = showMore;
        _isMe = isMe;
        
        //初始化数据
        [self initData];
        [self initSubview];
        [self configAutoLayout];
    }
    return self;
}

#pragma mark -
#pragma mark - 初始化数据

- (void)initData {
    _shareButtonArray = [NSMutableArray array];
    _moreButtonArray = [NSMutableArray array];
    
    //分享信息
    NSMutableArray *tempShareInfoArray = [NSMutableArray array];
    [tempShareInfoArray addObject:@{@"title" : @"微信",
                                    @"image" : @"share_icon_wechat_session",
                                    @"highlightedImage" : @"",
                                    @"type" : @(UMSocialPlatformType_WechatSession)}];
    
    [tempShareInfoArray addObject:@{@"title" : @"朋友圈",
                                    @"image" : @"share_icon_wechat_timeline",
                                    @"highlightedImage" : @"",
                                    @"type" : @(UMSocialPlatformType_WechatTimeLine)}];
    
    _shareInfoArray = tempShareInfoArray;
    
    //更多选项
    NSMutableArray *tempMoreInfoArray = [NSMutableArray array];
    
    if (_isMe) {
        [tempMoreInfoArray addObject:@{@"title" : @"删除",
                                       @"image" : @"share_icon_delete",
                                       @"highlightedImage" : @"",
                                       @"type" : @(UMShareMoreType_Delete)}];
        
    } else {
        [tempMoreInfoArray addObject:@{@"title" : @"举报",
                                       @"image" : @"share_icon_report",
                                       @"highlightedImage" : @"",
                                       @"type" : @(UMShareMoreType_Report)}];
    }
    
    _moreInfoArray = tempMoreInfoArray;
}

#pragma mark - 初始化子视图

- (void)initSubview {
    //初始化背景视图
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
    [self addSubview:_contentView];
    
    //初始化标题
    _titleLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontNormal size:14] textColor:kColor333];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textVerticalAlignment = YYTextVerticalAlignmentBottom;
    _titleLabel.text = @"将精彩分享到";
    [_contentView addSubview:_titleLabel];
    
    //初始化分享滑动视图
    _shareScrollView = [[UIScrollView alloc] init];
    _shareScrollView.backgroundColor = [UIColor clearColor];
    _shareScrollView.bounces = YES;
    _shareScrollView.alwaysBounceHorizontal = YES; //始终可以滑动
    _shareScrollView.showsVerticalScrollIndicator = NO;
    _shareScrollView.showsHorizontalScrollIndicator = NO;
    [_contentView addSubview:_shareScrollView];
    
    //循环初始化分享按钮
    for (NSDictionary *info in _shareInfoArray) {
        //初始化按钮
        UMShareButton *button = [UMShareButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:info[@"title"] image:[UIImage imageNamed:info[@"image"]]];
        //[button setImage:[UIImage imageNamed:info[@"highlightedImage"]] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont fontWithName:kFontNormal size:12.0]];
        [button setTitleColor:kColor666 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shareScrollView addSubview:button];
        [_shareButtonArray addObject:button];
    }
    
    //判断是否显示更多
    if (_isShowMore) {
        //初始化分隔线视图
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"cfcfcf"];
        [_contentView addSubview:_lineView];
        
        //初始化分享滑动视图
        _moreScrollView = [[UIScrollView alloc] init];
        _moreScrollView.backgroundColor = [UIColor clearColor];
        _moreScrollView.bounces = YES;
        _moreScrollView.alwaysBounceHorizontal = YES; //始终可以滑动
        _moreScrollView.showsVerticalScrollIndicator = NO;
        _moreScrollView.showsHorizontalScrollIndicator = NO;
        [_contentView addSubview:_moreScrollView];
        
        //循环初始化更多按钮
        for (NSDictionary *info in _moreInfoArray) {
            //初始化按钮
            UMShareButton *button = [UMShareButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:info[@"title"] image:[UIImage imageNamed:info[@"image"]]];
            //[button setImage:[UIImage imageNamed:info[@"highlightedImage"]] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[UIFont fontWithName:kFontNormal size:12.0]];
            [button setTitleColor:kColor666 forState:UIControlStateNormal];
            [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_moreScrollView addSubview:button];
            [_moreButtonArray addObject:button];
        }
    }
}


#pragma mark -
#pragma mark - 设置自动布局
- (void)configAutoLayout {
    CGFloat height = kTitleHeight + kShareScrollHeight;
    CGFloat btnMargin = 20;
    
    //设置背景视图
    _contentView.sd_layout.topEqualToView(self).leftEqualToView(self).rightEqualToView(self);
    
    //标题栏
    _titleLabel.sd_layout
    .topSpaceToView(_contentView, 0)
    .leftSpaceToView(_contentView, 15).rightSpaceToView(_contentView, 15).heightIs(kTitleHeight);
    
    //分享选项栏
    _shareScrollView.sd_layout
    .topSpaceToView(_titleLabel, 0)
    .leftEqualToView(_contentView).rightEqualToView(_contentView).heightIs(kShareScrollHeight);
    
    //循环设置分享按钮
    CGFloat btnW = 54.0;
    for (UIButton *button in _shareButtonArray) {
        if (_shareButtonArray.firstObject == button) {
            button.sd_layout
            .topSpaceToView(_shareScrollView, 10)
            //.topEqualToView(_shareScrollView)
            .leftSpaceToView(_shareScrollView, 15)
            .widthIs(btnW).bottomSpaceToView(_shareScrollView, 0);
            //.bottomEqualToView(_shareScrollView);
            
        } else {
            button.sd_layout
            .topSpaceToView(_shareScrollView, 10)
            //.topEqualToView(_shareScrollView)
            .leftSpaceToView(_shareButtonArray[[_shareButtonArray indexOfObject:button] - 1], btnMargin)
            .widthIs(btnW).bottomSpaceToView(_shareScrollView, 0);
            //.bottomEqualToView(_shareScrollView);
        }
    }
    
    [_shareScrollView setupAutoContentSizeWithRightView:_shareButtonArray.lastObject rightMargin:15];
    
    //更多选项
    if (_isShowMore) {
        //设置分隔线视图
        _lineView.sd_layout
        .topSpaceToView(_shareScrollView , 0)
        .leftSpaceToView(_contentView, 15).rightSpaceToView(_contentView, 0).heightIs(0.5f);
        
        //设置更多滑动视图
        _moreScrollView.sd_layout
        .topSpaceToView(_lineView , 0)
        .leftEqualToView(_contentView).rightEqualToView(_contentView).heightIs(kShareScrollHeight);
        
        //循环设置更多按钮
        for (UIButton *button in _moreButtonArray) {
            if (_moreButtonArray.firstObject == button) {
                button.sd_layout
                .topEqualToView(_moreScrollView)
                .leftSpaceToView(_moreScrollView , 15)
                .widthIs(btnW).bottomSpaceToView(_moreScrollView, 10);
                //.bottomEqualToView(_moreScrollView);
                
            } else {
                button.sd_layout
                .topEqualToView(_moreScrollView)
                .leftSpaceToView(_moreButtonArray[[_moreButtonArray indexOfObject:button] - 1], btnMargin)
                .widthIs(btnW).bottomSpaceToView(_moreScrollView, 10);
                //.bottomEqualToView(_moreScrollView);
            }
        }
        
        [_moreScrollView setupAutoContentSizeWithRightView:_moreButtonArray.lastObject rightMargin:15];
        [_contentView setupAutoHeightWithBottomView:_moreScrollView bottomMargin:0];
        height += kShareScrollHeight;
        
    } else {
        [_contentView setupAutoHeightWithBottomView:_shareScrollView bottomMargin:0];
    }
    
    self.height = height;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    
    _shareScrollView.sd_layout
    .topSpaceToView(_titleLabel, 0)
    .leftSpaceToView(_contentView, kViewSafeAreaInsets(self).left)
    .rightSpaceToView(_contentView, kViewSafeAreaInsets(self).left)
    .heightIs(kShareScrollHeight);
    
    if (_isShowMore) {
        _moreScrollView.sd_layout
        .topSpaceToView(_lineView, 0)
        .leftSpaceToView(_contentView, kViewSafeAreaInsets(self).left)
        .rightSpaceToView(_contentView, kViewSafeAreaInsets(self).left)
        .heightIs(kShareScrollHeight);
    }
}

#pragma mark -
#pragma mark - 分享按钮点击事件
- (void)shareButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [LEEAlert closeWithCompletionBlock:^{
        if (!weakSelf) return;
        NSInteger index = [weakSelf.shareButtonArray indexOfObject:sender];
        UMSocialPlatformType type = (UMSocialPlatformType)[weakSelf.shareInfoArray[index][@"type"] integerValue];
        if (weakSelf.openShareBlock) {
            weakSelf.openShareBlock(type);
        }
    }];
}

#pragma mark - 更多按钮点击事件

- (void)moreButtonAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [LEEAlert closeWithCompletionBlock:^{
        if (!weakSelf) return;
        NSInteger index = [weakSelf.moreButtonArray indexOfObject:sender];
        UMShareMoreType type = (UMShareMoreType)[weakSelf.moreInfoArray[index][@"type"] integerValue];
        if (weakSelf.openMoreBlock) {
            weakSelf.openMoreBlock(type);
        }
    }];
}

#pragma mark - 显示
- (void)show {
    [LEEAlert actionsheet].config
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = self;
        custom.isAutoWidth = YES;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddAction(^(LEEAction *action) {
        action.title = @"取消";
        action.font = [UIFont fontWithName:kFontMedium size:15];
        action.titleColor = kColor333;
        action.backgroundColor = [UIColor whiteColor];
        action.backgroundHighlightColor = [UIColor whiteColor];
        action.height = 56.0f;
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeCornerRadius(0.0f)
    .LeeActionSheetBottomMargin(0.0f)
    .LeeActionSheetBackgroundColor([UIColor whiteColor])
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
//    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
//        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            animatingBlock(); //调用动画中Block
//        } completion:^(BOOL finished) {
//            animatedBlock(); //调用动画结束Block
//        }];
//    })
    .LeeShow();
}

@end
