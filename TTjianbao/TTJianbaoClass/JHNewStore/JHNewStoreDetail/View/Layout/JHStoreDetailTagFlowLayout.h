//
//  JHStoreDetailTagFlowLayout.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailBaseFlowLayout.h"
typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailTagFlowLayout : JHStoreDetailBaseFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign)CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)AlignType cellType;

-(instancetype)initWthType : (AlignType)cellType;
//全能初始化方法 其他方式初始化最终都会�走到这里
-(instancetype)initWithType:(AlignType) cellType betweenOfCell:(CGFloat)betweenOfCell;

@end

NS_ASSUME_NONNULL_END
