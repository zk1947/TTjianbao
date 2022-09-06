//
//  JHHomeCollectionViewFlowLayout.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellSizeModel : NSObject
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;

@end


@interface JHHomeCollectionViewFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,assign)int  colunms;
@property(nonatomic,assign) BOOL showDefaultImage;
@property(nonatomic, assign)CGFloat headerHeight;

@property(nonatomic,strong)NSMutableArray<CellSizeModel *> *iconArray;
- (instancetype)initWithColoumn:(int)coloumn  data:(NSMutableArray *)dataA   verticleMin:(float)minv  horizonMin:(float)minh  leftMargin:(float)leftMargin  rightMargin:(float)rightMargin headerHeight:(float)headerHeight;
@end




NS_ASSUME_NONNULL_END
