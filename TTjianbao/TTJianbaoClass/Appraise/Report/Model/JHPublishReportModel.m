//
//  JHPublishReportModel.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportModel.h"
#import "UserInfoRequestManager.h"

@implementation JHPublishReportModel

@end

@implementation JHReportCatePropertyModel

@end

@implementation JHReportRecommendLabelModel

@end

@implementation JHReportCateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

@end

@implementation JHReportTotalModel

- (instancetype)init {
    if(self = [super init]) {
        _type = 1;
        _publishParams = [JHPublishReportModel new];
        _publishParams.authenticity = 1;
        [self requestList];
    }
    return self;
}

- (void)requestList {
    
    dispatch_group_t  group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
        
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/recommend/label") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        self.recommendArray = [JHReportRecommendLabelModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        dispatch_group_leave(group);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        dispatch_group_leave(group);
    }];
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/noprice/reason") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        if(IS_ARRAY(respondObject.data)) {
            self.noPriceReasonArray = respondObject.data;
        }
        else {
        }
        dispatch_group_leave(group);
    } failureBlock:^(RequestModel *respondObject) {
        dispatch_group_leave(group);
    }];
    
    
    NSArray *array = [UserInfoRequestManager sharedInstance].pickerDataArray;
    if (IS_ARRAY(array)) {
        self.cateArray = [JHReportCateModel mj_objectArrayWithKeyValuesArray:array];
        dispatch_group_leave(group);
    }
    else {
        [[UserInfoRequestManager sharedInstance] getCateAllWithType:0 successBlock:^(RequestModel * _Nullable respondObject) {
            if(IS_ARRAY(respondObject.data)) {
                self.cateArray = [JHReportCateModel mj_objectArrayWithKeyValuesArray:respondObject.data];
            }
            
            dispatch_group_leave(group);
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if(_updateBlock) {
            _updateBlock();
        }
    });
}

- (void)submit {
    
    if(self.publishParams.isRecommend) {
        NSString *recommendLabel = nil;
        for (JHReportRecommendLabelModel *m in self.recommendArray) {
            if(m.selected) {
                recommendLabel = m.value;
            }
        }
        if(!recommendLabel) {
            JHTOAST(@"请选推荐的标签");
            return;
        }
        self.publishParams.recommendLabel = recommendLabel;
    }
    
    NSString *cateId = nil;
    for (JHReportCateModel *m in self.cateArray) {
        if(m.selected) {
            cateId = m.Id;
        }
    }
    if(!cateId) {
        JHTOAST(@"请选择类别");
        return;
    }
    self.publishParams.cateId = cateId;
    
    if(self.type == 1) {
        self.publishParams.authenticity = 1;
        if(!(IS_STRING(self.publishParams.manulReport) && self.publishParams.manulReport.length > 0)) {
            JHTOAST(@"请选择不估价的理由");
            return;
        }
    }
    else if(self.type == 2) {
        self.publishParams.authenticity = 1;
        if(cateId.integerValue == 24) {
            //其他
            if(!(IS_STRING(self.publishParams.manulReport) && self.publishParams.manulReport.length > 0)) {
                JHTOAST(@"请填写报告");
                return;
            }
        }
        else {
            if(!(IS_STRING(self.publishParams.price) && self.publishParams.price.length > 0)) {
                JHTOAST(@"请填写价格");
                return;
            }
            if(IS_ARRAY(self.subCateArray)) {
                NSMutableArray *array = [NSMutableArray new];
                for (JHReportCatePropertyModel *m in self.subCateArray) {
                    if(m.selectValue) {
                        NSMutableDictionary *property = [NSMutableDictionary new];
                        [property setValue:m.fieldCode forKey:@"fieldCode"];
                        [property setValue:m.selectValue forKey:@"fieldValue"];
                        [array addObject:property];
                    }
                    else {
                        JHTOAST(@"请填选择二级标签");
                        return;
                    }
                }
                if(array.count > 0) {
                    self.publishParams.properties = array.mj_JSONString;
                }
            }
            if(!self.publishParams.properties) {
                JHTOAST(@"请填选择二级标签");
                return;
            }
        }
        
    }
    else {
        self.publishParams.authenticity = 0;
    }
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/report/auth/genReport") Parameters:self.publishParams.mj_keyValues requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if(self.completeBlock) {
            self.completeBlock(respondObject.data,self.publishParams.appraiseRecordId);
        }
        if(self.removeBlock) {
            self.removeBlock();
        }
        JHTOAST(@"提交成功");
        
    } failureBlock:^(RequestModel *respondObject) {
        JHTOAST(@"提交失败");
    }];
}

- (NSString *)getCurrentReportCateId {
    for (JHReportCateModel *m in self.cateArray) {
        if(m.selected) {
            return m.Id;
        }
    }
    return @"24";
}

- (BOOL)selectedCate {
    BOOL selected = NO;
    for (JHReportCateModel *m in self.cateArray) {
        if(m.selected) {
            selected = YES;
            break;
        }
    }
    return selected;
}

- (BOOL)selectedOtherCate {
    BOOL selected = NO;
    for (JHReportCateModel *m in self.cateArray) {
        if(m.selected && (m.Id.integerValue == 24)) {
            selected = YES;
            break;
        }
    }
    return selected;
}

- (void)requestWithSubCateBlock:(dispatch_block_t)block {
    
    NSString *cateId = @"24";
    
    for (JHReportCateModel *m in self.cateArray) {
        if(m.selected) {
            cateId = m.Id;
            break;
        }
    }
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/cate/reportField") Parameters:@{@"cateId":cateId} successBlock:^(RequestModel *respondObject) {
        self.subCateArray = [JHReportCatePropertyModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if(block) {
            block();
        }
    } failureBlock:^(RequestModel *respondObject) {
        JHTOAST(respondObject.message);
    }];
}

- (NSMutableArray<JHReportCateModel *> *)cateArray {
    if(!_cateArray) {
        _cateArray = [NSMutableArray new];
    }
    return _cateArray;
}

- (NSMutableArray<JHReportCatePropertyModel *> *)subCateArray {
    if(!_subCateArray) {
        _subCateArray = [NSMutableArray new];
    }
    return _subCateArray;
}

- (NSMutableArray<JHReportRecommendLabelModel *> *)recommendArray {
    if(!_recommendArray) {
        _recommendArray = [NSMutableArray new];
    }
    return _recommendArray;
}

- (NSMutableArray *)noPriceReasonArray {
    if(!_noPriceReasonArray) {
        _noPriceReasonArray = [NSMutableArray new];
    }
    return _noPriceReasonArray;
}
@end
