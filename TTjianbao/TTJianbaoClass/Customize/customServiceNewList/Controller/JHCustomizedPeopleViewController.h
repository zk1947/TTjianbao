//
//  JHCustomizedPeopleViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizedPeopleViewController : JHBaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)reloadNewData;
@end

NS_ASSUME_NONNULL_END
