//
//  JHSegmentView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/25.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentUIView.h"
#import "NSString+NTES.h"

const CGFloat indicateViewWidth = 25;//默认宽度(两个字)
const CGFloat indicateViewHeight = 2;
const CGFloat titleFontSize = 15;
const CGFloat cornerRadius = 14;
const CGFloat redDotWH = 14;//红点宽高
const NSUInteger redDotHexColor = 0xFC4200;
const NSUInteger titleNormalHexColor = 0x666666;
const NSUInteger titleSelectdHexColor = 0x333333;
const NSUInteger buttonNormalHexColor = 0xEEEEEE;
const NSUInteger buttonSelectdHexColor = 0xFEE100;

@interface JHSegmentUIView ()
{
    JHSegmentType segmentType;
    JHSegmentThemeType themeType;
}

@property (nonatomic, strong) UIFont* titleFont;
//@property (nonatomic, strong) UILabel* redDotView;
@property (nonatomic, strong) UIImageView *indicateView;
@property (nonatomic, strong) NSMutableArray<UIButton*>*titleArray;
@property (nonatomic, strong) NSMutableArray<UILabel*>*dotArray;

@end

@implementation JHSegmentUIView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
}

- (instancetype)initWithType:(JHSegmentType)type
{
    segmentType = type;
    return [self init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.titleArray = [NSMutableArray array];
        _tabSideMargin = kTabSideMargin;
        _tabIntervalSpace = kTabSideMargin;
        _fontSize = titleFontSize;
        _normalColor = titleNormalHexColor;
        _selectedColor = titleSelectdHexColor;
        _btnNormalColor = buttonNormalHexColor;
        _btnSelectedColor = buttonSelectdHexColor;
        if(JHSegmentTypeUnderline == segmentType)
            [self addSubview:self.indicateView];
    }
    
    return self;
}

- (void)setSegmentThemeType:(JHSegmentThemeType)type
{
    themeType = type;
    if(type == JHSegmentThemeTypeClearColor)
    {
        self.backgroundColor = [UIColor clearColor];
        _normalColor = 0xFFFFFF;
        _selectedColor = 0xFFFFFF;
    }
}

-(void)setSegmentTitle:(NSArray*)titles
{
    UIButton * lastView;
    self.dotArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [titles count]; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = self.titleFont;
        [button setTitleColor:HEXCOLOR(_normalColor) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(_selectedColor) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        if(JHSegmentTypeCornerButton == segmentType)
        {
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
            button.backgroundColor = HEXCOLOR(_btnNormalColor);
            button.layer.cornerRadius = cornerRadius;
            button.layer.masksToBounds = YES;
            button.clipsToBounds = YES;
        }
        [self addSubview:button];
        [self.titleArray addObject:button];
        
        UILabel *_redDotView = [[UILabel alloc] init];
        _redDotView.backgroundColor = HEXCOLOR(redDotHexColor);
        _redDotView.font = [UIFont systemFontOfSize:10];
        _redDotView.textColor = [UIColor whiteColor];
        _redDotView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_redDotView];
        [self.dotArray addObject:_redDotView];
        //默认两位数
        CGSize size = [@"99" stringSizeWithFont:_redDotView.font];
        _redDotView.layer.cornerRadius = size.width/2.0;
        _redDotView.layer.masksToBounds = YES;
        _redDotView.hidden = YES;
        
        [_redDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(button.mas_right);
            make.centerY.mas_equalTo(button.mas_top).offset(6);
            make.height.width.mas_equalTo(size.width);
        }];

        if (i == _currentIndex) {
            button.selected = YES;
            button.titleLabel.font = JHMediumFont(_fontSize);
            if(JHSegmentTypeCornerButton == segmentType)
                button.backgroundColor = HEXCOLOR(_btnSelectedColor);
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if(JHSegmentTypeUnderline == segmentType)
            {
                make.height.equalTo(self).offset(-indicateViewHeight-16);
                make.centerY.equalTo(self).offset(-indicateViewHeight/2.0);
            }
            else
            {
                make.height.equalTo(self).offset(-cornerRadius);
                make.centerY.equalTo(self);
            }

            if (i == 0)
                 make.left.equalTo(self).offset(_tabSideMargin);
            else
                make.left.equalTo(lastView.mas_right).offset(_tabIntervalSpace);
            if (i == [titles count] - 1)
                make.right.equalTo(self).offset(-_tabSideMargin);
        }];
        
        lastView = button;
    }
    
    //titles数组有一个值时，不显示下划线
    if([titles count] <= 1)
        [self.indicateView setHidden:YES];
}

- (void)setSegmentIndicateImage:(NSString*)imageStr topOffset:(CGFloat)yOffset
{
    if(imageStr && JHSegmentTypeUnderline == segmentType)
    {
        self.indicateView.image = [UIImage imageNamed:imageStr];
#ifdef JH_UNION_PAY
        self.indicateView.frame = CGRectMake(0, self.height/2.+_fontSize/2.+3, indicateViewWidth, indicateViewHeight);
#else
        self.indicateView.frame = CGRectMake(0, self.height - yOffset - indicateViewHeight, indicateViewWidth, indicateViewHeight);
#endif
    }
}

- (void)setSegmentIndicateImageWithTopOffset:(CGFloat)yOffset
{
    [self setSegmentIndicateImage:@"coupon_segment_image" topOffset:yOffset];
}

- (void)setSegmentIndicateImage:(NSString*)imageStr
{
    [self setSegmentIndicateImage:imageStr topOffset:0];
}

- (void)setSegmentViewShadow
{
    [self setSegmentViewShadowOffset:CGSizeZero];
}

- (void)setSegmentViewShadowOffset:(CGSize)offset
{
    self.layer.shadowColor = HEXCOLOR(0x999999).CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 2;
    self.layer.masksToBounds = NO;
}

- (UIButton*)tabButtonWithIndex:(NSUInteger)index
{
    if(index >= 0 && index < [self.titleArray count])
    {
        return self.titleArray[index];
    }
    return nil;
}

- (void)setCurrentIndex:(NSUInteger)index
{
    if(index < [self.titleArray count])
    {
        for (NSInteger i = 0; i < [self.titleArray count]; i++) {
            UIButton * btn = self.titleArray[i];
            btn.selected=NO;
            btn.titleLabel.font = JHFont(_fontSize);
            if(JHSegmentTypeCornerButton == segmentType)
                btn.backgroundColor = HEXCOLOR(_btnNormalColor);
            else
                btn.backgroundColor = [UIColor clearColor];
        }
        UIButton * button = self.titleArray[index];
        button.selected = YES;
        //选中需修改字体
        button.titleLabel.font = JHMediumFont(_fontSize);
        
        [self layoutIfNeeded];
        if(JHSegmentTypeUnderline == segmentType)
        {
             [UIView animateWithDuration:0.25f animations:^{
                 if(self.indicateAutoWidth)
                     self.indicateView.width = button.width;
                 self.indicateView.center = CGPointMake(button.center.x, self.indicateView.center.y);
            }];
        }
        else if(JHSegmentTypeCornerButton == segmentType)
            button.backgroundColor = HEXCOLOR(_btnSelectedColor);
    }
}

- (void)setRedDotNum:(NSUInteger)num withIndex:(NSUInteger)index
{
    if (index < [self.dotArray count])
    {
        UILabel *label = self.dotArray[index];
        label.hidden = num <= 0;
        label.text = [NSString stringWithFormat:@"%zd", num];
    }
}

- (UIFont *)titleFont
{
    return JHFont(_fontSize);
}

#pragma mark -- subviews
- (UIImageView*)indicateView
{
    if (!_indicateView) {
        _indicateView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _indicateView.image = [UIImage imageNamed:@"home_top_line"];
        _indicateView.contentMode = UIViewContentModeScaleAspectFill;
        _indicateView.clipsToBounds = YES;
    }
    return _indicateView;
}

#pragma mark -- event
-(void)buttonPress:(UIButton*)button
{
    for ( UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font = JHFont(_fontSize);
            if(JHSegmentTypeCornerButton == segmentType)
                btn.backgroundColor = HEXCOLOR(_btnNormalColor);
            else
                btn.backgroundColor = [UIColor clearColor];
        }
    }
    
    button.selected=YES;
    //选中需修改字体
    button.titleLabel.font = JHMediumFont(_fontSize);
    
    if(JHSegmentTypeUnderline == segmentType)
    {
        [UIView animateWithDuration:0.25f animations:^{
            if(self.indicateAutoWidth)
                self.indicateView.width = button.width;
            self.indicateView.center = CGPointMake(button.center.x, self.indicateView.center.y);
        }];
    }
    else if(JHSegmentTypeCornerButton == segmentType)
        button.backgroundColor = HEXCOLOR(_btnSelectedColor);
    
    if ([self.sDelegate respondsToSelector:@selector(pressSegmentButtonIndex:)])
    {
        NSUInteger idx = [self.titleArray indexOfObject:button];
        [self.sDelegate pressSegmentButtonIndex:idx];
    }
}

@end
