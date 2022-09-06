//
//  JHNewStoreCollectAndTopView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreCollectAndTopView.h"

@implementation JHNewStoreCollectAndTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    NSArray *btnImageArray = @[@"c2c_pd_shoucang",@"c2c_pd_top"];
    for (int i = 0; i < btnImageArray.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*(10+50), 50, 50);
        [btn setBackgroundImage:JHImageNamed(btnImageArray[i]) forState:UIControlStateNormal];
        btn.tag = 10000 + i;
        [btn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 1) {
            self.topButton = btn;
        }
    }
}

- (void)listBtnClick:(UIButton *)button{
    if (self.collectAndTopViewBlock) {
        self.collectAndTopViewBlock(button);
    }
}

@end
