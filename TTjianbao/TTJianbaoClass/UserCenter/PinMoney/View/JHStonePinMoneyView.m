//
//  JHStonePinMoneyView.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStonePinMoneyView.h"
#import "JHStonePinMoneySubViewController.h"
#import "JHUIFactory.h"

@implementation JHStonePinMoneyView
{
    NSArray* tabTitleArray;
    UIView* headerView;
    UILabel* unaccountLabel;
    UILabel* withdrawableLabel;
    JHActionBlock mClickAction;
    UIButton* withdrawButton;
    NSMutableArray* pageViewControllers;
    JHPreTitleLabel *canTakeOut;
}

- (void)drawSubviews:(JHActionBlock)clickAction
{
    mClickAction = clickAction; //点击事件
    
    self.backgroundColor = HEXCOLOR(0xF8F8F8);
#ifdef JH_UNION_PAY
    tabTitleArray = [NSArray arrayWithObjects:@"待结算", @"已结算", @"提现中", @"提现明细", nil];
#else
    tabTitleArray = [NSArray arrayWithObjects:@"收入明细", @"提现明细", @"未入账", @"提现中", nil];
#endif
    self.segmentView.backgroundColor = [UIColor clearColor];
    self.segmentView.height = 51;
    self.segmentView.top = kHeaderViewHeight;

    //head view
    [self drawHeaderView];
    //tab
    [self drawTabView];
    //page view controllers
    [self drawPageViewController];
}

- (void)drawHeaderView
{
#ifdef JH_UNION_PAY
    if(!headerView)
    {
        headerView = [UIView new];
        headerView.backgroundColor = [UIColor clearColor];//HEXCOLOR(0xFFF199);
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(kHeaderViewHeight);
        }];
        
        UIImageView *bgImage = [UIImageView new];
        bgImage.image = [UIImage imageNamed:@"bg_stone_money"];
        bgImage.contentMode = UIViewContentModeScaleAspectFit;
        [headerView addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(headerView);
            make.height.offset(438. / 750. * ScreenW);
        }];
        
        UIView *backWhite = [UIView new];
        backWhite.backgroundColor = [UIColor whiteColor];
        backWhite.layer.cornerRadius = 8;
        backWhite.layer.masksToBounds = YES;
        [headerView addSubview:backWhite];
        [backWhite mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset(70);
            make.top.equalTo(bgImage.mas_bottom).offset(-35);
        }];
        
        canTakeOut = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:15] textAlignment:NSTextAlignmentLeft preTitle:@"可提现："];
        [canTakeOut setJHAttributedText:@"¥0.00" font:[UIFont fontWithName:kFontBoldDIN size:15] color:kColor333];
        [backWhite addSubview:canTakeOut];
        
        [canTakeOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(backWhite);
        }];
        
        withdrawButton = [JHUIFactory createThemeBtnWithTitle:@"提现" cornerRadius:15.0 target:self action:@selector(pressWithdrawButton)];
        [headerView addSubview:withdrawButton];
        [withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backWhite);
            make.right.equalTo(backWhite).offset(-10);
            make.size.mas_equalTo(CGSizeMake(90, 30));
        }];
        
        JHCustomLine* line = [JHUIFactory createLine];
        line.color = HEXCOLOR(0xD0C469);
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(backWhite.mas_top).offset(-39);
            make.centerX.equalTo(headerView);
            make.size.mas_equalTo(CGSizeMake(1, 42));
        }];
        
        //待结算
        unaccountLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(26) textAlignment:NSTextAlignmentCenter preTitle:@"￥"];
        [headerView addSubview:unaccountLabel];
        [unaccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(line).offset(6);
            make.centerX.equalTo(headerView).offset(0 - self.width/4.0);
            make.height.mas_equalTo(37);
        }];
        
        //已结算
        withdrawableLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(26) textAlignment:NSTextAlignmentCenter preTitle:@"￥"];
        [headerView addSubview:withdrawableLabel];
        [withdrawableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView).offset(self.width/4.0);
            make.bottom.equalTo(unaccountLabel);
            make.height.mas_equalTo(37);
        }];

        UILabel* unaccountTag = [JHUIFactory createLabelWithTitle:@"待结算" titleColor:HEXCOLOR(0x7F7635) font:JHFont(14) textAlignment:NSTextAlignmentCenter];
        [headerView addSubview:unaccountTag];
        [unaccountTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(unaccountLabel.mas_top);
            make.height.mas_equalTo(20);
            make.centerX.equalTo(headerView).offset(0 - self.width/4.0);
        }];
        
        UILabel* withdrawableTag = [JHUIFactory createLabelWithTitle:@"已结算" titleColor:HEXCOLOR(0x7F7635) font:JHFont(14) textAlignment:NSTextAlignmentCenter];
        [headerView addSubview:withdrawableTag];
        [withdrawableTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(withdrawableLabel.mas_top);
            make.height.mas_equalTo(20);
            make.centerX.equalTo(headerView).offset(self.width/4.0);
        }];
    }
#else
         if(!headerView)
         {
            headerView = [UIView new]; //header在segmentPageView上面, ~负坐标~
            headerView.backgroundColor = HEXCOLOR(0xFFF199);
             [self addSubview:headerView];
             [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-kHeaderViewHeight);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(kHeaderViewHeight);
             }];
            //从底向上绘画
            withdrawButton = [JHUIFactory createThemeBtnWithTitle:@"提现" cornerRadius:20.0 target:self action:@selector(pressWithdrawButton)];
             [headerView addSubview:withdrawButton];
             [withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(headerView).offset(-29);
                make.centerX.equalTo(headerView);
                make.size.mas_equalTo(CGSizeMake(140, 40));
             }];
             
             JHCustomLine* line = [JHUIFactory createLine];
            line.color = HEXCOLOR(0x7F7635);
             [headerView addSubview:line];
             [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(withdrawButton.mas_top).offset(-19);
                 make.centerX.equalTo(headerView);
                make.size.mas_equalTo(CGSizeMake(1, 44));
             }];
             
             unaccountLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(26) textAlignment:NSTextAlignmentCenter preTitle:@"￥"];
             [headerView addSubview:unaccountLabel];
             [unaccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.bottom.equalTo(line).offset(6);
    //            make.right.mas_equalTo(line.mas_left).offset(-24);
                 make.centerX.equalTo(headerView).offset(-self.width/4.0);
                 make.height.mas_equalTo(37);
             }];
             
             withdrawableLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(26) textAlignment:NSTextAlignmentCenter preTitle:@"￥"];
             [headerView addSubview:withdrawableLabel];
             [withdrawableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.mas_equalTo(line.mas_right).offset(17);
                make.centerX.equalTo(headerView).offset(self.width/4.0);
                make.bottom.equalTo(unaccountLabel);
                make.height.mas_equalTo(37);
             }];
     
            UILabel* unaccountTag = [JHUIFactory createLabelWithTitle:@"未入账" titleColor:HEXCOLOR(0x7F7635) font:JHFont(14) textAlignment:NSTextAlignmentCenter];
             [headerView addSubview:unaccountTag];
             [unaccountTag mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.bottom.mas_equalTo(unaccountLabel.mas_top);
                 make.height.mas_equalTo(20);
                 make.centerX.equalTo(headerView).offset(-self.width/4.0);
             }];
             
            UILabel* withdrawableTag = [JHUIFactory createLabelWithTitle:@"可提现" titleColor:HEXCOLOR(0x7F7635) font:JHFont(14) textAlignment:NSTextAlignmentCenter];
             [headerView addSubview:withdrawableTag];
             [withdrawableTag mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.bottom.mas_equalTo(withdrawableLabel.mas_top);
                 make.height.mas_equalTo(20);
                 make.centerX.equalTo(headerView).offset(self.width/4.0);
             }];
         }

#endif
}

- (void)drawTabView
{
    CGFloat intervalSpace = 25;
    
    #ifdef JH_UNION_PAY
        /*间距:25 三个字x3:45 四个字x1:60*/
        [self.segmentView setTabSideMargin:(self.width - 60 - 45*3 - intervalSpace*3)/2.0];
    #else
        /*间距:25 三个字x2:45 四个字x2:60*/
        [self.segmentView setTabSideMargin:(self.width - 60*2 - 45*2 - intervalSpace*3)/2.0];
        self.segmentView.top = headerView.bottom;
    #endif
    [self.segmentView setTabIntervalSpace:intervalSpace]; //间距一样吧
    [self.segmentView setSegmentTitle:tabTitleArray];
    [self.segmentView setSegmentIndicateImageWithTopOffset:6];
    [self.segmentView setCurrentIndex:0];

    //加条横向
    JHCustomLine* line = [[JHCustomLine alloc] initWithFrame:CGRectMake(0, self.segmentView.bottom-0.5, self.width, 0.5)];
    [self.segmentView addSubview:line];
}

- (void)drawPageViewController
{
    pageViewControllers = [NSMutableArray array];
    for (int i = 0; i < [tabTitleArray count]; i ++)
    {
        JHStonePinMoneySubViewController* controller = [[JHStonePinMoneySubViewController alloc] initWithPageType:i];
        [pageViewControllers addObject:controller];
    }
    
    [self setPageViewController:pageViewControllers];
}

#pragma mark - refresh
- (void)refreshHeaderView:(JHAccountInfoModel*)model reloadTable:(BOOL)isReload
{
    //TODO:yaoyao 字段数据调整
    unaccountLabel.text = model.incomeFreezeAccount;
    withdrawableLabel.text = model.withdrawAccount;
#ifdef JH_UNION_PAY
    canTakeOut.text = [NSString stringWithFormat:@"￥%@", model.withdrawAccount];
#endif
    if(isReload)
        [self backToTableviewTop:3];
}

- (void)backToTableviewTop:(NSUInteger)index
{
    [super backToTableviewTop: index];
    if(index < [pageViewControllers count])
    {
        JHStonePinMoneySubViewController* controller = pageViewControllers[index];
        [controller refreshPage];
    }
}

#pragma mark - events
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    /**headerView及其子view都在负坐标，因此需要给button处理事件权限
     *  有效区,满足两个条件:1,转坐标系到self,找到header 2,再转坐标系到self,找到button
     */
    UIView *view = [super hitTest:point withEvent:event];
    if (!view)
    {
        for (UIView *subView in self.subviews)
        {
            CGPoint convertPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, convertPoint))
            {
                //找到headerView范围内point
                for (UIView* subSubView in subView.subviews)
                {
                    CGPoint cvtPoint = [subSubView convertPoint:point fromView:self];
                    if (CGRectContainsPoint(subSubView.bounds, cvtPoint))
                    {
                        view = subSubView;//找到withdrawButton范围内point
                        break;
                    }
                }
            }
        }
    }
    return view;
}

- (void)pressWithdrawButton
{
    if(mClickAction)
        mClickAction(withdrawableLabel.text); //可提现金额
}

@end
