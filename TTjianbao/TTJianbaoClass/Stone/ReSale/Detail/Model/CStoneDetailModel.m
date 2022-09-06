//
//  CStoneDetailModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "CStoneDetailModel.h"

@implementation CStoneDetailModel


//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"oriPrice" : @"initPrice"};
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attachmentList" : [CAttachmentListData class],
             @"offerRecordList" : [COfferRecordListData class],
             @"stoneChangeList" : [CStoneChangeListData class],
             @"stoneTree" : [CStoneTreeData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _attachmentList = [NSMutableArray new];
        _offerRecordList = [NSMutableArray new];
        _seekCustomerImgList = [NSMutableArray new];
        _stoneChangeList = [NSMutableArray new];
        _stoneTree = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    return FILE_BASE_STRING(@"/anon/stone-restore/find-details");
}

- (NSDictionary *)toParamWithStoneId:(NSInteger)stoneId {
    return @{@"stoneId" : @(stoneId).stringValue};
}

@end


#pragma mark - attachmentList <附件：图片、视频>
@implementation CAttachmentListData

@end


#pragma mark - offerRecordList <出价记录列表>
@implementation COfferRecordListData

@end


#pragma mark - stoneChangeList <原石换手记录>
@implementation CStoneChangeListData

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attachmentList" : [CAttachmentListData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _attachmentList = [NSMutableArray new];
    }
    return self;
}

@end


#pragma mark - stoneTree <原石族谱树>
@implementation CStoneTreeData

@end
