//
//  JHPersonHeaderCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define bannerHeight (70./355*(ScreenW-20))
#define topHeadHeight  ([JHRootController isLogin] ? (175+UI.statusBarHeight) : (140+UI.statusBarHeight))//219 : 184

#define taskHeight 160//(160./355*(ScreenW-20))

typedef NS_ENUM(NSInteger, JHPersonCenterAction) {
    JHPersonCenterActionFollow = 0,
    JHPersonCenterActionFans,
    JHPersonCenterActionGetLikes,
    JHPersonCenterActionExperienceValue,
};


NS_ASSUME_NONNULL_BEGIN

@class User;
@class JHUserLevelInfoMode;


@interface JHPersonHeaderCell : UICollectionViewCell

@property (nonatomic, strong)JHUserLevelInfoMode *levelModel;
@property (nonatomic, strong)User *userModel;
@property (nonatomic, copy)JHActionBlock taskBlock;
@property (nonatomic, copy)JHActionBlock scoreBlock;
@property (nonatomic, copy)JHActionBlock personHomeBlock;
@property (nonatomic, copy)JHActionBlocks headerActionBlock;
@property (nonatomic, copy)JHActionBlock signActionBlock;  ///签到
@property (nonatomic, copy) dispatch_block_t enterMerchantCertBlock;

- (void)transformHeaderStyle;

@end

NS_ASSUME_NONNULL_END
