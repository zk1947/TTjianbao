//
//  JHEvaluateReportModel.h
//  TTjianbao
//  Description:评估报告提交和详情model
//  Created by jesee on 8/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"

@class JHEvaluateReportTagsModel, JHEvaluateReportSaveReqModel, JHEvaluateReportDetailReqModel;

@interface JHEvaluateReportModel : JHRespModel

@property (nonatomic, copy) NSString* helpful; //评估报告是否有帮助：0-没有、1-有
@property (nonatomic, copy) NSString* remark;// 想说的话 ,
@property (nonatomic, strong) NSArray<JHEvaluateReportTagsModel*>* tags;// (Array[CommentTagItemResponse], optional): 标签集合

//评价选项和详情请求:helpful来区分
- (void)requestEvaluateDetailAppraiseId:(NSString*)appraiseId helpful:(NSString*)helpful response:(JHActionBlocks)resp;

//提交评价请求
- (void)requestSaveEvaluateAppraiseId:(NSString*)appraiseId report:(JHEvaluateReportModel*)model response:(JHActionBlock)resp;
@end

//评价选项和详情:helpful来区分
@interface JHEvaluateReportDetailReqModel : JHReqModel

@property (nonatomic, copy) NSString* appraiseId;// 鉴定记录ID ,
@property (nonatomic, copy) NSString* helpful; //评估报告是否有帮助：0-没有、1-有
@end

//提交评价
@interface JHEvaluateReportSaveReqModel : JHEvaluateReportDetailReqModel

@property (nonatomic, copy) NSString* remark;// 其他想说的话 ,
@property (nonatomic, strong) NSArray* tagIds;// (Array[integer]): 评价标签ID集合
@end

@interface JHEvaluateReportTagsModel : NSObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString* tagId;// (integer, optional): ID ,
@property (nonatomic, copy) NSString* name;// (string, optional): 标签名称
@end
