//
//  JHEvaluateCell.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMAvatarImageView.h"
#import "JHEvaluationModel.h"
@interface JHEvaluateCell : UICollectionViewCell

+ (CGFloat)getTagHeightWithCount:(NSInteger)count;
+ (CGFloat)getHeightWithContent:(NSString *)string;
+ (CGFloat)cellHeightWithModel:(JHEvaluationModel *)model;

@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tagArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagHeight;

@property (nonatomic, strong) JHEvaluationModel *model;
@end
