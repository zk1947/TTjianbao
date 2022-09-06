//
//  JHFansLeaveSectionView.h
//  TTjianbao
//
//  Created by Paros on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessFansSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansLeaveSectionView : UIView

@property(nonatomic) NSInteger  fanSection;

@property(nonatomic) BOOL  isShow;

@property(nonatomic) BOOL  isSelted;

@property(nonatomic, strong) JHBusinessFansLevelTemplateVosModel * model;

@property(nonatomic, copy) void (^showDetailBlock) (NSInteger section, BOOL show);

@property(nonatomic, copy) void (^selteSectionBlock) (NSInteger section, JHBusinessFansLevelTemplateVosModel *model);

- (void)refershLblText:(NSString*)text appendSep:(BOOL)need;

@end

NS_ASSUME_NONNULL_END
