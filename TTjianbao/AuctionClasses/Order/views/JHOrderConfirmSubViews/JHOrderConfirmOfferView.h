//
//  JHOrderConfirmOfferView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
#import "JHStoneOfferModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmOfferView : JHOrderSubBaseView
-(void)initOfferSubViews:(NSArray*)titles;
-(NSMutableArray *)handleOfferData:(JHStoneIntentionInfoModel*)mode andConfirmDetailMode:(JHOrderDetailMode*)detailMode;
//定制单
-(NSMutableArray *)handleCustomizeOfferData:(JHOrderDetailMode*)detailMode;

@end

NS_ASSUME_NONNULL_END
