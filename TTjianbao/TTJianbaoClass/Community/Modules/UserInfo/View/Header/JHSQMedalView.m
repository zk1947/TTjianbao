//
//  JHSQMedalView.m
//  TTjianbao
//
//  Created by lihui on 2020/6/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQMedalView.h"
#import "UIImageView+JHWebImage.h"
#import <UIImageView+WebCache.h>
#import "YYControl.h"


#define tagHeight 15.f
@interface JHSQMedalView ()

@property (nonatomic, strong) NSMutableArray <UIImageView *>*tagImageViews;

@end

@implementation JHSQMedalView

- (void)setTagArray:(NSArray<NSString *> *)tagArray {
    if (!tagArray) {
        return;
    }
    _tagArray = tagArray;
    for (int i = (int)_tagArray.count; i < self.tagImageViews.count; i ++) {
        UIImageView *imgV = self.tagImageViews[i];
        [imgV.layer cancelCurrentImageRequest];
        imgV.hidden = YES;
    }

    for (int i = 0; i < tagArray.count; i ++) {
        UIImageView *tagImageV = self.tagImageViews[i];
        tagImageV.hidden = NO;
        @weakify(tagImageV);
        [tagImageV jhSetImageWithURL:[NSURL URLWithString:tagArray[i]] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            @strongify(tagImageV);
            CGFloat imgHeight = image.size.height;
            imgHeight = imgHeight > 0 ? imgHeight : 1;
            CGFloat scale = (image.size.width / imgHeight);
            [tagImageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(scale * tagHeight);
            }];
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self addViews];
    }
    return self;
}

- (NSMutableArray<UIImageView *> *)tagImageViews {
    if(!_tagImageViews) {
        _tagImageViews = [NSMutableArray array];
    }
    return _tagImageViews;
}

- (void)addViews {
    UIImageView *_tagImageV;
    for (int i = 0; i < 5; i ++) {
        UIImageView *tagImageView = [[UIImageView alloc] init];
        tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:tagImageView];
        [self.tagImageViews addObject:tagImageView];
        if (i == 0) {
            [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                make.left.equalTo(self);
                make.height.mas_equalTo(self);
            }];
        }
        else {
            [tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_tagImageV.mas_right).offset(3);
                make.height.mas_equalTo(self);
            }];
        }
        _tagImageV = tagImageView;
    }
}

@end
