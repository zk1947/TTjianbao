//
//  JHCoverView.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/23.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"JHCoverModel.h"
@protocol JHCoverViewDelegate <NSObject>

@optional
-(void)Complete;
-(void)addPhoto;
-(void)deletePhoto:(JHCoverModel*)mode;
-(void)photoImageSelect:(JHCoverModel*)mode;

@end
#import "BaseView.h"

@interface JHCoverView : BaseView
@property(weak,nonatomic)id<JHCoverViewDelegate>delegate;
@property (strong, nonatomic)  NSArray *photos;
@end


