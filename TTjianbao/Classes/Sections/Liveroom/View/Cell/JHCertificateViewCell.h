//
//  JHCertificateViewCell.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCertificateViewCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

NS_ASSUME_NONNULL_END
