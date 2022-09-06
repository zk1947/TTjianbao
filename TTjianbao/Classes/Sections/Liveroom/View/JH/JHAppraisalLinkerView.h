//
//  JHAppraisalLinkerView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/14.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLinkerTableViewCell.h"
@protocol JHAppraisalLinkerViewDelegate <NSObject>
@optional
- (void)connectUser:(NSInteger )index model:(NTESMicConnector *)model;
- (void)disconnectUser:(NSInteger )index model:(NTESMicConnector *)model;
- (void)lookUserDetail:(NSInteger )index model:(NTESMicConnector *)model;
- (void)onReporter:(NSInteger)index model:(NTESMicConnector *)model;
- (void)sendRedPocket:(NSInteger)index model:(NTESMicConnector *)model;
- (void)lookOrderList:(NSInteger)index model:(NTESMicConnector *)model;
- (void)showRecordList:(NSInteger)index model:(NTESMicConnector *)model;

@end

#import "BaseView.h"

@interface JHAppraisalLinkerView : BaseView
@property (nonatomic,weak) id<JHAppraisalLinkerViewDelegate> delegate;

- (void)showAlert;
- (void)hiddenAlert;
- (void)reloadData:(NSArray *)array;


/**
 修改连接按钮状态

 @param type 0 无连接 1 正在连接中 2已经连接显示断开  
   */
@property (nonatomic,assign) NSInteger statusType;
@property (nonatomic,assign) NSInteger timeCount;
@end
