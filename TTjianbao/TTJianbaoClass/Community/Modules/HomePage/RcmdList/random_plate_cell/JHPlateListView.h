//
//  JHPlateListView.h
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPlateListData;

@interface JHPlateListView : UIView
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, strong) JHPlateListData *plateInfo;

@end

NS_ASSUME_NONNULL_END
