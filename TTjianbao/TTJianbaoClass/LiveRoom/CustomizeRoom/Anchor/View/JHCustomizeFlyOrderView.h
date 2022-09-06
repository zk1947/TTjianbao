//
//  JHCustomizeFlyOrderView.h
//  TTjianbao
//
//  Created by lihang on 2020/11/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPopBaseView.h"
#import "JHSendOrderModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JHCustomizeType){
    JHCustomizedNormalOrder , //常规单飞定制单
    JHCustomizedIntentionOrder,//意向单飞定制单
    JHCustomizedAndNormalOrder,//定制套餐（常规+定制）
    JHCustomizedOrder,//其他
};

typedef void (^LastBtnClickAction)(void);

@interface JHCustomizeFlyOrderView : JHPopBaseView
@property (nonatomic, copy) void(^snapShotCallBack)(JHCustomizeFlyOrderView*  selfView);

@property (nonatomic, assign) JHCustomizeType     customizeType;//定制单or意向单
@property (nonatomic,   copy) NSString           *parentOrderId;
@property (nonatomic,   copy) NSString           *anchorId;
@property (nonatomic,   copy) NSString           *orderCategory;//订单类型
@property (nonatomic,   copy) NSString           *viewerId;
@property (nonatomic, strong) NSArray            *countCategaryArray;//保存定制个数类别总数据
@property (nonatomic,   copy) NSString           *imageUrl;//原本的图片,以","隔开
@property (nonatomic, strong) NSDictionary       *selectedCate;//name和id
@property (nonatomic,   copy) NSString           *customizeFeeId;//原本的图片,以","隔开
@property (nonatomic, assign) BOOL               isConnecting;//是否正在连麦
@property (nonatomic, strong) UIImage *__nullable screenImage;
@property (nonatomic,   copy) LastBtnClickAction lastAction;
@property (nonatomic, strong) JHSendOrderModel   *customizePackageModel;/// 新增套餐飞单相关

- (void)reloadScreenImageBGView;

/// 定制套餐飞单，第二步传递的图片信息
- (void)setImgInfo:(NSString *)ImgInfoString;
/// 定制套餐飞单，第二步传递的类别信息
- (void)setCagetoryInfoTextField:(NSDictionary *)cagetoryInfo;

@end

NS_ASSUME_NONNULL_END
