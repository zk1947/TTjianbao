//
//  JHResaleStoneReeditModel.h
//  TTjianbao
//  Description:原石回血二次编辑模型
//  Created by Jesse on 3/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"
#import "JHPutShelveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHResaleStoneReeditReqModel : JHReqModel
//stoneRestoreId:1207219224396082667
@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *stoneRestoreId;
@property (nonatomic, strong) NSMutableArray<JHMediaModel *> *urlList; // 附件列表

@end

///主播-原石回血-拉取数据展示详情（二次编辑）
@interface JHResaleStoneDetailReeditReqModel : JHReqModel

@property (nonatomic, copy) NSString *stoneRestoreId; //原石回血ID
@end

@interface JHResaleStoneReeditModel : JHRespModel

@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *stoneRestoreId;
@property (nonatomic, strong) NSMutableArray<JHMediaModel *> *urlList; // 附件列表

//上传二次编辑信息
- (void)requestReeditModel:(JHResaleStoneReeditReqModel*)model response:(JHResponse)response;
//根据原石id请求信息,展示编辑信息
- (void)requestReeditStoneId:(NSString*)stoneId response:(JHResponse)response;
@end

NS_ASSUME_NONNULL_END
