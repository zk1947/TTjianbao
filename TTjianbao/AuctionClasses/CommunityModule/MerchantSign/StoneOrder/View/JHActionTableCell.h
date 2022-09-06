//
//  JHActionTableCell.h
//  TaodangpuAuction
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHOriginStoneModel;

@protocol JHActionTableCellDelegate <NSObject>

///升跌设定点击事件
- (void)setAction:(NSIndexPath *_Nonnull)indexPath;
///上传视频图片事件
- (void)uploadAction:(NSIndexPath *_Nonnull)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JHActionTableCell : UITableViewCell

@property (nonatomic, strong) JHOriginStoneModel *stoneModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<JHActionTableCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
