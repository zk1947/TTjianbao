//
//  JHIdentificationDetailsCell.h
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
@class JHIdentDetailImageOrVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHIdentificationDetailsCell : JHWBaseTableViewCell

@property (nonatomic, strong) UIImageView *videoView;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) JHIdentDetailImageOrVideoModel *detailOrVideoModel;

@end

NS_ASSUME_NONNULL_END
