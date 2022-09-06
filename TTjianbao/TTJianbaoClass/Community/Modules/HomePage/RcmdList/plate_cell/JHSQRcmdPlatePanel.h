//
//  JHSQRcmdPlatePanel.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPostCellHeader.h"

@class JHPlateListData;

NS_ASSUME_NONNULL_BEGIN

@interface JHSQRcmdPlatePanel : UIView

@property (nonatomic, strong) NSMutableArray <JHPlateListData *> *plateList;
@property (nonatomic, assign) JHPageType pageType;


@end

NS_ASSUME_NONNULL_END
