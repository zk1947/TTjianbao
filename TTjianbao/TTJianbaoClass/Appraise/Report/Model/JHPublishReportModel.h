//
//  JHPublishReportModel.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportModel : NSObject


/// 鉴定报告记录
@property (nonatomic, copy) NSString *appraiseRecordId;

/// 1-鉴定为真     0-鉴定为假
@property (nonatomic, assign) NSInteger authenticity;

///分类ID
@property (nonatomic, copy) NSString *cateId;

/// 0-不推荐    1-推荐
@property (nonatomic, assign) NSInteger isRecommend;

///推荐标签
@property (nonatomic, copy) NSString *recommendLabel;

///报告属性
@property (nonatomic, copy, nullable) NSString *properties;

///估价
@property (nonatomic, copy, nullable) NSString *price;

/// 当选择其他分类时，手动填写的报告内容 or 不估价理由
@property (nonatomic, copy, nullable) NSString *manulReport;


@end


@interface JHReportCatePropertyModel : NSObject

@property (nonatomic, copy) NSString *fieldCode;

@property (nonatomic, copy) NSString *fieldName;

@property (nonatomic, copy) NSArray *fieldValues;

///是否被选中
@property (nonatomic, copy, nullable) NSString *selectValue;

@end

@interface JHReportCateModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *Id;

///是否被选中
@property (nonatomic, assign)BOOL selected;

@end

@interface JHReportRecommendLabelModel : NSObject

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *value;

///是否被选中
@property (nonatomic, assign)BOOL selected;

@end

@interface JHReportTotalModel : NSObject

@property (nonatomic, strong) JHPublishReportModel *publishParams;

/// 推荐列表
@property (nonatomic, strong) NSMutableArray <JHReportRecommendLabelModel *> *recommendArray;

@property (nonatomic, strong) NSMutableArray <JHReportCateModel *> *cateArray;

@property (nonatomic, strong) NSMutableArray <JHReportCatePropertyModel *> *subCateArray;


/// 不估价原因
@property (nonatomic, strong) NSMutableArray *noPriceReasonArray;

/// 1=真·不估价     2=真·估价  0=伪
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) dispatch_block_t updateBlock;

@property (nonatomic, copy) dispatch_block_t removeBlock;

///提交报告成功后
@property (nonatomic, copy) void (^completeBlock) (NSDictionary *data, NSString *appraiseRecordId);

/// 选择分类后获取标签
- (void)requestWithSubCateBlock:(dispatch_block_t)block;

/// 是否已经选择分类
- (BOOL)selectedCate;

/// 是否选择了其他
- (BOOL)selectedOtherCate;

///提交报告
- (void)submit;
@end

NS_ASSUME_NONNULL_END
