//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JHVideoCropFrameModel : NSObject

@property(nonatomic,assign)NSInteger dataIndex;
@property(nonatomic,strong)AVAsset *superAsset;
@property(nonatomic,strong)UIImage *frameImage;
@property(nonatomic,assign)CMTime startTime; // 在全局中起始时间
@property(nonatomic,assign)CMTime duration;

@end

