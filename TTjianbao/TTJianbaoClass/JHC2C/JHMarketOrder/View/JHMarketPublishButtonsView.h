//
//  JHMarketPublishButtonsView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHMarketPublishModel.h"
#import "JHIssueGoodsEditModel.h"

typedef enum : NSUInteger {
    MarketPublishButtonTagSeeReport = 100,    //查看报告
    MarketPublishButtonTagOffSale,            //下架
    MarketPublishButtonTagAdjustPrice,        //调价
    MarketPublishButtonTagAppraise,           //鉴定
    MarketPublishButtonTagOnSale,             //上架
    MarketPublishButtonTagEdit,               //编辑
    MarketPublishButtonTagDelete,             //删除
} MarketPublishButtonTag;

NS_ASSUME_NONNULL_BEGIN

typedef void(^IssueEditBlock)(JHIssueGoodsEditModel *model);

@interface JHMarketPublishButtonsView : BaseView
@property (nonatomic, strong) JHMarketPublishModel *publishModel;
@property (nonatomic, strong) NSArray *dataSource;
/** 通知上层刷新数据*/
@property (nonatomic, copy) void(^reloadDataBlock)(BOOL iSdelete);

@property (nonatomic, copy) IssueEditBlock issueEditBlock;


@end

NS_ASSUME_NONNULL_END
