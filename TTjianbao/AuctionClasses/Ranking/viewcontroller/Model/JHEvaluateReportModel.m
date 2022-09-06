//
//  JHEvaluateReportModel.m
//  TTjianbao
//
//  Created by jesee on 8/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEvaluateReportModel.h"
#import "JHGrowingIO.h"

@implementation JHEvaluateReportModel

//评价选项和详情请求:helpful来区分 
- (void)requestEvaluateDetailAppraiseId:(NSString*)appraiseId helpful:(NSString*)helpful response:(JHActionBlocks)resp
{
    JHEvaluateReportDetailReqModel* model = [JHEvaluateReportDetailReqModel new];
    model.appraiseId = appraiseId;
    model.helpful = helpful;
    [JH_REQUEST asynPost:model success:^(JHRespModel* respData) {
        JHEvaluateReportModel* data = [JHEvaluateReportModel convertData:respData];
        data.helpful = helpful;
        resp(data, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

//提交评价请求
- (void)requestSaveEvaluateAppraiseId:(NSString*)appraiseId report:(JHEvaluateReportModel*)model response:(JHActionBlock)resp
{
    JHEvaluateReportSaveReqModel* reqModel = [JHEvaluateReportSaveReqModel new];
    reqModel.appraiseId = appraiseId;
    reqModel.helpful = model.helpful;
    reqModel.remark = model.remark;
    NSMutableArray* arr = [NSMutableArray array];
    NSString* nameStr = @"";
    for (JHEvaluateReportTagsModel* tag in model.tags)
    {
        if(tag.selected)
        {
            [arr addObject:tag.tagId];
            nameStr = [NSString stringWithFormat:@"%@,%@", nameStr, tag.name ? : @""];
        }
    }
    [JHGrowingIO trackPublicEventId:JHClickOrderEvaluateListProblemClick paramDict:@{@"title": nameStr, @"submit":@"true"}];
    reqModel.tagIds = [NSArray arrayWithArray:arr];
    [JH_REQUEST asynPost:reqModel success:^(JHRespModel* respData) {
        resp([JHRespModel nullMessage]);
        
    } failure:^(NSString *errorMsg) {
        resp(errorMsg);
    }];
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"tags" : [JHEvaluateReportTagsModel class]};
}
@end

@implementation JHEvaluateReportTagsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tagId":@"id"};
}

@end

@implementation JHEvaluateReportSaveReqModel
///appraise-report-comment/auth/save
//鉴定报告评价保存
- (NSString *)uriPath
{
    return @"/appraise-report-comment/auth/save";
}
@end

@implementation JHEvaluateReportDetailReqModel

///appraise-report-comment/auth/find-detail
//鉴定报告评价详情
- (NSString *)uriPath
{
    return @"/appraise-report-comment/auth/find-detail";
}
@end
