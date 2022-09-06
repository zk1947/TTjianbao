//
//  JHUnionSignSalePopView.m
//  TTjianbao
//
//  Created by Jesse on 20/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignSalePopView.h"
#import "JHLine.h"

@interface JHUnionSignSalePopView ()

@property(nonatomic, strong)  JHCustomLine *line;
@property(nonatomic, strong)  UIView *backgroundView;
@property(nonatomic, strong)  UILabel *titleLabel;
@property(nonatomic, strong)  UILabel *contentLabel;
@property(nonatomic, strong)  UIImageView *stepImgView;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *signButton;
@end

@implementation JHUnionSignSalePopView

+ (JHUnionSignSalePopView*)showUnsignCannotSaleView
{
    JHUnionSignSalePopView* popview = [JHUnionSignSalePopView new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:popview];
 
    [popview redrawSubViews];
    return popview;
}

+ (JHUnionSignSalePopView*)showResellSignView
{
    JHUnionSignSalePopView* popview = [JHUnionSignSalePopView new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:popview];
 
    [popview redrawResellSubView];
    return popview;
}

+ (JHUnionSignSalePopView*)showSaleSignView
{
    JHUnionSignSalePopView* popview = [JHUnionSignSalePopView new];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:popview];
    return popview;
}

- (void)dealloc
{
    NSLog(@"~~~");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.backgroundColor = HEXCOLORA(0x000000,0.6);
        
        [self drawBackground];
        [self drawSubViews];
    }
    return self;
}

- (void)drawBackground
{
    _backgroundView = [UIView new];
        _backgroundView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _backgroundView.layer.cornerRadius = 5;
        [self addSubview:_backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self).insets(UIEdgeInsetsMake(100, 58, 100, 58));
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(260, 388));
        }];
}

- (void)drawSubViews
{
    _titleLabel = [UILabel jh_labelWithBoldFont:16 textColor:HEXCOLOR(0x333333) addToSuperView:_backgroundView];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [_titleLabel setFont:JHMediumFont(15)];
    _titleLabel.text = @"原石寄售签约提示";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backgroundView);
        make.top.equalTo(_backgroundView).offset(15);
        make.height.mas_equalTo(22);
    }];
    
    //分割线
    _line = [JHCustomLine new];
    [_backgroundView addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.width.equalTo(_backgroundView);
        make.height.mas_equalTo(0.5);
    }];
    
    _stepImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sale_img_sign_step"]];
    _stepImgView.contentMode = UIViewContentModeCenter;
    [_backgroundView addSubview:_stepImgView];
    [_stepImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backgroundView);
        make.top.mas_equalTo(_line.mas_bottom).offset(15);
        make.height.mas_equalTo(183);/**ScreenW/375.0);*/
        make.width.mas_equalTo(209);
    }];
    
    _contentLabel = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0x333333) addToSuperView:_backgroundView];
    [_contentLabel setFont:JHFont(12)];
    _contentLabel.text = @"为保护您的合法权益，我们已联合银联商务共同提供交易清算服务，立即签约并通过审核即可寄售原石。";
    _contentLabel.numberOfLines = 0;
    _contentLabel.adjustsFontSizeToFitWidth = YES;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_stepImgView);
        make.top.mas_equalTo(_stepImgView.mas_bottom).offset(14);
    }];
    
    _cancelButton = [UIButton jh_buttonWithTarget:self action:@selector(cancelButtonAction) addToSuperView:_backgroundView];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = JHFont(15);
    _cancelButton.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.cornerRadius = 20;
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundView).offset(16);
        make.size.mas_equalTo(CGSizeMake(88, 41));
        make.bottom.equalTo(_backgroundView).offset(-20);
    }];
    
    _signButton = [UIButton jh_buttonWithTarget:self action:@selector(signButtonAction) addToSuperView:_backgroundView];
    _signButton.backgroundColor = HEXCOLOR(0xFEE100);
    [_signButton setImage:[UIImage imageNamed:@"sale_icon_sign_now"] forState:UIControlStateNormal];
    [_signButton setTitle:@"立即签约" forState:UIControlStateNormal];
    [_signButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_signButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    _signButton.titleLabel.font = JHFont(15);
    _signButton.layer.cornerRadius = 20;
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(132, 41));
        make.bottom.equalTo(_cancelButton);
        make.right.equalTo(_backgroundView).offset(-14);
    }];
}

//转售样式
- (void)redrawResellSubView
{
    _titleLabel.text = @"原石转售签约提示";
    [_stepImgView setImage:[UIImage imageNamed:@"resale_img_sign_step"]];
    _contentLabel.text = @"为保护您的合法权益，我们已联合银联商务共同提供交易清算服务，立即签约并通过审核即可转售原石。";
}


//请他签约样式
- (void)redrawSubViews
{
    [_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(260, 166));
    }];
    [_stepImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [_stepImgView setHidden:YES];
    [_line setHidden:YES];
    _titleLabel.text = @"寄售";
    [_contentLabel setFont:JHFont(13)];
    _contentLabel.text = @"该用户未签约，暂时不可寄售！";
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_stepImgView.mas_bottom).offset(0);
    }];
    
    [_signButton setImage:[UIImage new] forState:UIControlStateNormal];
    [_signButton setTitle:@"请他签约" forState:UIControlStateNormal];
    [_signButton setTitleEdgeInsets:UIEdgeInsetsZero];
    [_cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 41));
        make.left.equalTo(_backgroundView).offset(26);
    }];
    [_signButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 41));
        make.right.equalTo(_backgroundView).offset(-24);
    }];
}

#pragma mark - event
- (void)signButtonAction
{
    if(self.activeBlock)
    {
        self.activeBlock(@"");
    }
    [self removeFromSuperview];
}

- (void)cancelButtonAction
{
    [self removeFromSuperview];
}

@end
