//
//  BaseView.m
//  TTjianbao
//
//  Created by jiang on 2019/7/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "BaseView.h"

@interface BaseView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation BaseView

- (void)dealloc
{
    DDLogInfo(@"BaseView dealloc~~~%@", [self description]);
}

- (void)showImageName:(NSString *)imageName title:(NSString *)string superview:(UIView *)view
{
    [view addSubview:self.imageView];
    [view addSubview:self.label];
    self.imageView.hidden = NO;
    self.label.hidden = NO;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    self.label.text = string;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY).offset(-60);
        make.centerX.equalTo(view.mas_centerX);
        
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.imageView.mas_centerX);
    }];
    
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
        
    }
    return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textColor = HEXCOLOR(0xa7a7a7);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)showDefaultImageWithView:(UIView *)superView {
    [self showImageName:@"img_default_page" title:@"暂无数据~" superview:superView];
}

- (void)hiddenDefaultImage {
    _imageView.hidden = YES;
    _label.hidden = YES;
}

 //设置 左上和右上为圆角
- (void)setCornerForView
{
    [self setCornerForViewWithTop:0];
}

- (void)setCornerForViewWithTop:(CGFloat)top
{
    CGRect frame = self.bounds;
    frame.origin.y = top;
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
    cornerRadiusLayer.frame = frame;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    self.layer.mask = cornerRadiusLayer;
}

//设置view渐变色
- (void)setGradientWithTop:(CGFloat)top
{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.opacity = 0.4;
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);//x和y坐标,横向或者纵向
    gradient.frame =CGRectMake(0, top, self.width, self.height);
    gradient.colors = [NSArray arrayWithObjects:(id)HEXCOLOR(0xFC4200).CGColor, (id)HEXCOLOR(0x000000).CGColor,nil];
    [self.layer insertSublayer:gradient atIndex:0];
}

- (void)showAlert {

    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.mj_y = ScreenH - rect.size.height;
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

@end
