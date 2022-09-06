//
//  JHHomeCollectionViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JHHomeCollectionViewCellClickAction)(BOOL isLaud,  NSInteger index);
#import "JHReporterDetailModel.h"
#import "AppraisalVideoRecordMode.h"
@interface JHHomeCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) AppraisalVideoRecordMode* recordMode;
@property(nonatomic,strong) JHReporterDetailModel *reporterDetailModel;
@property(nonatomic,assign) NSInteger cellIndex;
@property(nonatomic,strong) JHHomeCollectionViewCellClickAction cellClick;
@property (strong, nonatomic)  UIImageView *likeImageView;
@property (strong, nonatomic)  UILabel *likeCountLabel;
- (void)beginAnimation:(AppraisalVideoRecordMode*)mode;
+ (CGFloat)heightCellWithModel:(AppraisalVideoRecordMode *)model;
+ (CGFloat)heightCellWithAnchorModel:(JHReporterDetailModel *)model;
@end


