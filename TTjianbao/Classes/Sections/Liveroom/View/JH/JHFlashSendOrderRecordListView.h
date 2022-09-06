//
//  JHFlashSendOrderRecordListView.h
//  TTjianbao
//
//  Created by user on 2021/10/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHFlashSendOrderRecordListView : JHPopBaseView
@property (nonatomic,   copy) NSString *anchorId;

@property(nonatomic, copy) void(^showProductBlock)(NSString* _Nullable  productCode) ;

@end

NS_ASSUME_NONNULL_END
