//
//  JHSQRcmdPlatePanelCCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHPlateListData;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCCellId_JHSQRcmdPlatePanelCCell = @"JHSQRcmdPlatePanelCCellIdentifier";

@interface JHSQRcmdPlatePanelCCell : UICollectionViewCell

@property (nonatomic, strong) JHPlateListData *curData;
@property (nonatomic, assign) JHPageType pageType;


@end

NS_ASSUME_NONNULL_END
