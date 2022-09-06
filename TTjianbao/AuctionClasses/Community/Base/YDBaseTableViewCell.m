//
//  YDBaseTableViewCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseTableViewCell.h"

@implementation YDBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.exclusiveTouch = YES;
    self.selectedBackgroundView = [UIView new];
    return self;
}

- (void)setSelectionStyleEnabled:(BOOL)selectionStyleEnabled {
    //设置选中效果
    if (selectionStyleEnabled) {
        self.selectedBackgroundView.backgroundColor = kColorCellHighlight;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
