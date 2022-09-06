//
//  JHArbitramentDescriptionCell.h
//  TTjianbao
//
//  Created by lihui on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
/// 补充描述和凭证的cell

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHArbitramentDescriptionCell : JHWBaseTableViewCell

+ (CGFloat)cellHeight;

///存放图片的数组
@property (nonatomic, copy) NSArray <UIImage *>*imageArray;



@end

NS_ASSUME_NONNULL_END
