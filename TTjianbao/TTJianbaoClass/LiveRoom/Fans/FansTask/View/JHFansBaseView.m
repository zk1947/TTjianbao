//
//  JHFansBaseView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansBaseView.h"

@implementation JHFansBaseView 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
//      [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(HideAlert)]];
//
        UITapGestureRecognizer*tableTap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(HideAlert)];
        tableTap.delegate=self;
        [self  addGestureRecognizer:tableTap];
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews{
    
    //子类重新
    
}
-(void)HideAlert{
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"JHFansListView"]) {
        return YES;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"JHFansTaskView"]) {
        return YES;
    }
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
//        return NO;
//    }
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIControl"]) {
//        return NO;
//    }
    return NO;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
