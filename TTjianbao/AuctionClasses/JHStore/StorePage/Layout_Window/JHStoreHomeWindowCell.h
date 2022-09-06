//
//  JHStoreHomeWindowCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHStoreHomeCardInfoModel;

static NSString *const kCellId_JHStoreHomeWindowTableId = @"JHStoreHomeWindowTableIdentifier";

@interface JHStoreHomeWindowCell : UITableViewCell

@property (nonatomic, strong) JHStoreHomeCardInfoModel *cardInfoModel;
@property (nonatomic, assign) BOOL isClipAllCorners;   ///是否需要切所有圆角
        
+ (CGFloat)cellHeight;



@end

NS_ASSUME_NONNULL_END
