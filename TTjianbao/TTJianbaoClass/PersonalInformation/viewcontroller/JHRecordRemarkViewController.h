//
//  JHRecordRemarkViewController.h
//  TTjianbao
//
//  Created by lihui on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecordRemarkViewController : JHBaseViewController
//http://localhost:20001/appraiseRecord/anchor/remark/video/record?appraiseRecordId=6727&remarkContent=我是个测试备注
///鉴定记录id
@property (nonatomic, copy) NSString *appraiseRecordId;
///备注信息
@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) dispatch_block_t backBlock;

@end

NS_ASSUME_NONNULL_END
