//
//  JHPersonalResellView.m
//  TTjianbao
//
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonalResellView.h"
#import "JHPersonalResellSubController.h"

@interface JHPersonalResellView ()
{
    UILabel* numLabel;
    NSArray* tabTitleArray;
    JHActionBlock mClickAction;
    NSMutableArray* pageViewControllers;
}
@end

@implementation JHPersonalResellView

- (void)drawSubviews:(JHActionBlock)clickAction
{
    mClickAction = clickAction; //点击事件
    
    self.backgroundColor = HEXCOLOR(0xF8F8F8);
    tabTitleArray = [NSArray arrayWithObjects:@"待上架", @"在售", @"已售", nil];
    //tab
    [self drawTabView];
    //page view controllers
    [self drawPageViewController];
}

- (void)drawTabView
{
    //三个tab+两个间距
    [self.segmentView setTabSideMargin:(self.width - ScreenW/375.0*(45 + 30 + 30 + 55*2))/2.0];
    [self.segmentView setTabIntervalSpace:55]; //间距一样吧
    [self.segmentView setSegmentTitle:tabTitleArray];
    [self.segmentView setSegmentIndicateImageWithTopOffset:6];
    [self.segmentView setCurrentIndex:0];
//    [self.segmentView setSegmentViewShadowOffset:CGSizeMake(0, -3)];
}

- (void)drawPageViewController
{
    pageViewControllers = [NSMutableArray array];
    for (int i = 0; i < [tabTitleArray count]; i ++)
    {
        JHPersonalResellSubController* controller = [[JHPersonalResellSubController alloc] initWithPageType:i];
        JH_WEAK(self)
        controller.customAction = ^(NSNumber* pageType, NSString* num) {
            JH_STRONG(self)
            if([pageType integerValue] == self.lastSegmentIndex)
            {
                [self drawTabNum:num];
            }
        };
        [pageViewControllers addObject:controller];
    }
    
    [self setPageViewController:pageViewControllers scrollViewTop:10 + self.segmentView.bottom];
}

#pragma mark - tab 后 total
- (void)drawNumLabel
{
    if(!numLabel)
    {
        numLabel = [UILabel new];
        numLabel.font = JHFont(15);
        numLabel.textColor = HEXCOLOR(0x333333);
        numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numLabel];
    }
}
//tab后面的number
- (void)drawTabNum:(NSString*)num
{return; //这版暂时屏蔽
    [self drawNumLabel];
    
    if(num)
    {
        //当前选中tab button,仅为获取坐标
        UIButton* placeholdButton = [self.segmentView tabButtonWithIndex:self.lastSegmentIndex];
        numLabel.text = [self makeShowNum:num];
        [numLabel setHidden:NO];
        [numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(placeholdButton);
            make.left.mas_equalTo(placeholdButton.mas_right).offset(-5);
            make.height.mas_offset(21);
        }];
    }
    else
    {
        [numLabel setHidden:YES];
    }
}

- (NSString*)makeShowNum:(NSString*)num
{
    NSString* total = num;
    NSInteger count = [num integerValue];
    if(count > 99)
    {
        total = @"（99+）";
    }
    else
    {
        total = [NSString stringWithFormat:@"（%@）", num];
    }
    return total;
}

#pragma mark - 刷新list及tab后面数字
- (void)backToTableviewTop:(NSUInteger)index
{
    [super backToTableviewTop: index];
    if(index < [pageViewControllers count])
    {
        JHPersonalResellSubController* controller = pageViewControllers[index];
        [controller refreshPage];
    }
}

@end
