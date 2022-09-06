//
//  JHLuckyBagRuleView.m
//  TTjianbao
//
//  Created by zk on 2021/11/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagRuleView.h"

#define KLuckyBagRule @"1、主播通过福袋功能设定任务和奖励；\n\n2、用户完成相应的任务就算成功参与福袋活动；\n\n3、福袋倒计时结束之后，会从参与福袋的用户中随机抽取，并且在直播间内告知福袋中奖结果；\n\n4、中奖用户会收到一个0元福利单，也可在订单列表当中查看，填写地址，完成订单后，即可获得相应的福袋奖励；\n\n5、用户不得以任何非法手段（如恶意注册多个账号）、舞弊、使用外挂等手段参与活动，否则将被取消奖励资格，造成平台损失的，平台有权追究相关责任。"

@interface JHLuckyBagRuleView ()

@property (nonatomic, strong) UIButton *maskView;//遮罩

@property (nonatomic, strong) UILabel *titLab;

@property (nonatomic, strong) UILabel *conLab;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIScrollView *scrollV;

@end

@implementation JHLuckyBagRuleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(kScreenWidth, kScreenHeight-364, kScreenWidth, 364);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.titLab];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.scrollV];
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.titLab.mas_bottom).offset(10);
    }];
    
    [self.scrollV addSubview:self.conLab];
    [self.conLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(100);
    }];

}

- (void)setRuleSting:(NSString *)ruleSting{
    _ruleSting = ruleSting;
    self.conLab.text = _ruleSting;
    CGSize size = [_ruleSting boundingRectWithSize:CGSizeMake(kScreenWidth-30, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:JHFont(13)} context:nil].size;
    self.scrollV.contentSize = CGSizeMake(0, size.height+50);
    [self.conLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height+20);
    }];
}

- (void)show{
    self.ruleSting = KLuckyBagRule;
    [[JHRootController currentViewController].view addSubview:self.maskView];
    [[JHRootController currentViewController].view addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        self.maskView.alpha = 0.5;
        CGAffineTransform transform = self.transform;
        self.transform = CGAffineTransformTranslate(transform, -self.width, 0);
    }];
}

- (void)remove{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.0;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
//        [self.maskView removeFromSuperview];
//        [self removeFromSuperview];
    }];
}
    
#pragma mark - Lazy load Methods：

- (UIButton *)maskView{
    if (!_maskView) {
        UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        maskView.frame = [UIScreen mainScreen].bounds;
        maskView.alpha = 0.0;
        maskView.backgroundColor = [UIColor blackColor];
//        [maskView addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _maskView = maskView;
    }
    return _maskView;
}

- (UILabel *)titLab{
    if (!_titLab) {
        UILabel *titLab = [UILabel new];
        titLab.text = @"福袋说明";
        titLab.textColor = kColor333;
        titLab.font = JHMediumFont(15);
        titLab.textAlignment = NSTextAlignmentCenter;
        _titLab = titLab;
    }
    return _titLab;
}

- (UILabel *)conLab{
    if (!_conLab) {
        UILabel *conLab = [UILabel new];
        conLab.text = @"关注主播";
        conLab.textColor = kColor333;
        conLab.font = JHFont(13);
        conLab.numberOfLines = 0;
        _conLab = conLab;
    }
    return _conLab;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:JHImageNamed(@"ico_back") forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [backBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (UIScrollView *)scrollV{
    if (!_scrollV) {
        UIScrollView *scrollV = [UIScrollView new];
        _scrollV = scrollV;
    }
    return _scrollV;
}

@end

