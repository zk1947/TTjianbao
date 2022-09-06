//
//  JHStonePinMoneyView.h
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"
#import "JHAccountInfoModel.h"

#ifdef JH_UNION_PAY
#define kHeaderViewHeight (438. / 750. * ScreenW + 35.)
#else
#define kHeaderViewHeight (190.0+UI.statusBarHeight) //UI的坐标不准
#endif

NS_ASSUME_NONNULL_BEGIN

@interface JHStonePinMoneyView : JHSegmentPageView

- (void)drawSubviews:(JHActionBlock)clickAction;
- (void)refreshHeaderView:(JHAccountInfoModel*)model reloadTable:(BOOL)isReload;
@end

NS_ASSUME_NONNULL_END
