//
//  JHMyCompeteFlowLayoutDelegate.h
//  TTjianbao
//
//  Created by miao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHMyCompeteFlowLayout;
 
NS_ASSUME_NONNULL_BEGIN

@protocol JHMyCompeteFlowLayoutDelegate <NSObject>

@required

-(CGFloat)shopCVLayout:(JHMyCompeteFlowLayout *)shopCVLayout
heighForItemAtIndexPath:(NSIndexPath*)indexPath
             itemWidth:(CGFloat)itemWidth;

@optional

@end

NS_ASSUME_NONNULL_END
