//
//  JHUCSoldListModel.h
//  TTjianbao
//  Description:用户-个人中心-已售原石列表
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"
#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHUCSoldListModel;

@interface JHUCSoldPageModel : JHRespModel

@property (nonatomic, strong) NSArray<JHUCSoldListModel*>* list;// (Array[StoneRestoreListMySoldResponse], optional): 已售原石列表 ,
@property (nonatomic, strong) NSString* total;// (integer, optional): 总数 ,
@property (nonatomic, strong) NSString* totalPrice;// (number, optional): 回血总价
@end

@interface JHUCSoldListModel : JHGoodsRespModel

@property (nonatomic, strong) NSString* anchorIcon;// (string, optional): 主播头像 ,
@property (nonatomic, strong) NSString* channelTitle;// (string, optional): 直播间标题 ,
@property (nonatomic, strong) NSString* dealPrice;// (number, optional): 成交价 ,
@property (nonatomic, strong) NSString* salePrice;// (number, optional): 寄售价格  ,
@property (nonatomic, strong) NSString* dealTime ;//(string, optional): 成交时间 ,
@property (nonatomic, strong) NSString* stoneId;// (integer, optional): 原石回血ID
@property (nonatomic, strong) NSString* channelId;// (integer, optional): 直播间ID ,

@end

@interface JHUCSoldListReqModel : JHReqModel

@property (nonatomic, assign) NSUInteger pageIndex; //第几页
@property (nonatomic, assign) NSUInteger pageSize; //每页几条
@end

NS_ASSUME_NONNULL_END
