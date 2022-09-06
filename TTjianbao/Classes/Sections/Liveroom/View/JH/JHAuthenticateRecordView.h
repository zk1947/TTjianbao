//
//  JHAuthenticateRecordView.h
//  TTjianbao
//
//  Created by Donto on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHAnchorRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAuthenticateRecordView : BaseView

+ (instancetype)authenticateRecord;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) JHAnchorRecordModel *recordModel;

@end

NS_ASSUME_NONNULL_END
