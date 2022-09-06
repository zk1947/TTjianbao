//
//  JHNewStoreTypePageViewModel.h
//  TTjianbao
//
//  Created by zk on 2021/10/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreTypePageViewModel : NSObject

@property (nonatomic, strong) NSArray *recommendWordList;   /** 推荐关键词 */

@property (nonatomic, strong) NSArray *leftCategoryList;    /** 左侧分类列表 */

@property (nonatomic, strong) NSArray *rightCategoryList;   /** 右侧分类列表 */

@end

///组model
@interface JHNewStoreTypeRightSectionModel : NSObject

@property (nonatomic, assign) NSInteger firstCateId;//一级分类id

@property (nonatomic, copy) NSString *firstCateName;//一级分类名称

@property (nonatomic, strong) NSArray *operationList;    /** 运营位列表 */

@property (nonatomic, strong) NSArray *liveList;        /** 分类搜索直播间列表 */

@property (nonatomic, strong) NSArray *secondCateList;   /** 二级分类列表 */

@property (nonatomic, assign) CGFloat sectionHeight;//组头高度

- (CGFloat)liveHeight;

@end

///轮播model
@interface JHNewStoreTypeRightScrollModel : NSObject

@property (nonatomic, copy) NSString *landingTarget;//落地页目标

@property (nonatomic, copy) NSString *targetName;//落地页类型名称

@property (nonatomic, copy) NSString *detailsId;//运营位栏位id

@property (nonatomic, copy) NSString *imageUrl;//图片素材地址

@property (nonatomic, copy) NSString *landingId;//落地页关联参数

@end


///轮播落地页
@interface JHNewStoreTypeRightScrollTargetModel : NSObject

@property (nonatomic, assign) int componentType;

@property (nonatomic, copy) NSString *vc;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *componentName;

@end


///直播model
@interface JHNewStoreTypeRightLiveModel : NSObject

@property (nonatomic, copy) NSString *anchorIcon;//ICON

@property (nonatomic, assign) NSInteger anchorId;//主播ID
    
@property (nonatomic, copy) NSString *anchorName;// 直播间名称

@property (nonatomic, assign) NSInteger channelLocalId;//频道本地ID

@property (nonatomic, copy) NSString *coverImg;//封面

@property (nonatomic, copy) NSString *smallCoverImg;//封面小图
        
@property (nonatomic, copy) NSString *status;//频道状态 0：禁用； 1：空闲； 2：直播中； 3：直播录制

@property (nonatomic, copy) NSString *title;//标题

@property (nonatomic, assign) NSInteger watchTotal;//热度--观看量
        
@end

NS_ASSUME_NONNULL_END
