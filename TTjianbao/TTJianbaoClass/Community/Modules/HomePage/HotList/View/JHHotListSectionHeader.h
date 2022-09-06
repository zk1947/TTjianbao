//
//  JHHotListSectionHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///热帖

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHotListSectionHeader : JHBaseTableViewHeaderFooterView

///时间字符串
@property (nonatomic, copy) NSString *dateTimeString;

@end

@interface JHHotListSectionFooter : JHWBaseTableViewCell

@end


NS_ASSUME_NONNULL_END
