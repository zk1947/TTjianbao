//
//  JHPurchaseCutTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseCutTableViewCell.h"
#import "JHUIFactory.h"
#import "JHHorizontalScrollView.h"

#define kButtonTag 200

@interface JHPurchaseCutTableViewCell () <JHHorizontalScrollViewDelegate>
{
    UILabel* processTypeLabel;
    JHHorizontalScrollView* horizontalScrollView;
}
@end

@implementation JHPurchaseCutTableViewCell

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
    [self addSubviewsButton:pageType];
    [self drawSubviews];
}

- (UIButton *)addSubviewsButton:(JHStonePageType)pageType
{
    UIButton* btn = nil;
    if(pageType == JHStonePageTypePurchase)
    {
        btn = [super addSubviewsButton:pageType];
    }
    return btn;
}

- (void)drawSubviews
{
    JHCustomLine* line = [JHUIFactory createLine];
    [self.background addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.right.equalTo(self.background);
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    processTypeLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"加工方式："];
    [self.background addSubview:processTypeLabel];
    [processTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(12);
        make.top.mas_equalTo(line.mas_bottom).offset(6);
        make.height.mas_equalTo(17);
    }];
    
    horizontalScrollView = [[JHHorizontalScrollView alloc] initWithDelegate:self];
    [self.background addSubview:horizontalScrollView];
    [horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.top.mas_equalTo(processTypeLabel.mas_bottom).offset(8);
        make.width.equalTo(self.background).offset(-11*2);
        make.height.mas_equalTo(75);
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
    processTypeLabel.text = [self typeFromProcessMode:model.processMode];
    //根据类型判断显示video还是image，具体个数也动态添加！！！
    [horizontalScrollView updateSubviews:model.attachmentList];
    NSInteger count = [model.attachmentList count];
    if(count > 0)
        horizontalScrollView.contentSize = CGSizeMake(count * kHorizontalScrollViewButtonWidth + ( count - 1) * kHorizontalScrollViewButtonMargin, horizontalScrollView.height);
}

#pragma mark - 类型转换 //0-未定义，1-开窗、2-扒皮、3-切片、4-成品加工
- (NSString*)typeFromProcessMode:(NSString*)mode
{
    NSArray* typeArr = @[@"", @"开窗", @"扒皮", @"切片", @"成品加工"];
    int idx = [mode intValue];
    if(idx >= 0 && idx < [typeArr count])
        return typeArr[idx];
    return typeArr[0];
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
