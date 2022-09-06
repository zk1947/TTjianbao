//
//  JHHorizontalScrollView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHHorizontalScrollView.h"
#import "JHPurchaseStoneModel.h"
#import "JHUIFactory.h"
#import "JHUIButton.h"

/**
 * 默认准备6个位置,超过以后自定义添加
 * 根据传入类型,决定显示与否
 */
#define kButtonDefaultCount 6

@implementation JHHorizontalScrollView
{
    NSArray* imageArray;
    NSMutableArray* buttonArray;//存放大图
    NSMutableArray* imageViewArray;//视频类型时,大图上面的小图标
}

- (instancetype)initWithDelegate:(id)delegate
{
    if(self = [super init])
    {
        self.hDelegate = delegate;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        buttonArray = [NSMutableArray array];
        imageViewArray = [NSMutableArray array];
        [self addSubviews];
    }
    
    return self;
}
//默认6个图片位置
- (void)addSubviews
{
    JHUIButton* lastButton = nil;
    JHUIButton* newButton;
    for (NSInteger i = 0; i < kButtonDefaultCount; i++)
    {
        //背景大图
        newButton = [JHUIButton buttonWithType:UIButtonTypeCustom];
        newButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        newButton.tag = kHorizontalScrollViewButtonTag+i;
        newButton.layer.cornerRadius = 4.0;
        [buttonArray addObject:newButton];//save
        [newButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:newButton];
        [newButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastButton)
                make.left.mas_equalTo(lastButton.mas_right).offset(kHorizontalScrollViewButtonMargin);
            else
                make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(kHorizontalScrollViewButtonWidth);
        }];
        
        //视频需要小图标
        UIImageView* playImage = [JHUIFactory createImageView];
        playImage.userInteractionEnabled = NO;
        [playImage setImage:[UIImage imageNamed:@"stone_video_play"]];
        [newButton addSubview:playImage];
        [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(newButton);
            make.size.mas_equalTo(20);
        }];
        [imageViewArray addObject:playImage];//save
        //记录最新button
        lastButton = newButton;
    }
}
//超过后自定义添加图片
- (JHUIButton*)addAddtionalSubviews:(JHPurchaseStoneListAttachmentModel*)model lastButton:(JHUIButton*)aLastButton
{
    JHUIButton* lastButton = aLastButton;
    JHUIButton* newButton;
    
    newButton = [JHUIButton buttonWithType:UIButtonTypeCustom];
    newButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    newButton.tag = kHorizontalScrollViewButtonTag+i;
    newButton.layer.cornerRadius = 4.0;
    [newButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:newButton];
    [newButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if(lastButton)
            make.left.mas_equalTo(lastButton.mas_right).offset(kHorizontalScrollViewButtonMargin);
        else
            make.left.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(kHorizontalScrollViewButtonWidth);
    }];
    
    //需要判断image是否有效
    if([model.coverUrl length] > 0)
    {
        [newButton asynSetBackgroundImage:model.coverUrl];
    }
    
    //视频=2需要小图标
    if([model.attachmentType intValue] == 2)
    {
        UIImageView* playImage = [JHUIFactory createImageView];
        playImage.userInteractionEnabled = NO;
        [playImage setImage:[UIImage imageNamed:@"stone_video_play"]];
        [newButton addSubview:playImage];
        [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(newButton);
            make.size.mas_equalTo(20);
        }];
    }
    //记录最新button
//    lastButton = newButton;
    return newButton;
}
//清除额外添加的图片
- (void)clearAddtionalSubviews
{
    for (JHUIButton* btn in self.subviews)
    {
        if(btn.tag >= kHorizontalScrollViewButtonTag+kButtonDefaultCount)
            [btn removeFromSuperview];//删除
        else if(btn.tag >= kHorizontalScrollViewButtonTag)
            [btn setHidden:YES];//隐藏
    }
}

- (void)updateSubviews:(NSArray*)imageArr
{
    [self clearAddtionalSubviews];//优先清理
    
    imageArray = [NSArray arrayWithArray:imageArr];
    
    JHUIButton* lastButton = nil;
    JHUIButton* newButton;
    UIImageView* playImage;
    
    for (NSInteger i = 0; i < [imageArray count]; i++)
    {
        JHPurchaseStoneListAttachmentModel* model = imageArray[i];
        if(i < kButtonDefaultCount)
        {
            newButton = [buttonArray objectAtIndex:i];
            lastButton = newButton;
            //需要判断image是否有效
            if([model.coverUrl length] > 0)
            {
                [newButton asynSetBackgroundImage:model.coverUrl];
                [newButton setHidden:NO];//显示
            }

            //视频需要小图标
            playImage = [imageViewArray objectAtIndex:i];
            [playImage setHidden:([model.attachmentType intValue] == 2) ? NO : YES];
        }
        else//根据需要添加额外图片>6
        {
            lastButton = [self addAddtionalSubviews:model lastButton:lastButton];
            lastButton.tag = kHorizontalScrollViewButtonTag+kButtonDefaultCount-1+i;
        }
    }
}

#pragma mark - event
- (void)pressButton:(JHUIButton*)button
{
    if([self.hDelegate respondsToSelector:@selector(pressScrollViewButton:)])
    {
        [self.hDelegate pressScrollViewButton:button];
    }
}
@end
