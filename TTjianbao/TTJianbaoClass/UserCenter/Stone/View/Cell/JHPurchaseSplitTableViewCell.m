//
//  JHPurchaseSplitTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseSplitTableViewCell.h"
#import "JHUIFactory.h"
#import "JHHorizontalScrollView.h"

#define kPurchaseSplitTag 190
#define kPurchaseSplitCount 2 //默认拆2单
#define kHorizontalScrollHeight 75

@interface JHPurchaseSplitView : UIView <JHHorizontalScrollViewDelegate>
{
    UILabel* mTypeLabel;
    UILabel* mOrderLabel;
    UILabel* mStatusLabel;
    UILabel* mPriceLabel;
    JHHorizontalScrollView* horizontalScrollView;
}
@end

@implementation JHPurchaseSplitView

- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        [self drawSubviews];
    }
    
    return self;
}

- (void)drawSubviews
{
    mTypeLabel = [JHUIFactory createLabelWithTitle:@"寄回" titleColor:HEXCOLOR(0xFC4200) font:JHFont(10) textAlignment:NSTextAlignmentCenter];
    mTypeLabel.layer.cornerRadius = 2;
    mTypeLabel.layer.masksToBounds = YES;
    mTypeLabel.layer.borderColor = HEXCOLOR(0xFC4200).CGColor;
    mTypeLabel.layer.borderWidth = 0.5;
    [self addSubview:mTypeLabel];
    [mTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(11);
        make.size.mas_equalTo(CGSizeMake(38, 16));
    }];
    //订单号：49999933434299
    mOrderLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"订单号："];
    [self addSubview:mOrderLabel];
    [mOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(mTypeLabel.mas_right).offset(6);
        make.top.equalTo(self).offset(11);
        make.height.mas_equalTo(15);
    }];

    mStatusLabel = [JHUIFactory createLabelWithTitle:@"待商家发货" titleColor:HEXCOLOR(0x333333) font:JHFont(11) textAlignment:NSTextAlignmentRight];
    [self addSubview:mStatusLabel];
    [mStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(mOrderLabel);
    }];
    
    horizontalScrollView = [[JHHorizontalScrollView alloc] initWithDelegate:self];
    [self addSubview:horizontalScrollView];
    [horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mOrderLabel.mas_bottom).offset(11);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(kHorizontalScrollHeight);
    }];
    
    mPriceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self addSubview:mPriceLabel];
    [mPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(horizontalScrollView.mas_bottom).offset(6);
        make.left.mas_equalTo(self).offset(1);
        make.bottom.equalTo(self).offset(-5);
    }];
}

- (void)updateCell:(JHPurchaseStoneListModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    mTypeLabel.text = [JHPurchaseStoneModel typeFromSplitState:model.splitMode];
    mOrderLabel.text = model.orderCode ? : @"";
    mStatusLabel.text = [JHPurchaseStoneModel typeFromOrderStatus:model.orderStatus] ? : model.workorderDesc;
    mPriceLabel.text = model.salePrice ? : @"0.0";

    CGFloat height = kPurchaseTableSplitOneCellHeight; //包含了image高度
    NSInteger count = [model.attachmentList count];
    if(count > 0)
    {
        [horizontalScrollView updateSubviews:model.attachmentList];
        horizontalScrollView.contentSize = CGSizeMake(count * kHorizontalScrollViewButtonWidth + (count - 1) * kHorizontalScrollViewButtonMargin, kHorizontalScrollHeight);
        [horizontalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHorizontalScrollHeight);
        }];
        [mPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(horizontalScrollView.mas_bottom).offset(6);
          }];
    }
    else
    {
        height -= kPurchaseTableSplitOneCellImageHeight; //如果没有image,减去image高度
        [horizontalScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [mPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(horizontalScrollView.mas_bottom).offset(0);
        }];
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - event
- (void)pressScrollViewButton:(UIButton*_Nullable)button
{
    
}

@end

@interface JHPurchaseSplitTableViewCell ()
{
    UILabel* mSplitLabel;
    JHPurchaseSplitView* purchaseSplitViewZero;//第一个拆单
    JHCustomLine* seperateLine;//第一个拆单与第二个的分割线
    JHPurchaseSplitView* purchaseSplitView;//第二个拆单
    NSMutableArray* purchaseSplitViewArr;
}
@end

@implementation JHPurchaseSplitTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        [self drawSubviews];//外面调用
    }
    
    return self;
}

- (void)setupSubviews:(JHStonePageType)pageType
{
    [super setupSubviews:pageType];
    [self drawSubviews];
    [self addSubviewsButton:pageType];
}

- (UIButton *)addSubviewsButton:(JHStonePageType)pageType
{
    UIButton* btn = nil;
    if(pageType == JHStonePageTypePurchase)
    {
        btn = [super addSubviewsButton:pageType]; //重新布局约束
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.background).offset(-10);
            make.bottom.equalTo(purchaseSplitViewZero).offset(-10);
            make.size.mas_equalTo(CGSizeMake(71, 30));
        }];
    }
    return btn;
}

- (void)drawSubviews
{
    JHCustomLine* line = [JHUIFactory createLine];
    [self.background addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background);
        make.right.equalTo(self.background);
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    mSplitLabel = [JHUIFactory createJHLabelWithTitle:@"0单）" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"已拆订单明细（"];
    [self.background addSubview:mSplitLabel];
    [mSplitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.top.mas_equalTo(line.mas_bottom).offset(8);
        make.height.mas_equalTo(17);
    }];
    //第一个拆单:多一行~~已拆订单明细（2单）
    purchaseSplitViewZero = [[JHPurchaseSplitView alloc] init];
    [self.background addSubview:purchaseSplitViewZero];
    [purchaseSplitViewZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mSplitLabel.mas_bottom);
        make.left.equalTo(self.background).offset(11);
        make.right.equalTo(self.background).offset(-11);
        make.height.mas_equalTo(kPurchaseTableSplitOneCellHeight);
    }];
    //拆单间分割线
    seperateLine = [JHUIFactory createLine];
    [self.background addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.right.equalTo(self.background);
        make.top.mas_equalTo(purchaseSplitViewZero.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    //第二个拆单
    purchaseSplitView = [[JHPurchaseSplitView alloc] init];
    [self.background addSubview:purchaseSplitView];
    [purchaseSplitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(seperateLine.mas_bottom);
        make.left.equalTo(self.background).offset(11);
        make.right.equalTo(self.background).offset(-11);
        make.height.mas_equalTo(kPurchaseTableSplitOneCellHeight);
    }];
}

- (void)updateCell:(JHPurchaseStoneListModel*)model pageType:(JHStonePageType)pageType
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    [self setCellData:model pageType:pageType];

    //根据拆单个数添加额外的view
    NSInteger count = [model.children count];
    mSplitLabel.text = [NSString stringWithFormat:@"%ld单）", count];
    if(count > 0)
    {
        [purchaseSplitViewZero updateCell:model.children[0]];
        [purchaseSplitViewZero setHidden:NO];
        
        if(count > 1)
        {
            [purchaseSplitView updateCell:model.children[1]];
            [purchaseSplitView setHidden:NO];
            
            [seperateLine setHidden:NO];
            [seperateLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(1);
            }];
            
            if(count > 2)
                [self showAdditionalViews:model];
        }
        else
        {
            [purchaseSplitView setHidden:YES];
            [seperateLine setHidden:YES];
            [purchaseSplitView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            [seperateLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
    }
    else
    {
        [purchaseSplitViewZero setHidden:YES];
        [purchaseSplitView setHidden:YES];
        [seperateLine setHidden:YES];
        [purchaseSplitViewZero mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [purchaseSplitView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [seperateLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)showAdditionalViews:(JHPurchaseStoneListModel*)model
{
    [self clearAdditionalSplitView];

    JHPurchaseSplitView* lastView = purchaseSplitView;
    JHPurchaseSplitView* additionalSplitView;
    //从第三个开始累加
    for (int i = 2; i < [model.children count]; i++)
    {
        JHCustomLine* line = [JHUIFactory createLine];
        [self.background addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.background).offset(11);
            make.right.equalTo(self.background);
            make.top.mas_equalTo(lastView.mas_bottom);
            make.height.mas_equalTo(1);
        }];

        additionalSplitView = [[JHPurchaseSplitView alloc] init];
        additionalSplitView.tag = kPurchaseSplitTag+i;
        [self.background addSubview:additionalSplitView];
        
        CGFloat height = kPurchaseTableSplitOneCellHeight; //包含了image高度
        JHPurchaseStoneListModel* childrenModel = model.children[i];
        if([childrenModel.attachmentList count] <= 0)
            height -= kPurchaseTableSplitOneCellImageHeight; //如果没有image,减去image高度
        
        [additionalSplitView updateCell:childrenModel];
        [additionalSplitView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.left.equalTo(self.background).offset(11);
            make.right.equalTo(self.background).offset(-11);
            make.height.mas_equalTo(height);
        }];
        
        //记录最新添加view
        lastView = additionalSplitView;
    }
}

- (void)clearAdditionalSplitView
{
    for (UIView* view in self.background.subviews)
    {
        if(view.tag >= kPurchaseSplitTag)
        {
            DDLogInfo(@"clearAdditionalSplitView~~~");
            [view removeFromSuperview];
        }
    }
}

#pragma mark - event
- (void)pressButton:(UIButton*)btn
{
    if([self.delegate respondsToSelector:@selector(pressButtonType:tableViewCell:)])
    {
        [self.delegate pressButtonType:RequestTypeStoneResell tableViewCell:self];
    }
}

- (void)pressScrollViewButton:(UIButton*_Nullable)button
{
    
}

@end
