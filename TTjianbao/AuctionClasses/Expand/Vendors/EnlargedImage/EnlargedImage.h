//
//  EnlargedImage.h
//  test
//
//  Created by test on 2017/2/4.
//  Copyright © 2017年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JHAudienceCommentMode.h"

@interface EnlargedImage : NSObject
@property (nonatomic, strong)JHAudienceCommentMode *audienceCommentMode;
+(EnlargedImage*)sharedInstance;
- (void)enlargedImage:(UIImageView*)oldImageview enlargedTime:(CGFloat)uesTime images:(NSMutableArray*)imageurls andIndex:(NSInteger)photoIndex result:(void (^)(NSInteger))scrollIndex;

@end
