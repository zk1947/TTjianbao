//
//  HKClipperVeiw.h
//  HKBaseDemo
//
//  Created by hukaiyin on 16/8/9.
//  Copyright © 2016年 hukaiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, ClipperType) {
    ClipperTypeImgMove,
    ClipperTypeImgStay
};

#import "BaseView.h"

@interface HKClipperVeiw : BaseView

@property (nonatomic, strong) UIImage *baseImg;
@property (nonatomic, assign) CGSize resultImgSize;
@property (nonatomic, assign) ClipperType type;

- (UIImage *)clipImg;
@end
