//
//  AppraisalDetailMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApprailsaiDetailAnchorMode.h"

@interface AppraisalDetailMode : NSObject
@property (strong,nonatomic)NSString* assessmentReport;
@property (strong,nonatomic)NSString * comments;
@property (strong,nonatomic)NSString* appraiseId;
@property (assign,nonatomic)NSInteger isLaud;
@property (strong,nonatomic)NSString* lauds;
@property (assign,nonatomic)NSInteger isFollow;
@property (strong,nonatomic)NSString* pullUrl;
@property (strong,nonatomic)NSString* price;
@property (strong,nonatomic)NSString * recordId;
@property (strong,nonatomic)NSString* reportId;
@property (strong,nonatomic)NSString* videoUrl;
@property (strong,nonatomic)NSString *originRecordId;

@property (strong,nonatomic)ApprailsaiDetailAnchorMode * appraiser;
@property (strong,nonatomic)NSString* priceStr;
@property (assign,nonatomic)NSInteger appraiseResult;
@property (strong,nonatomic)NSString *coverImg;
@property (strong,nonatomic)NSString *title;
@property (strong,nonatomic)NSString *laudsStr;


@end


