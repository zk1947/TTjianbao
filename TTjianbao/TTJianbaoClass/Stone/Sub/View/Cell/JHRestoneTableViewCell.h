//
//  JHRestoneTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHStoneBaseView.h"
#import "JHLastSaleGoodsModel.h"

@protocol JHTableViewCellDelegate <NSObject>

@optional
- (void)pressButtonType:(RequestType)type dataModel:(id _Nullable )model indexPath:(NSIndexPath *_Nullable)indexPath;
- (void)pressButtonType:(RequestType)type tableViewCell:(UITableViewCell*_Nullable)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JHRestoneTableViewCell : JHBaseTableViewCell
@property (nonatomic, weak) id<JHTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
