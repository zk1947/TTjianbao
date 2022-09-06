//
//  JHImageAppraisalFinishedViewController.h
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JXCategoryView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHAppraisalReportType) {
    JHAppraisalReportTypeFinished = 1,
    JHAppraisalReportTypeDoubt, //存疑
    JHAppraisalReportTypeCancel,  //取消
};

@interface JHImageAppraisalFinishedViewController : JHBaseViewExtController<JXCategoryListContentViewDelegate>
- (instancetype)initWithReportType:(JHAppraisalReportType)reportType;
@property (nonatomic, copy) void (^refreshNum)(NSInteger count);
-(void)reloadRecordData;
@end

NS_ASSUME_NONNULL_END
