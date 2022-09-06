//
//  JHSkinSceneManager.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/10/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSkinSceneManager.h"
#import "JHSkinManager.h"

@interface JHSkinSceneManager()

@end
@implementation JHSkinSceneManager
+ (instancetype)shareManager {
    static JHSkinSceneManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHSkinSceneManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if (self = [super init]){
        [self setupScene];
    }
    return self;
}

/// 加载数据
- (void)loadData {
    [JHSkinManager requeastSkinData];
    @weakify(self)
    [JHSkinManager shareManager].downloadSuccessHandler = ^{
        @strongify(self)
        [self setupScene];
    };
}

#pragma mark - Private
- (void)setupScene {
    [self setupSceneLiveNavi]; // 导航条
    [self setupSceneMessage];  // 消息
    [self setupSceneSign];     // 签到
    [self setupCategory];      // 分类
    [self setupSceneTitle];    // 标题
    [self setupBg];            // 主区域背景
    [self setupLive];          // 直播图标
    [self setupTabBar];        // tabbar
    [self setupPlatform];      // 平台保障
    [self setupVajraTitle];    // 金刚位
}
- (JHSkinSceneModel *)getSkinScene : (JHSkinSceneModel *)scene type: (JHSkinType)type{
    JHSkinSceneModel *newScene = scene;
    JHSkinModel *model = [JHSkinManager getSkinInfoWithType:type];
    if (model.isChange)
    {
        if (model.corner != nil) {
            NSString *imagePath = [JHSkinManager getImageFilePath:model.corner];
            UIImage *image = [JHSkinManager getImageWithPath:imagePath];
            if (image != nil) {
                newScene.imageCornerNor = image;
            }
        }
    
        if ([model.type intValue] == 0){
            if (model.name != nil) {
                NSString *path = [JHSkinManager getImageFilePath:model.name];
                UIImage *image = [JHSkinManager getImageWithPath:path];
                if (image != nil) {
                    newScene.imageNor = image;
                }
            }
            if (model.useName != nil) {
                NSString *path = [JHSkinManager getImageFilePath:model.useName];
                UIImage *image = [JHSkinManager getImageWithPath:path];
                if (image != nil) {
                    newScene.imageSel = image;
                }
            }
        }else if ([model.type intValue] == 1){
            if (model.name.length > 0) {
                newScene.colorNor = COLOR_CHANGE(model.name);
                newScene.colorBGNor = COLOR_CHANGE(model.name);
                newScene.colorBorderNor = COLOR_CHANGE(model.name);
            }
            if (model.useName.length > 0) {
                newScene.colorSel = COLOR_CHANGE(model.useName);
                newScene.colorBGSel = COLOR_CHANGE(model.useName);
                newScene.colorBorderSel = COLOR_CHANGE(model.useName);
            }
        }
    }
    
    return newScene;
}
/// 首页标题
- (void)setupSceneTitle {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.colorNor = BLACK_COLOR;
    scene.colorSel = BLACK_COLOR;
    scene.imageCornerNor = nil;
   
    self.sceneTitleModel = [self getSkinScene:scene type:JHSkinTypeTitle];
}
/// 首页导航条
- (void)setupSceneLiveNavi {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];

    self.sceneNaviModel = [self getSkinScene:scene type:JHSkinTypeNavi];
}
/// 主区域背景
- (void)setupBg {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = nil;
    scene.colorBGNor = [UIColor whiteColor];

    self.sceneBGModel = [self getSkinScene:scene type:JHSkinTypeBGHome];
}
/// 消息按钮
- (void)setupSceneMessage {
    [self setupSceneMsgBtn];
    [self setupSceneMsgNumTitle];
    [self setupSceneMsgNumBg];
}
- (void)setupSceneMsgBtn {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [UIImage imageNamed:@"navi_icon_message_home"];

    JHSkinSceneModel *newScene = [self getSkinScene:scene type:JHSkinTypeMessage];
    newScene.imageNor = [JHSkinManager scaleToSize:newScene.imageNor size:CGSizeMake(29, 29)];
    self.sceneMsgModel = newScene;
}
- (void)setupSceneMsgNumTitle {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.colorNor = [UIColor whiteColor];
 
    self.sceneMsgNumTitleModel = [self getSkinScene:scene type:JHSkinTypeMessageNumTitle];;
}
- (void)setupSceneMsgNumBg {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.colorBGNor = RGB(252, 66, 0);

    self.sceneMsgNumBgModel = [self getSkinScene:scene type:JHSkinTypeMessageNumBg];;
}
/// 签到按钮
- (void)setupSceneSign {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"navi_icon_sign_webp.webp"];
    scene.imageSel = [JHSkinManager getImageWithName:@"navi_icon_sign"];
    
    JHSkinSceneModel *newScene = [self getSkinScene:scene type: JHSkinTypeSign];
    newScene.imageSel = [JHSkinManager scaleToSize:newScene.imageSel size:CGSizeMake(29, 29)];
    self.sceneSignModel = newScene;
}
/// 分类
- (void)setupCategory {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [UIImage imageNamed:@"search_class_icon"];
 
    self.sceneCategoryModel = [self getSkinScene:scene type: JHSkinTypeCategory];
}

/// 直播图标
- (void)setupLive {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"mall_home_bannar_living.webp"];

    self.sceneLiveModel = [self getSkinScene:scene type:JHSkinTypeLiveIcon];
}
/// tabbar
- (void)setupTabBar {
    [self setupTabBarOne];
    [self setupTabBarTwo];
    [self setupTabBarThree];
    [self setupTabBarFour];
    [self setupTabBarFive];
    [self setupTabBarTop];
}
- (void)setupTabBarOne {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"home_newtable_nomal"];
    scene.imageSel = [JHSkinManager getImageWithName:@"home_newtable_select"];
    scene.colorNor = [self getTabBarTitleColor];
    scene.colorSel = [self getTabBarTitleColorSel];

    self.sceneBarOneModel = [self getSkinScene:scene type: JHSkinTypeBarIndex0];;
}
- (void)setupTabBarTwo {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"mall_newtable_nomal"];
    scene.imageSel = [JHSkinManager getImageWithName:@"mall_newtable_select"];
    scene.colorNor = [self getTabBarTitleColor];
    scene.colorSel = [self getTabBarTitleColorSel];
    
    self.sceneBarTwoModel = [self getSkinScene:scene type:JHSkinTypeBarIndex1];;
}
- (void)setupTabBarThree {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"tabbar_shop_normal"];
    scene.imageSel = [JHSkinManager getImageWithName:@"tabbar_shop_select"];
    scene.colorNor = [self getTabBarTitleColor];
    scene.colorSel = [self getTabBarTitleColorSel];

    self.sceneBarThreeModel = [self getSkinScene:scene type:JHSkinTypeBarIndex2];;
}
- (void)setupTabBarFour {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"appraisal_newtable_nomal"];
    scene.imageSel = [JHSkinManager getImageWithName:@"appraisal_newtable_select"];
    scene.colorNor = [self getTabBarTitleColor];
    scene.colorSel = [self getTabBarTitleColorSel];
    
    self.sceneBarFourModel = [self getSkinScene:scene type:JHSkinTypeBarIndex3];;
}
- (void)setupTabBarFive {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"my_newtable_nomal"];
    scene.imageSel = [JHSkinManager getImageWithName:@"my_newtable_select"];
    scene.colorNor = [self getTabBarTitleColor];
    scene.colorSel = [self getTabBarTitleColorSel];

    self.sceneBarFiveModel = [self getSkinScene:scene type:JHSkinTypeBarIndex4];;
}
- (void)setupTabBarTop {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.imageNor = [JHSkinManager getImageWithName:@"my_newtable_totop"];
    JHSkinSceneModel *newScene = [self getSkinScene:scene type:JHSkinTypeBarGoTop];
    newScene.imageNor = [JHSkinManager scaleToSize:newScene.imageNor size:CGSizeMake(SIZE_WIDTH, SIZE_WIDTH)];
    self.sceneBarTopModel = newScene;
}
- (UIColor *)getTabBarTitleColor {
    UIColor *color = kColor222;
    JHSkinModel *font_model = [JHSkinManager getSkinInfoWithType : JHSkinTypeBarTitle];
    if (font_model.isChange)
    {
        if ([font_model.type intValue] == 1)
        {
            color = COLOR_CHANGE(font_model.name);
        }
    }
    return color;
}
- (UIColor *)getTabBarTitleColorSel {
    UIColor *color = kColor222;
    JHSkinModel *font_model = [JHSkinManager getSkinInfoWithType : JHSkinTypeBarTitle];
    if (font_model.isChange)
    {
        if ([font_model.type intValue] == 1)
        {
            color = COLOR_CHANGE(font_model.name);
        }
    }
    return color;
}
/// 平台保障
- (void)setupPlatform {
    [self setupPlatformTitle];
    [self setupPlatformBg];
    [self setupPlatformRight];
    [self setupPlatformOne];
    [self setupPlatformTwo];
    [self setupPlatformThree];
}
// 保障标题
- (void)setupPlatformTitle {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.colorNor = HEXCOLOR(0xB9855D);
    
    self.scenePlatformTitleModel = [self getSkinScene:scene type:JHSkinTypePlatformTitle];;
}
// 保障背景色
- (void)setupPlatformBg {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.colorNor = HEXCOLOR(0xF7F4F0);
    scene.colorBorderNor = HEXCOLOR(0xf1e9df);

    self.scenePlatformBgModel = [self getSkinScene:scene type:JHSkinTypePlatformBg];
}
// 保障右侧icon
- (void)setupPlatformRight {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];

    self.scenePlatformRightModel = [self getSkinScene:scene type:JHSkinTypePlatformRight];
}
// 保障位置1 显示
- (void)setupPlatformOne {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.titleNor = @"源头直播低价购";
    scene.colorNor = HEXCOLOR(0xB9855D);
    scene.imageNor =  [JHSkinManager getImageWithName:@"mall_home_address"];
    
    self.scenePlatformOneModel = [self getSkinScene:scene type:JHSkinTypePlatform0];
}
// 保障位置2 显示
- (void)setupPlatformTwo {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.titleNor = @"专家逐件把关";
    scene.colorNor = HEXCOLOR(0xB9855D);
    scene.imageNor =  [JHSkinManager getImageWithName:@"mall_home_door"];
    
    self.scenePlatformTwoModel = [self getSkinScene:scene type:JHSkinTypePlatform1];
}
// 保障位置3 显示
- (void)setupPlatformThree {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.titleNor = @"7天无理由退换";
    scene.colorNor = HEXCOLOR(0xB9855D);
    scene.imageNor =  [JHSkinManager getImageWithName:@"mall_home_seven"];
    
    self.scenePlatformThreeModel = [self getSkinScene:scene type:JHSkinTypePlatform2];
}
/// 金刚位 标题
- (void)setupVajraTitle {
    JHSkinSceneModel *scene = [[JHSkinSceneModel alloc] init];
    scene.colorNor = kColor222;
    
    self.sceneVajraTitleModel = [self getSkinScene:scene type:JHSkinTypeVajraTitle];
}
#pragma mark - LAZY

@end
