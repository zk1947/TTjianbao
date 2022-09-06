//
//  NTESLiveSelectButton.h
//  TTjianbao
//
//  Created by chris on 16/7/14.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESLiveSelectObject;

@protocol NTESLiveSelectButtonDelegate <NSObject>

- (void)onSelectObject:(NTESLiveSelectObject *)object;

@end

@interface NTESLiveSelectButton : UIButton

@property (nonatomic, copy) NSArray<NTESLiveSelectObject *> *candidateObjects;

@property (nonatomic, assign) CGRect unitFrame;

@property (nonatomic, weak) id<NTESLiveSelectButtonDelegate> delegate;

@property (nonatomic, copy)   NSString *deselectTitle;

@property (nonatomic, strong) UIImage *deselectImageNormal;

@property (nonatomic, strong) UIImage *deselectImageHighlighted;

@property (nonatomic, copy)   NSString *selectTitle;

@property (nonatomic, strong) UIImage *selectImageNormal;

@property (nonatomic, strong) UIImage *selectImageHighlighted;

- (void)setCurrentObject:(NSInteger)tag;

@end


@interface NTESLiveSelectObject : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) id value;

@property (nonatomic, assign) NSInteger tag;

@end
