//
//  JHCustomizeAddProgramMoneyTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeAddProgramMoneyTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^moneyHasValue)(BOOL has);

- (BOOL)checkTextFieldIsLegal;
- (NSString *)allMoneyText;
- (NSString *)getServertext;
- (NSString *)getMaterialtext;
@end

NS_ASSUME_NONNULL_END
