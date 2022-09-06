//
//  JHAnnouncementTemplateAddTextCell.h
//  TTjianbao
//
//  Created by Donto on 2020/7/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHAnnouncementTemplateAddTextCell;

@protocol JHAnnouncementTemplateAddTextCellDelegate <NSObject>

- (void)addLine:(JHAnnouncementTemplateAddTextCell *)cell;
- (void)deleteLine:(JHAnnouncementTemplateAddTextCell *)cell;
- (void)editingLine:(JHAnnouncementTemplateAddTextCell *)cell changedText:(NSString *)text;

@end

@interface JHAnnouncementTemplateAddTextCell : JHWBaseTableViewCell

@property (nonatomic, weak) id<JHAnnouncementTemplateAddTextCellDelegate>delegate;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL onlyOneLine;
@property (nonatomic, readonly) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
