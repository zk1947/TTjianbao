//
//  JHRefreshNormalFooter.m
//  TTjianbao
//
//  Created by jiangchao on 2019/6/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHRefreshNormalFooter.h"

@implementation JHRefreshNormalFooter
- (void)prepare
{
      [super prepare];
      self.refreshingTitleHidden= YES;
      [self.stateLabel setHidden:YES];
}

- (void)showStateTitle:(NSString*)title state:(MJRefreshState)state hidden:(BOOL)hidden
{
    self.stateLabel.font = [UIFont fontWithName:kFontNormal size:12];
    self.stateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [self setTitle:title forState:state];
    [self setState:state];
    [self.stateLabel setHidden:hidden];
}

@end
