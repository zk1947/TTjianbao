//
//  JHCoverCollectionViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/22.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCoverModel.h"
@interface JHCoverCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, strong) JHCoverModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property (nonatomic, copy) JHActionBlock clickAction;

@property (nonatomic, copy) JHActionBlock deleteAction;
@end
