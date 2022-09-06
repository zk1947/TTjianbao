//
//  JHRecycleOrderNodeFlowLayout.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderNodeFlowLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign)CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)AlignType cellType;
@end

NS_ASSUME_NONNULL_END
