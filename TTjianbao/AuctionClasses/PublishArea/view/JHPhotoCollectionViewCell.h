//
//  JHPhotoCollectionViewCell.h
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (nonatomic, assign) BOOL showVideoBt;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (copy, nonatomic) JHActionBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END
