//
//  JHPostDetailPicInfoTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kJHPostDetailPicInfoTableCellIdentifer = @"kJHPostDetailPicInfoTableCellIdentifer";

@class JHPostDetailModel;
@interface JHPostDetailPicInfoTableCell : UITableViewCell

@property (nonatomic, copy) void(^clickPhotoBlock)(NSArray <UIImageView *>*sourceViews, NSInteger index);
@property (nonatomic, strong) JHPostDetailModel *postInfo;
///设置图片
- (void)configImages:(NSArray *)imageArray;
+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
