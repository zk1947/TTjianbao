//
//  JHAnchorRecordModel.h
//  TTjianbao
//
//  Created by Donto on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

//{
//"customerImg": "string",
//"customerName": "string",
//"lastAppraiseDateFormat": "string",
//"reportList": [
//  {
//    "appraiseDateFormat": "string",
//    "coverImg": "string",
//    "price": "string",
//    "result": "string"
//  }
//]
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHAnchorRecordListModel : NSObject

@property (nonatomic, copy) NSString *appraiseDateFormat;
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSString *price;
// 鉴定结果
@property (nonatomic, copy) NSString *result;

@end

@interface JHAnchorRecordModel : NSObject

@property (nonatomic, copy) NSString *customerImg;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *lastAppraiseDateFormat;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<JHAnchorRecordListModel *> *reportList;

@end

NS_ASSUME_NONNULL_END
