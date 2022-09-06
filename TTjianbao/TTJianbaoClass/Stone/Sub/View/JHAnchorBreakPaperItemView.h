//
//  JHAnchorBreakPaperItemView.h
//  TTjianbao
//  Description:购入价格
//  Created by yaoyao on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHUIFactory.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAnchorBreakPaperItemView : BaseView
@property (nonatomic, strong) JHTitleTextItemView *breakStyle;
@property (nonatomic, strong) JHTitleTextItemView *breakPrice;
@property (nonatomic, strong) JHPreTitleLabel *title;
@property (nonatomic, copy) JHActionBlock seletedBlock;
@property (nonatomic, strong) NSArray *splitModeArray;
- (void)makeUIOrderCount;
- (void)makeUI;
- (void)makeUIPrice;
@end

NS_ASSUME_NONNULL_END
