//
//  JHUploadImgView.h
//  TTjianbao
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JHUploadImgViewDelegate <NSObject>

- (void)uploadImage;

- (void)cancelSelect;

@end

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUploadImgView : BaseView

@property (nonatomic, weak) id<JHUploadImgViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *addImageName;
@property (nonatomic, copy) NSString *alertString;
@property (nonatomic, copy) NSString *bottomAlertString;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL clipCorner;


@end

NS_ASSUME_NONNULL_END
