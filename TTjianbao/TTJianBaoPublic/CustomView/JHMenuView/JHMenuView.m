//
//  JHMenuView.m
//  TTjianbao
//
//  Created by YJ on 2021/1/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMenuView.h"
#import "TTJianBaoColor.h"

#define kMainWindow      [UIApplication sharedApplication].keyWindow
#define kAnimationTime   0.25
#define TOP_PAD 10
#define VIEW_WIDHT 88

@interface JHMenuView()

@property (nonatomic,strong) UIImageView *contentView;
@property (nonatomic,strong) UIView  *bgView;
@property (nonatomic,strong) UIButton *chatBtn;
@property (nonatomic,strong) UIButton *copBtn;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation JHMenuView

+ (instancetype)menuViewAtPoint:(CGPoint)point
{
    JHMenuView *menu = [[JHMenuView alloc] initAtPoint:point];
    return menu;
}

- (instancetype)initAtPoint:(CGPoint)point
{
    if (self = [super init])
    {
        self.frame = CGRectMake(point.x - 5, point.y + 10, VIEW_WIDHT, VIEW_WIDHT);
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.chatBtn];
        [self.contentView addSubview:self.copBtn];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)show
{
    [kMainWindow addSubview: self.bgView];
    [kMainWindow addSubview: self];
    
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: kAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
        self.bgView.alpha = 1.0f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration: kAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0f;
        self.bgView.alpha = 0.0f;
    } completion:^(BOOL finished)
    {
        self.layer.affineTransform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.alpha = 0.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIImageView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIImageView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.image = [UIImage imageNamed:@"menu_image"];
        _contentView.contentMode = UIViewContentModeScaleAspectFit;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)chatBtn
{
    if (!_chatBtn)
    {
        _chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, TOP_PAD + 2, VIEW_WIDHT - 10, (VIEW_WIDHT - TOP_PAD)/2 - 5)];
        [_chatBtn setTitle:@"联系宝友" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:B_COLOR forState:UIControlStateNormal];
        _chatBtn.tag = 0;
        [_chatBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _chatBtn;
}

- (UIButton *)copBtn
{
    if (!_copBtn)
    {
        _copBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, (VIEW_WIDHT - TOP_PAD)/2 + TOP_PAD, VIEW_WIDHT - 10, (VIEW_WIDHT - TOP_PAD)/2 - 5)];
        [_copBtn setTitle:@"复制宝友号" forState:UIControlStateNormal];
        [_copBtn setTitleColor:B_COLOR forState:UIControlStateNormal];
        _copBtn.tag = 1;
        [_copBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _copBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _copBtn;
}

- (void)clickBtn:(UIButton *)button
{
    [self dismiss];
    
    if (self.block)
    {
        self.block(button.tag);
    }
}

- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, TOP_PAD - 2 + (VIEW_WIDHT - 10)/2, VIEW_WIDHT - 30, 1)];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
@end
