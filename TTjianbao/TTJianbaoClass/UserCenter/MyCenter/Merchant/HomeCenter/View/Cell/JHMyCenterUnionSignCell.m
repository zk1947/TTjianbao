//
//  JHMyCenterUnionSignCell.m
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterUnionSignCell.h"
#import "JHUnionSignView.h"
@implementation JHMyCenterUnionSignCell

- (void)addSelfSubViews{
    self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
    JHUnionSignView *signView = [JHUnionSignView new];
    [self.contentView addSubview:signView];
    [signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    signView.isOrange = YES;
    
}
@end
