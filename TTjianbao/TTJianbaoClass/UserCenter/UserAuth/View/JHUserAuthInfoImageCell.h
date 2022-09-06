//
//  JHUserAuthInfoImageCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserAuthInfoImageCell : JHWBaseTableViewCell

/// 0-身份证正面    1-身份证反面    2-营业执照   3-法人身份证正面    4-法人身份证反面
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak, readonly) UIImageView *leftImageView;
/// 重新提交
@property (nonatomic, assign) BOOL reCommit;

/// 图片（url/image）
@property (nonatomic, strong) id uploadImage;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^clickBlock)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
