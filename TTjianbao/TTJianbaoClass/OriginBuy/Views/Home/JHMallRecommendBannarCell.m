//
//  JHMallRecommendBannarCell.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallRecommendBannarCell.h"
#import "NTESLiveLikeView.h"
#import "JHMallModel.h"

@interface JHMallRecommendBannarCell ()

///直播中动效
@property (nonatomic, weak) UIView *animalView;

@end

@implementation JHMallRecommendBannarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView jh_cornerRadius:6];
        
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView.superview).insets(UIEdgeInsetsMake(0, 12, 0, 0));
        }];
    }
    return self;
}

///拉流的动画

- (UIView *)animalView {
    if(!_animalView) {
        UIView *animalView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self.imageView];
        [self.imageView addSubview:animalView];
        [animalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(36);
            make.top.right.bottom.equalTo(self.imageView);
        }];
        
        UIImageView *praiseIcon = [UIImageView jh_imageViewWithImage:@"mall_home_bannar_praise" addToSuperview:animalView];
        [praiseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(animalView);
            make.bottom.equalTo(animalView).offset(-7);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        NTESLiveLikeView *likeView = [[NTESLiveLikeView alloc] initWithFrame:CGRectZero];
        [animalView addSubview:likeView];
        [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(animalView);
            make.bottom.equalTo(praiseIcon.mas_top);
        }];
        [likeView fireRepeat];
        _animalView = animalView;
    }
    return _animalView;
}

- (void)setModel:(JHMallBannerModel *)model {
    _model = model;
    [self.imageView setImageWithURL:[NSURL URLWithString:_model.smallCoverImg] placeholder:kDefaultCoverImage];
    self.animalView.hidden = (_model.status != 2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
