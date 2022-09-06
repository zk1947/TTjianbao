//
//  JHCustomizeAddProgramPictsTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeAddProgramPictsTableViewCell : UITableViewCell
//@property (nonatomic, copy) dispatch_block_t addBlock;

@property (nonatomic, copy) void(^addBlock)(BOOL isImage);


@property (nonatomic, copy) void (^deleteBlock)(NSInteger index);
@property (nonatomic, copy) void(^pictsHasValue)(BOOL has);
- (void)setViewModel:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
