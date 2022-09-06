//
//  JHTextView.m
//  TTjianbao
//
//  Created by lihui on 2021/1/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTextView.h"

@implementation JHTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollEnabled = NO;
        self.editable = NO;
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(selectAll:)) {
        return NO;
//        return [super canPerformAction:action withSender:sender];
    }
    if (action == @selector(select:)) {
        if (self.selectedRange.length > 0) {
            return NO;
        }
        return [super canPerformAction:action withSender:sender];
    }
    if (action == @selector(copy:)) {
        return NO;
    }
    if (action == @selector(toCopy:)) {
        return YES;
    }
    if (action == @selector(toSelectAll:)) {
        if (self.selectedRange.length == self.text.length) {
            return NO;
        }
        return YES;
    }

    return NO;
}

- (void)toCopy:(id)sender {
    if (!self.text || self.text.length == 0) {
        return;
    }
    ///复制文字到剪贴板
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
}

- (void)toSelectAll:(id)sender {
    [self selectAll:sender];
}

@end
