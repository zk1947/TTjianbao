//
//  NTESCollectionBaseCell.h
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/1/19.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESCollectionBaseCell : UICollectionViewCell

/**
 配置cell的间隔线

 @param index 当前位置
 @param rowsEveryPage 每页总列数
 @param linesEveryPage 每页总行数
 */
- (void)configCellSeparate:(NSInteger)index
             rowsEveryPage:(NSInteger)rowsEveryPage
            linesEveryPage:(NSInteger)linesEveryPage;


- (void)hiddenAllSeparate;

@end
