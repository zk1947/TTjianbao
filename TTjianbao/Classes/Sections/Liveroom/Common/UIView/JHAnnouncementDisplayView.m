//
//  JHAnnouncementDisplayView.m
//  TTjianbao
//
//  Created by Donto on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnnouncementDisplayView.h"

@interface JHAnnouncementDisplayView ()

@property (nonatomic, assign) JHAnnouncementDisplayStyle style;
@property (nonatomic, strong) UIButton *closeButton;
//! 公告详细内容
@property (nonatomic, strong) UIImageView *announcementContentImageView;
//! 公告mini窗口图标
@property (nonatomic, strong) UIButton *announcementButton;

@property (nonatomic, assign) CGRect originFrame;
@end

@implementation JHAnnouncementDisplayView

+ (instancetype)announcementDisplay:(JHAnnouncementDisplayStyle)style {
    JHAnnouncementDisplayView *dView = [[JHAnnouncementDisplayView alloc] initWithFrame:CGRectMake(0, 0, 90, 307)];
    [dView addContents];
    dView.style = style;
    return dView;
}

- (void)addContents {
    self.backgroundColor = UIColor.clearColor;

    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(width - 30, 0, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:@"jh_authenticate_record_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(colseAction) forControlEvents:UIControlEventTouchUpInside];
    closeButton.imageView.contentMode = UIViewContentModeScaleToFill;
    closeButton.imageView.frame = CGRectMake(8, 8, 14, 14);
    _closeButton = closeButton;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, width, height - 30)];
    imageView.backgroundColor = UIColor.clearColor;
    _announcementContentImageView = imageView;
    
    [self addSubview:closeButton];
    [self addSubview:imageView];
    
}

- (void)setStyle:(JHAnnouncementDisplayStyle)style {
    _style = style;
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    if (JHAnnouncementDisplayAudience == style) {
        [self announcementButton];
        
        self.frame = CGRectMake(screenSize.width-90, 170, 90, 310);
    }
    else {
        self.center = CGPointMake(screenSize.width/2.0, screenSize.height/2.0);
        _closeButton.userInteractionEnabled = NO;
        _closeButton.frame = CGRectMake(self.frame.size.width - 22, 0, 30, 30);;
    }
}

- (void)setAnnouncementImage:(UIImage *)announcementImage {
    CGSize screenSize = UIScreen.mainScreen.bounds.size;

    _announcementImage = announcementImage;
    _announcementContentImageView.image = announcementImage;
    
    _announcementContentImageView.height = announcementImage.size.height*_announcementContentImageView.frame.size.width/announcementImage.size.width;
    self.height = _announcementContentImageView.height;
    if (JHAnnouncementDisplayExample == self.style) {
        self.center = CGPointMake(screenSize.width/2.0, screenSize.height/2.0);
    }
    else {
        self.frame = CGRectMake(screenSize.width-90, (screenSize.height - 310)/2.0 - 15, 90, 310);
    }
}

- (void)colseAction {
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    _originFrame = self.frame;
    self.frame = CGRectMake(screenSize.width-22, screenSize.height/2.f - 30, 22, 60);
    self.announcementButton.hidden = NO;
    self.closeButton.hidden = self.announcementContentImageView.hidden = !self.announcementButton.hidden;
}

- (void)recoverMaxView {
    self.frame = _originFrame;
    self.announcementButton.hidden = YES;
    self.closeButton.hidden = self.announcementContentImageView.hidden = !self.announcementButton.hidden;
    if (self.delegate && [self.delegate respondsToSelector:@selector(recoverMaxView)]) {
        [self.delegate recoverMaxView];
    }
}

- (UIButton *)announcementButton {
    if (!_announcementButton) {
        UIButton *announcementButton = [UIButton new];
        [announcementButton setImage:[UIImage imageNamed:@"jh_audience_announcement"] forState:UIControlStateNormal];
        [announcementButton addTarget:self action:@selector(recoverMaxView) forControlEvents:UIControlEventTouchUpInside];
        announcementButton.hidden = YES;
        [self addSubview:announcementButton];
        [announcementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(22, 60));
        }];
        _announcementButton = announcementButton;
        
    }
    return _announcementButton;
}

@end
