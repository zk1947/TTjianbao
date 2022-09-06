//
//  NEFilterMenuBar.h
//  NTES_Live_Demo
//
//  Created by zhanggenning on 17/1/20.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "NTESMenuBaseBar.h"
#import "NTESFiterMenuView.h"

typedef void(^NTESMenuFilterValueChanged)(CGFloat value);

@interface NTESFilterMenuBar : NTESMenuBaseBar

@property (nonatomic, assign) CGFloat constrastValue;

@property (nonatomic, assign) CGFloat smoothValue;

@property (nonatomic, assign) NSInteger filterIndex;

@property (nonatomic, copy) NTESMenuFilterValueChanged contrastChangedBlock;

@property (nonatomic, copy) NTESMenuFilterValueChanged smoothChangedBlock;

@property (nonatomic, weak) id<NTESMenuViewProtocol> delegate;

- (void)cancel;

@end
