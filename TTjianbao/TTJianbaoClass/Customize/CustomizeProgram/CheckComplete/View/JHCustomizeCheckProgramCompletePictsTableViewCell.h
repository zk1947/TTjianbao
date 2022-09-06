//
//  JHCustomizeCheckProgramCompletePictsTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/12/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeCheckProgramCompletePictsTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^pictActionBlock)(NSInteger index, NSArray *imgArr);
- (void)setViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
