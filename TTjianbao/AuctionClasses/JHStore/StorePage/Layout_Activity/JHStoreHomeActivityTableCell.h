//
//  JHStoreHomeActivityTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHStoreHomeShowcaseModel;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHStoreHomeActivityTableId = @"JHStoreHomeActivityTableIdentifer";

@interface JHStoreHomeActivityTableCell : UITableViewCell

@property (nonatomic, strong) JHStoreHomeShowcaseModel *showcaseModel;



@end

NS_ASSUME_NONNULL_END
