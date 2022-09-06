//
//  JHStoreHelp.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHelp.h"
#import "TTjianbao.h"
#import "JHStoreHomeListCell.h"
#import "JHStoreHomeRcmdCell.h"
#import "JHGuaranteeTableViewCell.h"
#import "JHStoreHomeSeckillCell.h"
#import "JHStoreHomeWindowCell.h"
#import "JHStoreHomeActivityTableCell.h"
#import "JHStoreHomeNewPeopleGiftTableViewCell.h"

@implementation JHStoreHelp

+ (JXPageListView *)pageListWithDelegate:(id)delegate {
    JXPageListView *page = [[JXPageListView alloc] initWithDelegate:delegate];
    page.listViewScrollStateSaveEnabled = NO;
    page.pinCategoryViewVerticalOffset = 0;
    page.pinCategoryViewHeight = JXPageHeightForHeaderInSection;
    
    //添加分割线
    /**
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, JXPageHeightForHeaderInSection - 1, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [page.pinCategoryView addSubview:lineView];
     */
    
    //Tips:成为mainTableView dataSource和delegate的代理，像普通UITableView一样使用它
    page.mainTableView.backgroundColor = [UIColor clearColor];
    page.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone; //默认无分割线
    page.mainTableView.delegate = delegate;
    page.mainTableView.dataSource = delegate;
    page.mainTableView.gestureDelegate = delegate;
    //page.mainTableView.scrollsToTop = NO;
    
    [page.mainTableView registerClass:[JHStoreHomeListCell class] forCellReuseIdentifier:kCellId_JHStoreHomeListCell];
    
    [page.mainTableView registerClass:[JHStoreHomeRcmdCell class] forCellReuseIdentifier:kCellId_JHStoreHomeRcmdCell];
    ///保障栏位置
    [page.mainTableView registerClass:[JHGuaranteeTableViewCell class] forCellReuseIdentifier:kCellId_JHStoreHomeGuaranteeId];
    
    [page.mainTableView registerClass:[JHStoreHomeSeckillCell class] forCellReuseIdentifier:kCellId_JHStoreHomeTableSeckillId];

    [page.mainTableView registerClass:[JHStoreHomeWindowCell class] forCellReuseIdentifier:kCellId_JHStoreHomeWindowTableId];
    
    [page.mainTableView registerClass:[JHStoreHomeActivityTableCell class] forCellReuseIdentifier:kCellId_JHStoreHomeActivityTableId];
    
    /// 新人专区
    [page.mainTableView registerClass:[JHStoreHomeNewPeopleGiftTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHStoreHomeNewPeopleGiftTableViewCell class])];

    return page;
}

///专题列表页的categoryView
+ (JXCategoryTitleView *)titleCategoryViewWithDelegate:(id)delegate {
    JXCategoryTitleView *_categoryView = [[JXCategoryTitleView alloc] init];
    //_categoryView.backgroundColor = [UIColor clearColor];
    _categoryView.delegate = delegate;
    _categoryView.titleColor = kColor333;
    _categoryView.titleSelectedColor = kColor333;
    _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
    _categoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
    _categoryView.titleColorGradientEnabled = YES; //字体颜色渐变过渡
    //是否按屏幕宽度每个居中显示每个cell
    _categoryView.averageCellSpacingEnabled = NO;
    //点击cell进行contentScrollView切换时是否需要动画。默认为YES
    _categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    
    _categoryView.cellSpacing = 30;
    _categoryView.contentEdgeInsetLeft = 24;
    _categoryView.contentEdgeInsetRight = 24;
    _categoryView.cellWidth = JXCategoryViewAutomaticDimension; //cell宽度，默认等于文本宽度
    _categoryView.collectionView.alwaysBounceHorizontal = YES; //始终可以划动
    return _categoryView;
}

///hot标签
+ (UIView *)hotImageView {
    ///icon_shop_hot
    YYAnimatedImageView *imgView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"mall_home_dayday.webp"]];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    
    ///添加动画
//    CABasicAnimation *anima = [CABasicAnimation animation];
//    anima.keyPath = @"transform.scale";
//    anima.repeatCount = MAXFLOAT;
//    anima.duration = 0.6f;
//    anima.autoreverses = YES;
//    anima.removedOnCompletion = NO;
//    anima.fromValue = [NSNumber numberWithFloat:0.8]; // 开始时的倍率
//    anima.toValue = [NSNumber numberWithFloat:1.2]; // 结束时的倍率
//    [imgView.layer addAnimation:anima forKey:nil];
    
    return imgView;
}

+ (void)setPrice:(NSString *)price forLabel:(UILabel *)label {
    
    if ([price isNotBlank]) {
        NSString *prefixString = [price substringToIndex:1];
        if ([prefixString isEqualToString:@"¥"]) {
            price = [price substringFromIndex:1];
        }
        NSString *string = [@"¥ " stringByAppendingString:price];
        NSRange range = [string rangeOfString:@"¥"];
        label.attributedText = [string attributedFont:[UIFont fontWithName:kFontBoldDIN size:12.f]
        color:UIColorHex(FC4200) range:range];
        
    } else {
        label.text = @"";
    }
}

///为Label设置价格“¥”
+ (void)setPrice:(NSString *)price prefixFont:(UIFont *)font prefixColor:(UIColor *)color forLabel:(UILabel *)label {
        if ([price isNotBlank]) {
            NSString *prefixString = [price substringToIndex:1];
            if ([prefixString isEqualToString:@"¥"]) {
                price = [price substringFromIndex:1];
            }
            NSString *string = [@"¥ " stringByAppendingString:price];
            NSRange range = [string rangeOfString:@"¥"];
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
            [attrString addAttribute:NSFontAttributeName value:font range:range];
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
            
            label.attributedText = attrString;
            
        } else {
            label.text = @"";
        }
}

+ (void)setNewPrice:(NSString *)price forLabel:(UILabel *)label Color:(UIColor *)color {
    if ([price isNotBlank]) {
        NSString *prefixString = [price substringToIndex:1];
        if ([prefixString isEqualToString:@"¥"]) {
            price = [price substringFromIndex:1];
        }
        NSString *string = [@"¥" stringByAppendingString:price];
        NSRange range = [string rangeOfString:@"¥"];
        label.attributedText = [string attributedFont:[UIFont fontWithName:kFontBoldDIN size:12.f]
        color:color range:range];
    } else {
        label.text = @"";
    }
}

@end
