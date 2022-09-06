//
//  JHVideoTableViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMAvatarImageView.h"
#import "ZFSliderView.h"
#import "JHLikeImageView.h"
#import "AppraisalDetailMode.h"

typedef NS_ENUM(NSInteger, JHVideoTableViewCellClickType) {
    JHVideoTableViewCellClickTypeFollow = 100,
    JHVideoTableViewCellClickTypeSayWhat,
    JHVideoTableViewCellClickTypeLike,
    JHVideoTableViewCellClickTypeReporter,
    JHVideoTableViewCellClickTypeCommentList,
    JHVideoTableViewCellClickTypeHeader,
    JHVideoTableViewCellClickTypeBackView,

};
NS_ASSUME_NONNULL_BEGIN
@interface JHVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *trueBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *sayWhatBtn;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *coverImagView;
@property (weak, nonatomic) IBOutlet ZFSliderView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *cellControlView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (copy, nonatomic) JHActionBlock clickblock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerToBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlToBottomHeight;

@property (nonatomic, strong) JHLodingImageView *loadingView;

@property(nonatomic,strong) AppraisalDetailMode *model;

- (void)refreshAnimation;
@end

NS_ASSUME_NONNULL_END
