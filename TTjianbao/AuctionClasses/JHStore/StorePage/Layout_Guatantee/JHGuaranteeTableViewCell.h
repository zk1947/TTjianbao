//
//  JHGuaranteeTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHStoreHomeGuaranteeId = @"JHStoreHomeGuatanteeIdentifier";


@interface JHGuaranteePanelMode : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconNorImgName;   ///正常的b图标
@property (nonatomic, copy) NSString *iconSelImgName;   ///活动图标
@property (nonatomic, copy) NSString *titleNorColor;    ///正常的文字颜色
@property (nonatomic, copy) NSString *titleSelColor;    ///活动的文字颜色

    
@end

@interface JHGuaranteeTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

///根据当前是否有活动改变保障栏的颜色
- (void)transformGuaranteeStyle:(BOOL)isActivity;

@end

NS_ASSUME_NONNULL_END
