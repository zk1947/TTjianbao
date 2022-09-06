//
//  JHTopicDetailHeaderView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicDetailHeaderView.h"
#import <UIImage+webP.h>
#import "JHGradientView.h"

@interface JHTopicDetailHeaderView ()

@property (nonatomic, weak) UIImageView *topicImageView;

@property (nonatomic, weak) UILabel *topicNameLabel;

@property (nonatomic, weak) UILabel *topicDescLabel;

@property (nonatomic, weak) UIImageView *pullLoadingView;
@end

@implementation JHTopicDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelfSubViews];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)addSelfSubViews
{
    _topicImageView = [UIImageView jh_imageViewAddToSuperview:self];
    [_topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([JHTopicDetailHeaderView viewHeight]);
        make.right.bottom.left.equalTo(self);
    }];
    
    JHGradientView *layer = [JHGradientView new];
    [layer setGradientColor:@[(__bridge id)RGBA(0,0,0,0).CGColor,(__bridge id)RGBA(0,0,0,0.2).CGColor] orientation:JHGradientOrientationVertical];
    [_topicImageView addSubview:layer];
    [layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([JHTopicDetailHeaderView viewHeight]);
        make.left.right.bottom.equalTo(self.topicImageView);
    }];
    
    UIImageView *topicTip = [UIImageView jh_imageViewWithImage:@"sq_icon_topic_tag" addToSuperview:self];
    [topicTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-65);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _topicNameLabel = [UILabel jh_labelWithBoldFont:24 textColor:UIColor.whiteColor addToSuperView:self];
    [_topicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topicTip);
        make.left.equalTo(topicTip.mas_right).offset(5);
        make.right.equalTo(self).offset(-15);
    }];
    
    _topicDescLabel = [UILabel jh_labelWithFont:12 textColor:UIColor.whiteColor addToSuperView:self];
    [_topicDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicTip.mas_bottom).offset(16);
        make.left.equalTo(topicTip);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)setImage:(NSString *)imageUrl title:(NSString *)title comment_num:(NSString *)comment_num content_num:(NSString *)content_num scan_num:(NSString *)scan_num {
    NSString *newUrl = [imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#^{}\"[]|\\<> "].invertedSet];
    [_topicImageView jh_setImageWithUrl:newUrl];
    _topicNameLabel.text = title;
    _topicDescLabel.text = [NSString stringWithFormat:@"%@阅读·%@评论·%@篇内容",scan_num,comment_num,content_num];
}

- (void)updateImageHeight:(float)height
{
    if(height >= 0)
    {
        [_topicImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([JHTopicDetailHeaderView viewHeight] + height);
        }];
    }
}

+ (CGFloat)viewHeight
{
    return 200;
}

- (void)showLoading
{
    if(!_pullLoadingView)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pull_loading" ofType:@"webp"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
        _pullLoadingView = [UIImageView jh_imageViewWithImage:webpImage addToSuperview:_topicImageView];
        [_pullLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topicImageView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
}

-(void)dismissLoading
{
    self.isRequestLoading = NO;
    if(_pullLoadingView)
    {
        [_pullLoadingView removeFromSuperview];
        _pullLoadingView = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
