//
//  JHRecycleHeader.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#ifndef JHRecycleHeader_h
#define JHRecycleHeader_h



typedef NS_ENUM(NSInteger, RecycleOrderButtonType){
    ///取消按钮
    RecycleOrderButtonTypeCancel = 100,
    ///订单追踪
    RecycleOrderButtonTypePursue,
    ///上门取件
    RecycleOrderButtonTypeAppointment,
    ///查看上门取件
    RecycleOrderButtonTypeCheckAppointment,
    ///查看物流
    RecycleOrderButtonTypeLogistics,
    ///申请仲裁
    RecycleOrderButtonTypeArbitration,
    ///查看仲裁
    RecycleOrderButtonTypeCheckArbitration,
    ///确认交易
    RecycleOrderButtonTypeEnsure,
    ///删除按钮
    RecycleOrderButtonTypeDelete,
    ///申请退回
    RecycleOrderButtonTypeReturn,
    ///确认收货
    RecycleOrderButtonTypeReceived,
    ///申请销毁
    RecycleOrderButtonTypeDestruction,
    ///关闭交易
    RecycleOrderButtonTypeClose,
    ///填写物流订单
    RecycleOrderButtonTypeFillLogistics,
    
};

#endif /* JHRecycleHeader_h */
