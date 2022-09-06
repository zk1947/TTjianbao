//
//  JHTitleHeaderCollectionReusableView.h
//  TTjianbao
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHTitleHeaderCollectionReusableView : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *checkAllBtn;
@property (nonatomic, copy) JHActionBlock checkAllBlock;

@end

@interface JHBlankCornerHeader : UICollectionReusableView

@end

@interface JHCollectionFootor : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;

@end


NS_ASSUME_NONNULL_END
