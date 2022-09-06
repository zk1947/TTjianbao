//
//  JHLuckyBagEntranceView.m
//  TTjianbao
//
//  Created by zk on 2021/11/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagEntranceView.h"

@interface JHLuckyBagEntranceView ()

@property (nonatomic, strong) UIImageView *imgv;

@end

@implementation JHLuckyBagEntranceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgv = [[UIImageView alloc]init];
    self.imgv.image = JHImageNamed(@"live_luckybag_icon");
    [self addSubview:self.imgv];
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-3);
    }];
    
    self.countdownView = [[JHMyCompeteCountdownView alloc]init];
    self.countdownView.userInteractionEnabled = NO;
    self.countdownView.alpha = 0;
    [self.countdownView jh_cornerRadius:9];
    [self.countdownView changeTextAttribute:JHFont(13) color:HEXCOLOR(0xFB3D00) bgColor:HEXCOLOR(0xFFFA81)];
    [self addSubview:self.countdownView];
    [self.countdownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
}

- (void)touchAction{
    if (self.touchEventBlock) {
        self.touchEventBlock();
    }
}

- (void)layoutMySubviews{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-55);
        make.top.mas_equalTo(kScreenHeight/2.0-58);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(58);
    }];
}

#pragma mark - 动画过程：先放大，再平移，再缩放
- (void)show:(int)downSecand{
    [self layoutMySubviews];
    self.transform = CGAffineTransformIdentity;
    __block CGAffineTransform transform = self.transform;
    //放大
    self.transform = CGAffineTransformScale(transform, 1.5, 1.5);
    transform = self.transform;
    [UIView animateWithDuration:0.5 animations:^{
        //平移
        self.transform = CGAffineTransformTranslate(transform, 43, 0);
        transform = self.transform;
    } completion:^(BOOL finished) {
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            self.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        } completion:^(BOOL finished) {
            @weakify(self);
            [self.countdownView setSecandData:downSecand expString:@"" completion:^(BOOL finished) {
                @strongify(self);
                [self remove];
            }];
            self.countdownView.alpha = 1;
        }];
    }];
}

#pragma mark - 平移回收
- (void)remove{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
