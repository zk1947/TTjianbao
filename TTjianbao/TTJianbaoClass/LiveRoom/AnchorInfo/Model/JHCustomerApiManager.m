//
//  JHCustomerApiManager.m
//  TTjianbao
//
//  Created by user on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerApiManager.h"
#import "YYKit/YYKit.h"
#import "JHMasterPiectDetailModel.h"

@implementation JHCustomerApiManager

///*
// * 定制师代表作 - 详情
// */
//+ (void)getCustomizeOpusById:(NSInteger)ID
//               completeBlock:(HTTPCompleteBlock)block {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:@(ID) forKey:@"id"];
//    NSString *url= FILE_BASE_STRING(@"/admin/appraisal/customizeOpus/getCustomizeOpusById");
//    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
//        if (!respondObject.data && block) {
//            block(respondObject,YES);
//            return;
//        }
//        JHMasterPiectDetailModel *model = [JHMasterPiectDetailModel mj_objectWithKeyValues:respondObject.data];
//        if (block) {
//            block(model, NO);
//        }
//    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        if (block) {
//            block(respondObject, YES);
//        }
//    }];
//}

///*
// * 定制师代表作 - 审核
// */
//+ (void)updateOpusAudit:(NSString *)ID
//          completeBlock:(HTTPCompleteBlock)block {
//
//}


///*
// * 定制师代表作 - 根据定制师ID查询代表作信息
// */
//+ (void)listOpusByCustomizeId:(NSString *)ID
//                completeBlock:(HTTPCompleteBlock)block {
//
//}




/*
 * 定制师代表作 - 删除
 */
+ (void)deleteOpus:(NSInteger)ID
     completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(ID) forKey:@"id"];
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeOpus/delete");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}


/*
 * 定制师代表作 - 保存
 */
+ (void)saveCustomizeOpus:(JHCustomerEditOpusPublishModel *)model
          completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeOpus/saveCustomizeOpus");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(model, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}



/*
 * 定制师证书 - 保存证书信息
 */
+ (void)saveCertificate:(JHCustomerEditCerPublishModel *)model
          completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    NSString *url = FILE_BASE_STRING(@"/app/appraisal/customizeCertificate/saveCertificate");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(model, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///*
// * 定制师证书 - 根据id 查询证书详情
// */
//+ (void)getCertificateById:(NSInteger)ID
//             completeBlock:(HTTPCompleteBlock)block {
//    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/anon/appraisal/customizeCertificate/detail?id=%ld"), ID];
//    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
//        if (block) {
//            block(respondObject, NO);
//        }
//    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        if (block) {
//            block(respondObject, YES);
//        }
//    }];
//}

/*
 * 定制师证书 - 根据id 删除该证书
 */
+ (void)deleteCertificateById:(NSInteger)ID
                completeBlock:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(ID) forKey:@"id"];
    NSString *url= FILE_BASE_STRING(@"/app/appraisal/customizeCertificate/delete");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];

}






@end
