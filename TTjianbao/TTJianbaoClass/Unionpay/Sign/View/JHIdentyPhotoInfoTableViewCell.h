//
//  JHIdentyPhotoInfoTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///银联认证 - 底部图片信息cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kIdentyPhotoInfoCellIdentifer = @"kIdentyPhotoInfoCellIdentifer";

@interface JHIdentyPhotoInfoTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *dataArray;  ///存放list信息的数组

@property (nonatomic, assign) NSInteger clomnCount;  ///图片的列数



@end

NS_ASSUME_NONNULL_END
