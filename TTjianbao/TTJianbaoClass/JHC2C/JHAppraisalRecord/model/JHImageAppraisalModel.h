//
//  JHImageAppraisalModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHBaseImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHImageAppraisalRecordInfoModel : NSObject

@property(nonatomic, copy) NSString * appraisalFeeYuan;
@property(nonatomic, copy) NSString * appraisalPayTime;
@property(nonatomic, assign) NSInteger  appraisalResult;//鉴定结果 0 真 1 仿品 2 存疑 3 现代工艺品
@property(nonatomic, copy) NSString * doubtOtherDesc;//存疑其他描述
@property(nonatomic, assign) NSInteger  doubtStatus; //存疑原因 1 品类不符 2 图片不清晰 3 数量不符 4 其他
@property(nonatomic, copy) NSString *  doubtStatusName;//存疑原因
@property(nonatomic, copy) NSString * img;//用户头像
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * orderCode    ;
@property(nonatomic, copy) NSString * productDesc;
@property(nonatomic, assign) NSInteger  recordInfoId; //图文信息鉴定id
@property(nonatomic, assign) NSInteger  taskId; //鉴定记录id
@property(nonatomic, strong) NSMutableArray * images;
@property (nonatomic, assign) CGFloat cellHeight;
@end



@interface JHImageAppraisalModel : NSObject
@property(nonatomic, assign) BOOL hasMore;
@property(nonatomic, assign) NSInteger pageNo;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) NSInteger pages;//总页数
@property(nonatomic, assign) NSInteger total;//总条数
@property(nonatomic, strong) NSMutableArray * resultList;

@end

NS_ASSUME_NONNULL_END
