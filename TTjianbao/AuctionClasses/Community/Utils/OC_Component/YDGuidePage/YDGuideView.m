//
//  YDGuideView.m
//  ForkNews
//
//  Created by wuyd on 2018/5/25.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import "YDGuideView.h"
#import <YYKit/YYKit.h>
#import <YDCategoryKit/YDCategoryKit.h>
#import "UITapView.h"
#import "UITapImageView.h"

@interface YDGuideView ()
@property (nonatomic, strong) NSMutableArray *imgViews;
@property (nonatomic, strong) UITapView *pageView;
@property (nonatomic, assign) NSInteger curIndex;
@end

@implementation YDGuideView

- (void)dealloc {
    NSLog(@"YDGuideView::dealloc");
    _pageView = nil;
    _imgViews = nil;
}

#pragma mark -
#pragma mark - 针对某个页面的引导
- (instancetype)initWithFrame:(CGRect)frame guideType:(YDGuideType)guideType {
    self = [super initWithFrame:frame];
    if (self) {
        _pageView = [[UITapView alloc] initWithFrame:self.bounds];
        _pageView.backgroundColor = HEXCOLORA(0x000000, 0.6);
        [self addSubview:_pageView];
        
        switch (guideType) {
            case YDGuideTypeStoreHome:
                [self __showStoreHomePageGuide];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)__showStoreHomePageGuide {
    CGFloat titleX = 96+30+80;
    UIImageView *titleIcon = [UIImageView new];
    titleIcon.image = [UIImage imageNamed:@"icon_guide_stone_title"];
    titleIcon.frame = CGRectMake(titleX, UI.topSafeAreaHeight+UI.statusBarHeight, 88, 35);
    
    if (UI.isExistSafeArea) {
        titleIcon.top = UI.topSafeAreaHeight;
    }
    titleIcon.top += 2;
    [_pageView addSubview:titleIcon];
    
    UIImageView *indicatorImgView = [UIImageView new];
    indicatorImgView.image = [UIImage imageNamed:@"icon_guide_stone_indicator"];
    indicatorImgView.frame = CGRectMake(40, CGRectGetMaxY(titleIcon.frame), 309, 178);
    [_pageView addSubview:indicatorImgView];
    
    UITapImageView *skipIcon = [UITapImageView new];
    skipIcon.image = [UIImage imageNamed:@"icon_guide_stone_skip"];
    skipIcon.frame = CGRectMake((ScreenWidth-141)/2, CGRectGetMaxY(indicatorImgView.frame) + 50, 141, 62);
    [_pageView addSubview:skipIcon];
    @weakify(self);
    [skipIcon addTapBlock:^(id  _Nonnull obj) {
        @strongify(self);
        [self __removeGuidePage];
    }];
}


#pragma mark -
#pragma mark - 显示整张全屏图
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray<NSString *> *)imageNames {
    self = [super initWithFrame:frame];
    if (self) {
        _curIndex = 0;
        _imgViews = [NSMutableArray new];
        
        for (NSInteger i = 0; i < imageNames.count; i++) {
            
            UIImageView *imageView = [UIImageView new];
            NSData *imgData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNames[i] ofType:nil]];
            
            if ([[NSData contentTypeForImageData:imgData] isEqualToString:@"gif"]) {
                YYImage *image = [YYImage imageNamed:imageNames[i]];
                imageView = (YYAnimatedImageView *)[[YYAnimatedImageView alloc] initWithImage:image];
                
            } else {
                imageView.image = [UIImage imageNamed:imageNames[i]];
            }
            
            imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            [_imgViews addObject:imageView];
        }
        
        _pageView = [[UITapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _pageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_pageView];
        @weakify(self);
        [_pageView addTapBlock:^(id obj) {
            @strongify(self);
            [self __showNextPage];
        }];
        
        [self __startShowPage];
    }
    return self;
}

- (void)__startShowPage {
    [_pageView addSubview:_imgViews[0]];
}

- (void)__showNextPage {
    ++_curIndex;
    if (_curIndex <= _imgViews.count-1) {
        UIImageView *preView = _imgViews[_curIndex-1];
        [preView removeFromSuperview];
        [_pageView addSubview:_imgViews[_curIndex]];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self __removeGuidePage];
        }];
    }
}

- (void)__removeGuidePage {
    [self removeFromSuperview];
}

@end

