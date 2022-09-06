//
//  JHNewStoreBoutiqueFlowLayout.h
//  TTjianbao
//
//  Created by user on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, JHArrangeAlignment) {
    JHArrangeAlignment_Balance,//默认平均分布
    JHArrangeAlignment_Left,   //左对齐
    JHArrangeAlignment_Right,  //右对齐
    JHArrangeAlignment_Center, //居中对齐
};


@interface JHNewStoreBoutiqueFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat                    spanHorizonal;
@property (nonatomic, assign) JHArrangeAlignment         arrangeAlignment;
@end

NS_ASSUME_NONNULL_END
