//
//  JHPageControl.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPageControl.h"
#import "TTjianbaoMarcoUI.h"

#define kPointTag           (1000)
#define kCurrentPointImgTag (2233)
#define kOtherPointImgTag   (2244)

@interface JHPageControl ()

@end

@implementation JHPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    _otherMultiple = 1;
    _currentMultiple = 1;
    _numberOfPages = 0;
    _currentPage = 0;
    _pointSize = 6;
    _pointSpacing = 8;
    _otherColor = kColorEEE;
    _currentColor = kColorMain;
    _pageControlAlignment = JHPageControlAlignmentMiddle;
}


- (void)setOtherColor:(UIColor *)otherColor {
    if (![self isTheSameColor:otherColor anotherColor:_otherColor]) {
        _otherColor = otherColor;
        [self createPointView];
    }
}

- (void)setCurrentColor:(UIColor *)currentColor {
    if (![self isTheSameColor:currentColor anotherColor:_currentColor]) {
        _currentColor = currentColor;
        [self createPointView];
    }
}

- (void)setPointSize:(NSInteger)pointSize {
    if (_pointSize != pointSize) {
        _pointSize = pointSize;
        [self createPointView];
    }
}

- (void)setOtherMultiple:(NSInteger)otherMultiple {
    if (otherMultiple != _otherMultiple) {
        _otherMultiple = otherMultiple;
        [self createPointView];
    }
}
- (void)setCurrentMultiple:(NSInteger)currentMultiple {
    if (currentMultiple != _currentMultiple) {
        _currentMultiple = currentMultiple;
        [self createPointView];
    }
}

- (void)setPointSpacing:(NSInteger)pointSpacing {
    if (_pointSpacing != pointSpacing) {
        _pointSpacing = pointSpacing;
        [self createPointView];
    }
}

- (void)setCurrentPointImg:(UIImage *)currentPointImg {
    if (_currentPointImg != currentPointImg){
        _currentPointImg = currentPointImg;
        [self createPointView];
    }
}

- (void)setOtherPointImg:(UIImage *)otherPointImg {
    if (_otherPointImg != otherPointImg) {
        _otherPointImg = otherPointImg;
        [self createPointView];
    }
}

- (void)setPageControlAlignment:(JHPageControlAlignment)pageControlAlignment {
    if (_pageControlAlignment != pageControlAlignment) {
        _pageControlAlignment = pageControlAlignment;
        [self createPointView];
    }
}


- (void)setNumberOfPages:(NSInteger)page {
    if (_numberOfPages == page)
        return;
    _numberOfPages = page;
    [self createPointView];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if ([self.delegate respondsToSelector:@selector(jh_pageControl:didSelectAtIndex:)]) {
        [self.delegate jh_pageControl:self didSelectAtIndex:currentPage];
    }
    
    if (_currentPage == currentPage)
        return;
    
    [self exchangeCurrentView:_currentPage new:currentPage];
    _currentPage = currentPage;
}

- (void)clearView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


- (void)createPointView {
    [self clearView];
    if (_numberOfPages <= 0) {
        return;
    }
    //居中控件
    CGFloat startX = 0;
    CGFloat startY = 0;
    CGFloat mainWidth = (_numberOfPages - 1)* _pointSize * _otherMultiple + (_numberOfPages - 1) * _pointSpacing + _pointSize * _currentMultiple;
    if (self.frame.size.width < mainWidth) {
        startX = 0;
    } else {
        if (_pageControlAlignment == JHPageControlAlignmentLeft) {
            startX = 10;
        } else if (_pageControlAlignment == JHPageControlAlignmentMiddle) {
            startX = (self.frame.size.width-mainWidth) / 2.0;
        } else if (_pageControlAlignment == JHPageControlAlignmentRight) {
            startX = self.frame.size.width - mainWidth - 10;
        }
    }
    if (self.frame.size.height < _pointSize) {
        startY = 0;
    } else {
        startY = (self.frame.size.height - _pointSize) / 2;
    }
    //动态创建点
    for (NSInteger page = 0; page < _numberOfPages; page++) {
        if (page == _currentPage) {
            UIView *curPointView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _pointSize * _currentMultiple, _pointSize)];
            curPointView.layer.cornerRadius = _pointSize/2;
            curPointView.tag = page + kPointTag;
            curPointView.backgroundColor = _currentColor;
            curPointView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
            [curPointView addGestureRecognizer:tapGesture];
            [self addSubview:curPointView];
            startX = CGRectGetMaxX(curPointView.frame) + _pointSpacing;
            
            if(_currentPointImg){
                curPointView.backgroundColor = [UIColor clearColor];
                UIImageView *curImg = [[UIImageView alloc]init];
                curImg.tag = kCurrentPointImgTag;
                curImg.frame = CGRectMake(0, 0, curPointView.frame.size.width, curPointView.frame.size.height);
                curImg.image = _currentPointImg;
                [curPointView addSubview:curImg];
            }
            
        } else {
            UIView *otherPointView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, _pointSize * _otherMultiple, _pointSize)];
            otherPointView.backgroundColor = _otherColor;
            otherPointView.tag = page + kPointTag;
            otherPointView.layer.cornerRadius = _pointSize/2.0;
            otherPointView.userInteractionEnabled = YES;
            
            if (_otherPointImg) {
                otherPointView.backgroundColor = [UIColor clearColor];
                UIImageView *otherImg = [[UIImageView alloc] init];
                otherImg.tag = page + kPointTag + kOtherPointImgTag;
                otherImg.frame = CGRectMake(0, 0, otherPointView.frame.size.width, otherPointView.frame.size.height);
                otherImg.image = _otherPointImg;
                [otherPointView addSubview:otherImg];
            }
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [otherPointView addGestureRecognizer:tapGesture];
            [self addSubview:otherPointView];
            startX = CGRectGetMaxX(otherPointView.frame) + _pointSpacing;
        }
    }
}

//切换当前的点
- (void)exchangeCurrentView:(NSInteger)old new:(NSInteger)new {
    UIView *oldSelect = [self viewWithTag:kPointTag+old];
    CGRect mpSelect = oldSelect.frame;
    
    UIView *newSeltect = [self viewWithTag:kPointTag+new];
    CGRect newTemp = newSeltect.frame;
    
    if (_currentPointImg) {
        UIView *imgview = [oldSelect viewWithTag:kCurrentPointImgTag];
        [imgview removeFromSuperview];
        
        newSeltect.backgroundColor = [UIColor clearColor];
        UIImageView *curImg = [UIImageView new];
        curImg.tag = kCurrentPointImgTag;
        curImg.frame = CGRectMake(0, 0, mpSelect.size.width, mpSelect.size.height);
        curImg.image = _currentPointImg;
        [newSeltect addSubview:curImg];
    }
    if (_otherPointImg) {
        UIView *imgview=[newSeltect viewWithTag:kOtherPointImgTag + kPointTag + new];
        [imgview removeFromSuperview];
        
        oldSelect.backgroundColor = [UIColor clearColor];
        UIImageView *otherImg = [UIImageView new];
        otherImg.tag = kOtherPointImgTag + kPointTag + new;
        otherImg.frame = CGRectMake(0, 0, mpSelect.size.width, mpSelect.size.height);
        otherImg.image = _otherPointImg;
        [oldSelect addSubview:otherImg];
    }
    oldSelect.backgroundColor = _otherColor;
    newSeltect.backgroundColor = _currentColor;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat lx = mpSelect.origin.x;
        if (new < old)
            lx += _pointSize * (_currentMultiple - _otherMultiple);
        oldSelect.frame = CGRectMake(lx, mpSelect.origin.y, _pointSize * _otherMultiple, _pointSize);
        
        CGFloat mx=newTemp.origin.x;
        if (new > old)
            mx -= _pointSize * (_currentMultiple - _otherMultiple);
        newSeltect.frame=CGRectMake(mx, newTemp.origin.y, _pointSize * _currentMultiple, _pointSize);
        
        // 左边的时候到右边 越过点击
        if (new-old > 1) {
            for (NSInteger t = old+1; t<new; t++) {
                UIView *ms = [self viewWithTag:kPointTag + t];
                ms.frame = CGRectMake(ms.frame.origin.x - _pointSize * (_currentMultiple - _otherMultiple),
                                      ms.frame.origin.y,
                                      _pointSize * _otherMultiple,
                                      _pointSize);
            }
        }
        // 右边选中到左边的时候 越过点击
        if (new - old < -1) {
            for(NSInteger t = new+1; t < old; t++) {
                UIView *ms = [self viewWithTag:kPointTag + t];
                ms.frame=CGRectMake(ms.frame.origin.x + _pointSize * (_currentMultiple - _otherMultiple),
                                    ms.frame.origin.y,
                                    _pointSize * _otherMultiple,
                                    _pointSize);
            }
        }
    }];
}


- (void)clickAction:(UITapGestureRecognizer*)recognizer {
    NSInteger index = recognizer.view.tag - kPointTag;
    [self setCurrentPage:index];
}

- (BOOL)isTheSameColor:(UIColor*)color1 anotherColor:(UIColor*)color2 {
    return  CGColorEqualToColor(color1.CGColor, color2.CGColor);
}

@end
