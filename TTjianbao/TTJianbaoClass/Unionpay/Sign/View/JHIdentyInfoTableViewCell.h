//
//  JHIdentyInfoTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHUnionPayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHIdentyInfoTableViewCellDelegate <NSObject>

@optional
- (void)infoTableViewCellTextChanged:(UITextField *)textfield dataType:(JHDataType)dataType;
///cell结束输入
- (void)infoTableViewCellDidEndEditing:(UITextField *)textfield dataType:(JHDataType)dataType;

@end


@class JHUnionPayUserListModel;

static NSString *const kIdentyInfoCellIdentifer = @"kIdentyInfoTableViewCellIdentifer";

@interface JHIdentyInfoTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isUserEnabled;  ///限制tableViewCell是否有交互性
@property (nonatomic, assign) BOOL isNeedShowArrow;   ////是否需要显示箭头
@property (nonatomic, copy) NSString *inputText;   ///输入的文字
@property (nonatomic, assign) NSTextAlignment textAlignment;   //设置文字的对齐方式
@property (nonatomic, strong) JHUnionPayUserListModel *listModel;
@property (nonatomic, weak) id<JHIdentyInfoTableViewCellDelegate> delegate;

///设置圆角
- (void)setCorners:(NSInteger)maxLineCount indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
