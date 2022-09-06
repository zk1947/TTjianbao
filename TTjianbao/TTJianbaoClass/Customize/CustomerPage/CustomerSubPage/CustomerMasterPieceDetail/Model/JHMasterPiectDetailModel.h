//
//  JHMasterPiectDetailModel.h
//  TTjianbao
//
//  Created by user on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMasterPiectDetailModel : NSObject

@property (nonatomic,   copy) NSString *createTime; /// 上传时间
@property (nonatomic, assign) NSInteger customerId; /// 定制师ID
@property (nonatomic,   copy) NSString *desc;       /// 代表作描述
@property (nonatomic, assign) NSInteger ID;         /// 代表作ID
@property (nonatomic,   copy) NSString *name;       /// 定制师名称
@property (nonatomic,   copy) NSString *opusImage;  /// 代表作图片
@property (nonatomic,   copy) NSString *reason;     /// 拒审原因
@property (nonatomic, assign) NSInteger status;     /// 状态
@property (nonatomic,   copy) NSString *title;      /// 代表作标题

@end


NS_ASSUME_NONNULL_END
