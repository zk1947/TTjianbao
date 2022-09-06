//
//  JHSessionTableView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSessionTableView.h"

@implementation JHSessionTableView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchBegin == nil) return;
    self.touchBegin();
}
@end
