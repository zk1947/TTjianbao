//
//  NTESLiveCoverView.h
//  TTjianbao
//
//  Created by chris on 16/3/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,NTESLiveCoverStatus) {
    NTESLiveCoverStatusLinking,
    NTESLiveCoverStatusFinished,
};


@protocol NTESLiveCoverViewDelegate <NSObject>

- (void)didPressBackButton;

@end

#import "BaseView.h"

@interface NTESLiveCoverView : BaseView

@property (nonatomic,weak) id<NTESLiveCoverViewDelegate> delegate;

- (void)refreshWithChatroom:(NSString *)roomId
                     status:(NTESLiveCoverStatus)status;

- (void)setCoverImage:(NSString *)url;

@end
