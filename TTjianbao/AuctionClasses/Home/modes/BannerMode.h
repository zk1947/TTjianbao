//
//  BannerMode.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/14.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerMode : NSObject
@property (strong,nonatomic)NSString* picDes;
@property (strong,nonatomic)NSString * picId;
@property (strong,nonatomic)NSString* picLink;
@property (strong,nonatomic)NSString * picName;
@property (strong,nonatomic)NSString* picSort;
@property (strong,nonatomic)NSString* picUrl;
@end

@interface TargetModel : NSObject
@property (strong, nonatomic)NSString *componentName;
@property (strong, nonatomic)NSString *vc;//专题专区点击返回
@property (strong, nonatomic)NSMutableDictionary *params;
/// 埋点用-vc名称
@property (nonatomic, copy) NSString *recordComponentName;
@end

@interface BannerCustomerModel : NSObject
@property (strong, nonatomic) TargetModel *target;
@property (strong, nonatomic) NSString    *image;
@property (strong, nonatomic) NSString    *title;
@property (assign, nonatomic) CGFloat      wh_scale;
@property (strong, nonatomic) NSString    *item_id;
@property (strong, nonatomic) NSString    *item_type;
@property (strong, nonatomic) NSString    *layout;
@property (strong, nonatomic) NSString    *startup_text;
@end
