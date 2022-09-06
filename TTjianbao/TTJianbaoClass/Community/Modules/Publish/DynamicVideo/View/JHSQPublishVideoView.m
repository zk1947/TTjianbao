//
//  JHSQPublishVideoView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPublishVideoView.h"

@implementation JHSQPublishVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI {
    _imageView = [UIImageView jh_imageViewAddToSuperview:self];
    _imageView.backgroundColor = UIColor.blackColor;
    [_imageView jh_cornerRadius:8];
    _imageView.userInteractionEnabled = YES;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CAGradientLayer* imageGradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    imageGradient.startPoint = CGPointMake(0, 0);
    imageGradient.endPoint = CGPointMake(0, 1);//x和y坐标,横向或者纵向
    CGSize size = [JHSQPublishVideoView viewSize];
    imageGradient.frame = CGRectMake(0, size.height - 34.f, size.width, 34);
    imageGradient.colors = [NSArray arrayWithObjects:(__bridge id)UIColor.clearColor.CGColor, RGBA(0, 0, 0, 0.4).CGColor,nil];
    [_imageView.layer insertSublayer:imageGradient above:_imageView.layer];
    
    _timeLabel = [UILabel jh_labelWithFont:12 textColor:UIColor.whiteColor addToSuperView:_imageView];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.left.equalTo(self.imageView).offset(10);
        make.bottom.equalTo(self.imageView);
    }];
    
    UIButton *button = [UIButton jh_buttonWithImage:JHImageNamed(@"sq_rcmd_icon_video") target:self action:@selector(videoAction) addToSuperView:_imageView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
    
    UIButton *closeButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_close_icon") target:self action:@selector(deleteAction) addToSuperView:_imageView];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.imageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)videoAction {
    if(_videoClickBlock) {
        _videoClickBlock();
    }
}

- (void)deleteAction {
    if(_deleteActionBlock) {
        _deleteActionBlock();
    }
}

+ (CGSize)viewSize {
    return CGSizeMake(160, 220);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
