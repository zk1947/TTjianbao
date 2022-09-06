//
//  JHMerchantTypeCell.h
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHMerchantTypeModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHMerchantTypeCellStyle) {
    ///无效果
    JHMerchantTypeCellStyleNone,
    ///边框
    JHMerchantTypeCellStyleBorder,
};

static NSString *kMerchantTypeIdentifer = @"kMerchantTypeIdentifer";

@interface JHMerchantTypeCell : UITableViewCell

@property (nonatomic, strong) JHMerchantTypeModel *merchantModel;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) JHMerchantTypeCellStyle cellStyle;

@end

NS_ASSUME_NONNULL_END
