//
//  JHBackApplyLinkPoPView.m
//  TTjianbao
//
//  Created by apple on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBackApplyLinkPoPView.h"
#import <UIImage+webP.h>
#import "BYTimer.h"
#import "JHUIFactory.h"

@interface JHBackApplyLinkPoPView()
@property (nonatomic,strong)  BYTimer  *downTimer;
@property (nonatomic,strong) UILabel * subLabel;
@end

@implementation JHBackApplyLinkPoPView

- (instancetype)init{
    self = [self initWithFrame:CGRectMake(0, 0, 64, 91)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.backgroundColor = HEXCOLORA(0xFFD710, .85);
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"live_connect_mic_black" ofType:@"webp"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
    UIImageView *LoadingView = [UIImageView jh_imageViewWithImage:webpImage addToSuperview:self];
    [LoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.subLabel = [JHUIFactory createLabelWithTitle:@"连麦中40s" titleColor:HEXCOLOR(0x333333) font:JHFont(10) textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(LoadingView.mas_bottom).offset(-4);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(12);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"customizeBackLinkCancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelLink) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-6);
            make.left.mas_equalTo(self).offset(6);
            make.right.mas_equalTo(self).offset(-6);
    }];

    [self addTimerByConnect];
}
-(void)addTimerByConnect{
    
    if (!_downTimer) {
        _downTimer=[[BYTimer alloc]init];
    }
    [_downTimer stopGCDTimer];
    JH_WEAK(self)
    [self.downTimer createTimerWithTimeout:40 handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        self.subLabel.text = [NSString stringWithFormat:@"连麦中%ds",presentTime];
        
        } finish:^{
            JH_STRONG(self)
            [self cancelLink];
        }
    ];
    
}
- (void)cancelLink{
    if (self.cancelClickedBlock) {
        self.cancelClickedBlock();
    }
    [_downTimer stopGCDTimer];
    [self removeFromSuperview];
}
- (void)removeSelf{
    [_downTimer stopGCDTimer];
    [self removeFromSuperview];
}
@end
