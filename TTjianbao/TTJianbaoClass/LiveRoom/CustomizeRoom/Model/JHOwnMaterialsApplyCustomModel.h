//
//  JHOwnMaterialsApplyCustomModel.h
//  TTjianbao
//
//  Created by apple on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 id (integer, optional): id ,
 图片信息 {
 coverUrl (string, optional): 封面图片 ,
 type (integer, optional): 类型 0图片 1视频 ,
 url (string, optional): 资源地址
 }
 */
@interface  JHOwnMaterialsImageInfo: NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *url;
@end

@interface JHOwnMaterialsApplyCustomModel : NSObject
@property (nonatomic, copy) NSString *customizeFeeId;//定制分类id ,
@property (nonatomic, copy) NSString *customizeFeeName;//定制分类名字 ,
@property (nonatomic, copy) NSString *customizeOrderId;//订单id ,
@property (nonatomic, copy) NSString *goodsCateId;//分类id
@property (nonatomic, copy) NSString *goodsCateName;//分类名字 ,
@property (nonatomic, copy) NSString *materialDesc; //原料信息
@property (nonatomic, copy) NSMutableArray <JHOwnMaterialsImageInfo *> *materialList;//原料影像
@property (nonatomic, copy) NSString *materialName;//原料名称
@property (nonatomic, copy) NSString *materialSource;//原料来源：0 平台原料 1 自有原料 ,
@property (nonatomic, copy) NSString *sourceOrderId; //来源订单id
@end

NS_ASSUME_NONNULL_END
