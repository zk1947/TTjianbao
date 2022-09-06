//
//  JHCustomerApiManager.h
//  TTjianbao
//
//  Created by user on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomerPublishModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface JHCustomerApiManager : NSObject
//
///*
// * 定制师代表作 - 详情
// */
//+ (void)getCustomizeOpusById:(NSInteger)ID
//          completeBlock:(HTTPCompleteBlock)block;
//
///*
// * 定制师代表作 - 审核
// */
//+ (void)updateOpusAudit:(NSString *)ID
//          completeBlock:(HTTPCompleteBlock)block;



///*
// * 定制师代表作 - 根据定制师ID查询代表作信息
// */
//+ (void)listOpusByCustomizeId:(NSString *)ID
//          completeBlock:(HTTPCompleteBlock)block;



/*
 * 定制师代表作 - 删除
 */
+ (void)deleteOpus:(NSInteger)ID
          completeBlock:(HTTPCompleteBlock)block;


/*
 * 定制师代表作 - 保存
 */
+ (void)saveCustomizeOpus:(JHCustomerEditOpusPublishModel *)model
          completeBlock:(HTTPCompleteBlock)block;



/*
 * 定制师证书 - 保存证书信息
 */
+ (void)saveCertificate:(JHCustomerEditCerPublishModel *)model
          completeBlock:(HTTPCompleteBlock)block;


///*
// * 定制师证书 - 根据id 查询证书详情
// */
//+ (void)getCertificateById:(NSInteger)ID
//             completeBlock:(HTTPCompleteBlock)block;


/*
 * 定制师证书 - 根据id 删除该证书
 */
+ (void)deleteCertificateById:(NSInteger)ID
             completeBlock:(HTTPCompleteBlock)block;



@end


NS_ASSUME_NONNULL_END
