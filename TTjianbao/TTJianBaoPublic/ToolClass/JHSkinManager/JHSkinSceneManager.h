//
//  JHSkinSceneManager.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/10/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSkinSceneModel.h"
#import "UIImage+WebP.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSkinSceneManager : NSObject
/// 直播购物标题
@property (nonatomic, strong) JHSkinSceneModel *sceneTitleModel;
/// 导航栏
@property (nonatomic, strong) JHSkinSceneModel *sceneNaviModel;
/// 消息按钮
@property (nonatomic, strong) JHSkinSceneModel *sceneMsgModel;
/// 消息按钮 - 未读消息数 - 背景
@property (nonatomic, strong) JHSkinSceneModel *sceneMsgNumBgModel;
/// 消息按钮 - 未读消息数 - 标题
@property (nonatomic, strong) JHSkinSceneModel *sceneMsgNumTitleModel;
/// 签到按钮
@property (nonatomic, strong) JHSkinSceneModel *sceneSignModel;
/// 分类
@property (nonatomic, strong) JHSkinSceneModel *sceneCategoryModel;
/// 主区域背景
@property (nonatomic, strong) JHSkinSceneModel *sceneBGModel;
/// 直播图标
@property (nonatomic, strong) JHSkinSceneModel *sceneLiveModel;
/// tabbar - index : 0 宝友集市
@property (nonatomic, strong) JHSkinSceneModel *sceneBarOneModel;
/// tabbar - index : 1 源头直购-首页
@property (nonatomic, strong) JHSkinSceneModel *sceneBarTwoModel;
/// tabbar - index : 2 天天商城
@property (nonatomic, strong) JHSkinSceneModel *sceneBarThreeModel;
/// tabbar - index : 3 鉴定回收
@property (nonatomic, strong) JHSkinSceneModel *sceneBarFourModel;
/// tabbar - index : 4 个人中心
@property (nonatomic, strong) JHSkinSceneModel *sceneBarFiveModel;
/// tabbar - 返回顶部
@property (nonatomic, strong) JHSkinSceneModel *sceneBarTopModel;
/// 平台保障-Title
@property (nonatomic, strong) JHSkinSceneModel *scenePlatformTitleModel;
/// 平台保障-背景
@property (nonatomic, strong) JHSkinSceneModel *scenePlatformBgModel;
/// 平台保障-右箭头
@property (nonatomic, strong) JHSkinSceneModel *scenePlatformRightModel;
/// 平台保障-低价购
@property (nonatomic, strong) JHSkinSceneModel *scenePlatformOneModel;
/// 平台保障-专家逐件把关
@property (nonatomic, strong) JHSkinSceneModel *scenePlatformTwoModel;
/// 平台保障-7天无理由
@property (nonatomic, strong) JHSkinSceneModel *scenePlatformThreeModel;

/// 金刚位
@property (nonatomic, strong) JHSkinSceneModel *sceneVajraTitleModel;

+ (instancetype)shareManager;
/// 加载数据
- (void)loadData; 
@end

NS_ASSUME_NONNULL_END
