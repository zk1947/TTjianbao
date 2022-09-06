//
//  JHMallGroupCategoryTitleView.h
//  TTjianbao
//
//  Created by apple on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHMallCateViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHMallGroupCategoryTitleView : UIView
-(void)setData:(NSArray *)categoryData;
@property(nonatomic)void (^clickItemBlock)(JHMallCateViewModel *vm, NSInteger currentIndex);
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
