//
//  JHPopBaseView.m
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPopBaseView.h"
#import "MJRefresh.h"

@implementation JHPopBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeBackUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeBackUI];
    }
    return self;
}

- (void)makeBackUI {
    [self addSubview:self.backView];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.top.equalTo(self.backView).offset(0);
        make.trailing.equalTo(self.backView).offset(0);
    }];
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"orderPopView_closeIcon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
    }
    
    return _backView;
}

- (void)showAlert {

    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    if (rect.size.width<ScreenW) {
        rect.origin.y = ScreenH - rect.size.height - 49;
        
    }else {
        rect.origin.y = ScreenH - rect.size.height;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    

}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)closeAction:(UIButton *)btn {
    [self hiddenAlert];
}

@end
