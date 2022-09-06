//
//  YDBaseTableView.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseTableView.h"

@implementation YDBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    
    //self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.separatorColor = kColorCellLine; //分割线颜色
    self.separatorStyle = UITableViewCellSeparatorStyleNone; //默认无分割线
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    //适配iOS11
    if (@available(iOS 11.0, *)) {
        self.estimatedRowHeight = 0.1;
        self.estimatedSectionHeaderHeight = 0.1;
        self.estimatedSectionFooterHeight = 0.1;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    return self;
}

@end
