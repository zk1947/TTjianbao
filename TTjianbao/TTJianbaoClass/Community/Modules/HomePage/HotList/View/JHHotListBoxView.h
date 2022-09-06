//
//  JHHotListBoxView.h
//  TaodangpuAuction
//
//  Created by yuyue_mp1517 on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadScrollBlock)(BOOL isUp);

@interface JHHotListBoxView : UIView

@property (nonatomic, copy) HeadScrollBlock headScrollBlock;

@property(nonatomic,strong)UICollectionView *collectionView;

///页面消失（曝光买点）
-(void)viewDidDisappearMethod;

@end

NS_ASSUME_NONNULL_END
