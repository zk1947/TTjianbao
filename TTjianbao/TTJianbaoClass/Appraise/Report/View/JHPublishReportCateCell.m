//
//  JHPublishReportCateCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportCateCell.h"

@implementation JHPublishReportCateCell

- (void)addSelfSubViews {
    UILabel *label = [UILabel jh_labelWithText:@"类别" font:16 textColor:RGB(34,34,34) textAlignment:0 addToSuperView:self.contentView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
