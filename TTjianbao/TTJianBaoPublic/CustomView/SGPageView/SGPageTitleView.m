//
//  SGPageTitleView.m
//  TTjianbao
//
//  Created by YJ on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "SGPageTitleView.h"
#import "UIView+SGFrame.h"
#import "SGHelperTool.h"
#import "UIView+SDAutoLayout.h"
#import "SGButton.h"
#import "TTJianBaoColor.h"
#import "JHChannleModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#define kDefaultChannelImage [UIImage imageNamed:@"channel_place"]
#define PAD 15
#define LEFT_PAD 5

/** 按钮之间的间距 */
static CGFloat SGPageTitleViewBtnMargin = 0;

/** 指示器的动画移动时间 */
static CGFloat SGIndicatorAnimationTime = 0.1;
/** 标题文字大小 */

static CGFloat SGPageTitleViewTextFont = 12.0f;


@interface SGPageTitleView ()
/** delegatePageTitleView */
@property (nonatomic, weak) id<SGPageTitleViewDelegate> delegatePageTitleView;

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//指示器
//@property (nonatomic, strong) UIView *indicatorView;
//存储标题按钮的数组
@property (nonatomic, strong) NSMutableArray *btnMArr;
//tempBtn
@property (nonatomic, strong) SGButton *tempBtn;
//选中按钮的下标
@property (nonatomic, assign) NSInteger currentIndex;
//记录所有按钮文字宽度
@property (nonatomic, assign) CGFloat allBtnTextWidth;
//记录所有子控件的宽度
@property (nonatomic, assign) CGFloat allBtnWidth;

//开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
//完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

@property (nonatomic, strong) NSArray *channelModelsArray;

@end

@implementation SGPageTitleView


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate channelModels:(NSArray *)models
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = CHANNER_COLOR;
        
        self.currentIndex = 0;
        self.selectedIndex = 0;
        
        self.delegatePageTitleView = delegate;
        
        self.channelModelsArray = [NSArray new];
        self.channelModelsArray = models;
        
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)pageTitleViewWithFrame:(CGRect)frame delegate:(id<SGPageTitleViewDelegate>)delegate channelModels:(NSArray *)models
{
    return [[super alloc] initWithFrame:frame delegate:delegate channelModels:models];
}


- (void)initialization
{
    self.indicatorStyle = SGIndicatorTypeDefault;
    self.isTitleGradientEffect = YES;
    self.isIndicatorScroll = YES;
    self.isShowIndicator = YES;
    self.isNeedBounces = YES;
}

- (void)setupSubviews
{
    // 1、添加 UIScrollView
    [self addSubview:self.scrollView];
    
    // 2、添加标题按钮
    [self setupTitleButtons];
    
    // 3、添加指示器
    //[self setupIndicatorView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 默认选中下标
    if (self.selectedIndex == 0)
    {
        self.selectedIndex = 0;
    }
}

- (NSMutableArray *)btnMArr
{
    if (!_btnMArr)
    {
        _btnMArr = [NSMutableArray array];
    }
    return _btnMArr;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (UIView *)indicatorView
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor whiteColor];//指示器的颜色
    }
    return _indicatorView;
}

//添加标题按钮
- (void)setupTitleButtons
{
    // 计算所有按钮的文字宽度
    [self.channelModelsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        JHChannleModel *model = self.channelModelsArray[idx];
        
        CGFloat tempWidth = [SGHelperTool SG_widthWithString:model.name font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
        
        if (tempWidth < 44 + PAD*2)
        {
            tempWidth = 44 + PAD*2;
        }
        
        self.allBtnTextWidth += tempWidth;
    }];
    
    // 所有按钮文字宽度 ＋ 按钮之间的间隔
    self.allBtnWidth = SGPageTitleViewBtnMargin * (self.channelModelsArray.count + 1) + self.allBtnTextWidth;
    
    if (self.allBtnWidth <= self.bounds.size.width)
    {
        //SGPageTitleView 不可滚动
        CGFloat btnY = 0;
        //CGFloat btnW = self.frame.size.width / self.channelModelsArray.count;
        CGFloat btnW = 44 + PAD*2;
        CGFloat btnH = self.frame.size.height;
        
        for (NSInteger index = 0; index < self.channelModelsArray.count; index++)
        {
            SGButton *btn = [SGButton buttonWithType:(UIButtonTypeCustom)];
            btn.tag = index;
            CGFloat btnX = LEFT_PAD + btnW * index;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            JHChannleModel *model = self.channelModelsArray[index];
            
             if (index == 0)
            {
                [btn setImageWithURL:[NSURL URLWithString:model.selectedIcon] forState:UIControlStateNormal placeholder:kDefaultChannelImage];
            }
            else
            {
                [btn setImageWithURL:[NSURL URLWithString:model.notSelectedIcon] forState:UIControlStateNormal placeholder:kDefaultChannelImage];
            }

            //btn.imageView.layer.cornerRadius = 44/2;
            btn.imageView.clipsToBounds = YES;
            //btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            //btn.layer.masksToBounds = YES;
            btn.clipsToBounds = YES;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:SGPageTitleViewTextFont];
            btn.titleLabel.layer.cornerRadius = 17/2;
            [btn setTitleColor:BLACK_COLOR forState:(UIControlStateNormal)];
            [btn setTitle:model.name forState:(UIControlStateNormal)];
            btn.backgroundColor = CHANNER_COLOR;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
        }
        
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    }
    else
    {
        //SGPageTitleView 可滚动
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnH = self.frame.size.height;
        
        for (NSInteger index = 0; index < self.channelModelsArray.count; index++)
        {
            SGButton *btn = [SGButton buttonWithType:(UIButtonTypeCustom)];
            btn.backgroundColor = CHANNER_COLOR;
            
            JHChannleModel *model = self.channelModelsArray[index];
            
            CGFloat tempWidth = [SGHelperTool SG_widthWithString:model.name font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            
            if (tempWidth < 44 + PAD*2)
            {
                tempWidth = 44 + PAD*2;
            }
            
            CGFloat btnW = tempWidth;
            btn.frame = CGRectMake(LEFT_PAD + btnX, btnY, btnW, btnH);
            btnX = btnX + btnW;
            btn.tag = index;
            
            if (index == 0)
            {
                [btn setImageWithURL:[NSURL URLWithString:model.selectedIcon] forState:UIControlStateNormal placeholder:kDefaultChannelImage];
            }
            else
            {
                [btn setImageWithURL:[NSURL URLWithString:model.notSelectedIcon] forState:UIControlStateNormal placeholder:kDefaultChannelImage];
            }
            
            //btn.imageView.layer.cornerRadius = 44/2;
            btn.imageView.clipsToBounds = YES;
            //btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.layer.masksToBounds = YES;
            btn.clipsToBounds = YES;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:SGPageTitleViewTextFont];
            btn.titleLabel.layer.cornerRadius = 17/2;
            [btn setTitleColor:BLACK_COLOR forState:(UIControlStateNormal)];
            [btn setTitle:model.name forState:(UIControlStateNormal)];
                        
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.btnMArr addObject:btn];
            [self.scrollView addSubview:btn];
        }
        
        CGFloat scrollViewWidth = CGRectGetMaxX(self.scrollView.subviews.lastObject.frame);
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    }
}

- (UIImage *)imageFromURLString:(NSString *)urlstring
{
    return [UIImage imageWithData:[NSData
        dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}

//添加指示器
- (void)setupIndicatorView
{
//    UIView *bgView = [[UIView alloc] init];
//    CGFloat bgViewX = 0;
//    //CGFloat bgViewY = self.SG_height - 0.5;
//    CGFloat bgViewY = self.SG_height - 5;
//    CGFloat bgViewW = self.SG_width;
//    //CGFloat bgViewH = 0.5;
//    CGFloat bgViewH = 5;
//    bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
//    bgView.layer.cornerRadius = 5/2;
//    bgView.clipsToBounds = YES;
//    //bgView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:bgView];
//
//    //获取第一个按钮
//    SGButton *firstBtn = self.btnMArr.firstObject;
//    if (firstBtn == nil)
//    {
//        return;
//    }
//
//    // 添加指示器
//    [self.scrollView addSubview:self.indicatorView];
//
//    CGFloat indicatorViewX = firstBtn.frame.origin.x;
//    CGFloat indicatorViewY = self.SG_height - SGIndicatorHeight;
//    CGFloat indicatorViewW = firstBtn.SG_width;
//    CGFloat indicatorViewH = SGIndicatorHeight;
//    self.indicatorView.frame = CGRectMake(indicatorViewX, indicatorViewY, indicatorViewW, indicatorViewH);
}

//标题按钮的点击事件
- (void)btnAction:(SGButton *)button
{
    if (self.currentIndex == button.tag)
    {
        //重复点击
        if ([self.delegatePageTitleView respondsToSelector:@selector(SGPageTitleView:repeatClickIndex:)])
        {
            [self.delegatePageTitleView SGPageTitleView:self repeatClickIndex:button.tag];
        }
    }
    
    // 0、改变按钮的选择状态
    [self changeSelectedButton:button];
    
    // 1、记录选中按钮的下标
    self.currentIndex = button.tag;
    
    // 2、滚动标题选中居中
    [self selectedBtnCenter:button];
    
    // 3、指示器位置发生改变
    if (self.allBtnWidth <= self.bounds.size.width)
    {
        //SGPageTitleView 不可滚动
        [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
            if (self.indicatorStyle == SGIndicatorTypeEqual)
            {
                self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:button.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
            else
            {
                self.indicatorView.SG_width = button.SG_width;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
        }];
    }
    else
    {
        //SGPageTitleView 可滚动
        [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
            if (self.indicatorStyle == SGIndicatorTypeEqual)
            {
                self.indicatorView.SG_width = button.SG_width - SGPageTitleViewBtnMargin;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
            else
            {
                self.indicatorView.SG_width = button.SG_width;
                self.indicatorView.SG_centerX = button.SG_centerX;
            }
        }];
    }

    // 4、pageTitleViewDelegate
    if ([self.delegatePageTitleView respondsToSelector:@selector(SGPageTitleView:selectedIndex:)])
    {
        [self.delegatePageTitleView SGPageTitleView:self selectedIndex:self.currentIndex];
    }
}

//改变按钮的选择状态
- (void)changeSelectedButton:(SGButton *)button
{
    if (self.tempBtn == nil)
    {
        //首次进入执行
        button.selected = YES;
        self.tempBtn = button;
        
        self.tempBtn.titleLabel.layer.backgroundColor = YELLOW_COLOR.CGColor;
    }
    else if (self.tempBtn != nil && self.tempBtn == button)
    {
        button.selected = YES;
        self.tempBtn.titleLabel.layer.backgroundColor = YELLOW_COLOR.CGColor;
    }
    else if (self.tempBtn != button && self.tempBtn != nil)
    {
        //上次选中button
        JHChannleModel *tmodel = self.channelModelsArray[self.tempBtn.tag];
        [self.tempBtn setImageWithURL:[NSURL URLWithString:tmodel.notSelectedIcon] forState:UIControlStateNormal placeholder:kDefaultChannelImage];
        
        //本次选中的button
        JHChannleModel *model = self.channelModelsArray[button.tag];

        [button setImageWithURL:[NSURL URLWithString:model.selectedIcon] forState:UIControlStateNormal placeholder:kDefaultChannelImage];
        
        button.titleLabel.layer.backgroundColor = YELLOW_COLOR.CGColor;
        self.tempBtn.titleLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;

        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    }
}

//滚动标题选中居中
- (void)selectedBtnCenter:(SGButton *)centerBtn
{
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.frame.size.width * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    //获取最大滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.frame.size.width;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    //滚动标题滚动条-----胡sir--添加
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

//给外界提供的方法
- (void)setPageTitleViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    // 1、取出 originalBtn／targetBtn
    SGButton *originalBtn = self.btnMArr[originalIndex];
    SGButton *targetBtn = self.btnMArr[targetIndex];

    // 2、改变按钮的选择状态
    if (progress >= 0.8)
    {
        [self changeSelectedButton:targetBtn];
    }
    
    // 3、 滚动标题选中居中
    [self selectedBtnCenter:targetBtn];
    
    // 4、处理指示器的逻辑
    if (self.allBtnWidth <= self.bounds.size.width)
    {
        //SGPageTitleView 不可滚动
        if (self.isIndicatorScroll)
        {
            //计算 targetBtn／originalBtn 之间的距离
            CGFloat targetBtnX = CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.SG_width / self.channelModelsArray.count - [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]) - [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            CGFloat originalBtnX = CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.SG_width / self.channelModelsArray.count - [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]) - [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            CGFloat totalOffsetX = targetBtnX - originalBtnX;
            //计算 indicatorView 滚动时 X 的偏移量
            CGFloat offsetX;
            //计算 targetBtn／originalBtn 宽度的差值
            CGFloat targetBtnDistance = (CGRectGetMaxX(targetBtn.frame) - 0.5 * (self.SG_width / self.channelModelsArray.count - [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]));
            CGFloat originalBtnDistance = (CGRectGetMaxX(originalBtn.frame) - 0.5 * (self.SG_width / self.channelModelsArray.count - [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]]));
            CGFloat totalDistance = targetBtnDistance - originalBtnDistance;
            //计算 indicatorView 滚动时宽度的偏移量
            CGFloat distance;
            if (self.indicatorStyle == SGIndicatorTypeEqual)
            {
                offsetX = totalOffsetX * progress;
                distance = progress * (totalDistance - totalOffsetX);
                /// 计算 indicatorView 新的 frame
                CGRect temp = self.indicatorView.frame;
                temp.origin.x = originalBtnX + offsetX;
                temp.size.width = [SGHelperTool SG_widthWithString:originalBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]] + distance;
                self.indicatorView.frame = temp;
                
            }
            else
            {
                // 3、处理指示器的逻辑
                CGFloat moveTotalX = targetBtn.SG_origin.x - originalBtn.SG_origin.x;
                CGFloat moveX = moveTotalX * progress;
                self.indicatorView.SG_centerX = originalBtn.SG_centerX + moveX;
            }
        }
        else
        {
            if (progress > 0.5)
            {
                [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
                    if (self.indicatorStyle == SGIndicatorTypeEqual)
                    {
                        self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:targetBtn.currentTitle font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                    else
                    {
                        self.indicatorView.SG_width = targetBtn.SG_width;
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                }];
            }
        }

    }
    else
    {
        //SGPageTitleView 可滚动
        if (self.isIndicatorScroll)
        {
            //计算 targetBtn／originalBtn 之间的距离
            CGFloat totalOffsetX = targetBtn.SG_origin.x - originalBtn.SG_origin.x;
            //计算 indicatorView 滚动时 X 的偏移量
            CGFloat offsetX;
            //计算 targetBtn／originalBtn 宽度的差值
            CGFloat totalDistance = CGRectGetMaxX(targetBtn.frame) - CGRectGetMaxX(originalBtn.frame);
            //计算 indicatorView 滚动时宽度的偏移量
            CGFloat distance;
            if (self.indicatorStyle == SGIndicatorTypeEqual)
            {
                offsetX = totalOffsetX * progress + 0.5 * SGPageTitleViewBtnMargin;
                distance = progress * (totalDistance - totalOffsetX) - SGPageTitleViewBtnMargin;
            }
            else
            {
                offsetX = totalOffsetX * progress;
                distance = progress * (totalDistance - totalOffsetX);
            }
            
            //计算 indicatorView 新的 frame
            CGRect temp = self.indicatorView.frame;
            temp.origin.x = originalBtn.SG_origin.x + offsetX;
            temp.size.width = originalBtn.SG_width + distance;
            self.indicatorView.frame = temp;
            
        }
        else
        {
            if (progress > 0.5)
            {
                [UIView animateWithDuration:SGIndicatorAnimationTime animations:^{
                    if (self.indicatorStyle == SGIndicatorTypeEqual)
                    {
                        self.indicatorView.SG_width = targetBtn.SG_width - SGPageTitleViewBtnMargin;
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                    else
                    {
                        self.indicatorView.SG_width = targetBtn.SG_width;
                        self.indicatorView.SG_centerX = targetBtn.SG_centerX;
                    }
                }];
            }
        }
    }
    
    // 5、颜色的渐变(复杂)
    if (self.isTitleGradientEffect)
    {
        if (self.titleColorStateSelected)
        {
            
        }
        else
        {

        }
    }
}

- (void)setTitleColorStateNormal:(UIColor *)titleColorStateNormal
{
    _titleColorStateNormal = titleColorStateNormal;
    [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        SGButton *btn = obj;
        [btn setTitleColor:titleColorStateNormal forState:(UIControlStateNormal)];
    }];
    
    [self setupStartColor:titleColorStateNormal];
}

- (void)setTitleColorStateSelected:(UIColor *)titleColorStateSelected
{
    _titleColorStateSelected = titleColorStateSelected;
    [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        SGButton *btn = obj;
        [btn setTitleColor:titleColorStateSelected forState:(UIControlStateSelected)];
    }];
    
    [self setupEndColor:titleColorStateSelected];
}

//indicatorColor
- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

//selectedIndex
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (selectedIndex)
    {
        [self btnAction:self.btnMArr[self.selectedIndex]];
    }
    else
    {
        // 默认选择选中第一个按钮
        [self btnAction:self.btnMArr[self.selectedIndex]];
    }
}

//indicatorStyle
- (void)setIndicatorStyle:(SGIndicatorType)indicatorStyle
{
    _indicatorStyle = indicatorStyle;
    
    JHChannleModel *model = self.channelModelsArray[self.selectedIndex];
    
    if (indicatorStyle == SGIndicatorTypeEqual)
    {
        if (self.selectedIndex)
        {
            SGButton *selectedBtn = self.btnMArr[self.selectedIndex];
            
            self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:model.name font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            self.indicatorView.SG_centerX = selectedBtn.SG_centerX;
        }
        else
        {
            SGButton *selectedBtn = self.btnMArr.firstObject;
            self.indicatorView.SG_width = [SGHelperTool SG_widthWithString:model.name font:[UIFont systemFontOfSize:SGPageTitleViewTextFont]];
            self.indicatorView.SG_centerX = selectedBtn.SG_centerX;
        }
    }
}

//isTitleGradientEffect
- (void)setIsTitleGradientEffect:(BOOL)isTitleGradientEffect
{
    _isTitleGradientEffect = isTitleGradientEffect;
}

//isIndicatorScroll
- (void)setIsIndicatorScroll:(BOOL)isIndicatorScroll
{
    _isIndicatorScroll = isIndicatorScroll;
}

//isShowIndicator
- (void)setIsShowIndicator:(BOOL)isShowIndicator
{
    _isShowIndicator = isShowIndicator;
    if (isShowIndicator == NO)
    {
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

//isNeedBounces
- (void)setIsNeedBounces:(BOOL)isNeedBounces
{
    _isNeedBounces = isNeedBounces;
    if (isNeedBounces == NO)
    {
        self.scrollView.bounces = NO;
    }
}

//开始颜色设置
- (void)setupStartColor:(UIColor *)color
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}

//结束颜色设置
- (void)setupEndColor:(UIColor *)color
{
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++)
    {
        components[component] = resultingPixel[component] / 255.0f;
    }
}


@end

