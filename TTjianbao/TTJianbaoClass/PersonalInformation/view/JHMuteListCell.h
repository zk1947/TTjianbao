//
//  JHMuteListCell.h
//  TTjianbao
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMuteListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMuteListCell : UITableViewCell
@property(nonatomic, strong) JHMuteListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (nonatomic, copy) JHActionBlock openMuteBlock;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *privatMsg;

@end

NS_ASSUME_NONNULL_END
