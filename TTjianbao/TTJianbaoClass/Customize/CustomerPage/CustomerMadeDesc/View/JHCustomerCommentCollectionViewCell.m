//
//  JHCustomerCommentCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCommentCollectionViewCell.h"
#import "JHProcessPicOrVideoCollectionViewCell.h"
#import "JHCustomerDescCommentView.h"
#import "JHCustomerDescInProcessModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "UIButton+ImageTitleSpacing.h"
#import "PPStickerDataManager.h"

@interface JHCustomerCommentCollectionViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView               *timeImageView;
@property (nonatomic, strong) UILabel                   *timeLabel;
@property (nonatomic, strong) UIButton                  *supplementBtn;/// 补充
@property (nonatomic, strong) UIImageView               *customerIconImageView;
@property (nonatomic, strong) UILabel                   *customerTitleLabel;
@property (nonatomic, strong) UIView                    *lineView;

@property (nonatomic, strong) UILabel                   *descLabel;
@property (nonatomic, strong) UICollectionView          *customerCollectionView;
@property (nonatomic, strong) NSMutableArray            *dataSourceArray;
@property (nonatomic, strong) JHCustomerDescCommentView *commentView;/// 评论view

@property (nonatomic, strong) NSMutableArray            *imgDataArray; /// UIImage 数组
@end

@implementation JHCustomerCommentCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)imgDataArray {
    if (!_imgDataArray) {
        _imgDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imgDataArray;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    /// 左边分割线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(20.f);
        make.width.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    /// 时间小圆圈
    _timeImageView                     = [[UIImageView alloc] init];
    _timeImageView.layer.cornerRadius  = 7.f;
    _timeImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_timeImageView];
    [_timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lineView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(9.f);
        make.width.height.mas_equalTo(11.f);
    }];
//
//
    /// 时间
    _timeLabel                      = [[UILabel alloc] init];
    _timeLabel.textColor            = HEXCOLOR(0x999999);
    _timeLabel.textAlignment        = NSTextAlignmentLeft;
    _timeLabel.font                 = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeImageView.mas_centerY);
        make.left.equalTo(self.timeImageView.mas_right).offset(10.f);
        make.height.mas_equalTo(16.f);
    }];

    /// 补充按钮
    _supplementBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    [_supplementBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    _supplementBtn.titleLabel.font     = [UIFont fontWithName:kFontNormal size:12.f];
    [_supplementBtn setImage:[UIImage imageNamed:@"icon_authen_edit"] forState:UIControlStateNormal];
    [_supplementBtn setTitle:@"补充" forState:UIControlStateNormal];
//    [_supplementBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.f];
    [_supplementBtn addTarget:self action:@selector(supplementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _supplementBtn.hidden = YES;
    [self.contentView addSubview:_supplementBtn];
    [_supplementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.mas_equalTo(41.f);
        make.height.mas_equalTo(17.f);
    }];

    /// 定制师头像
    _customerIconImageView                     = [[UIImageView alloc] init];
    _customerIconImageView.layer.cornerRadius  = 15.f;
    _customerIconImageView.layer.masksToBounds = YES;
    _customerIconImageView.backgroundColor     = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_customerIconImageView];
    [_customerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImageView.mas_right).offset(10.f);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10.f);
        make.width.height.mas_equalTo(30.f);
    }];

    /// 定制师名称
    _customerTitleLabel                      = [[UILabel alloc] init];
    _customerTitleLabel.textColor            = HEXCOLOR(0x333333);
    _customerTitleLabel.textAlignment        = NSTextAlignmentLeft;
    _customerTitleLabel.font                 = [UIFont fontWithName:kFontNormal size:15.f];
    [self.contentView addSubview:_customerTitleLabel];
    [_customerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.customerIconImageView.mas_centerY);
        make.left.equalTo(self.customerIconImageView.mas_right).offset(10.f);
        make.height.mas_equalTo(21.f);
    }];

    /// 定制详情. 全显示
    _descLabel                      = [[UILabel alloc] init];
    _descLabel.textColor            = HEXCOLOR(0x333333);
    _descLabel.textAlignment        = NSTextAlignmentLeft;
    _descLabel.font                 = [UIFont fontWithName:kFontNormal size:12.f];
    _descLabel.numberOfLines        = 0;
    [_descLabel setPreferredMaxLayoutWidth:ScreenW - 36.f - 15.f];
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customerIconImageView.mas_bottom).offset(5.f);
        make.left.equalTo(self.timeLabel.mas_left);
        make.height.mas_equalTo(36.f);
    }];
    
    
    

    [self.contentView addSubview:self.customerCollectionView];
    [self.customerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customerIconImageView.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.descLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(75.f);
    }];

    /// 回复区
    _commentView = [[JHCustomerDescCommentView alloc] init];
    _commentView.layer.cornerRadius = 8.f;
    _commentView.layer.masksToBounds = YES;
    _commentView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [self.contentView addSubview:_commentView];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customerCollectionView.mas_bottom).offset(10.f);
        make.left.equalTo(self.customerIconImageView.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-13.f);
    }];
    
    @weakify(self);
    _commentView.commentPictsAcitonBlock = ^(NSInteger index, NSArray * _Nonnull imgArr) {
        @strongify(self);
        if (self.commentClickBlock) {
            self.commentClickBlock(index, imgArr);
        }
    };
}

- (UICollectionView *)customerCollectionView {
    if (!_customerCollectionView) {
        UICollectionViewFlowLayout *layout                     = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing                         = 10.f;
        layout.minimumLineSpacing                              = 10.f;
        layout.scrollDirection                                 = UICollectionViewScrollDirectionHorizontal;
        _customerCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _customerCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
        _customerCollectionView.delegate                       = self;
        _customerCollectionView.dataSource                     = self;
        _customerCollectionView.showsHorizontalScrollIndicator = NO;
        _customerCollectionView.contentInset                   = UIEdgeInsetsMake(0, 0, 0.f, 15.f);

        [_customerCollectionView registerClass:[JHProcessPicOrVideoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHProcessPicOrVideoCollectionViewCell class])];
    }
    return _customerCollectionView;
}

- (void)supplementBtnAction:(UIButton *)sender {
    if (self.supplementBtnActionBlock) {
        self.supplementBtnActionBlock();
    }
}

- (void)reloadLineLayerFrame:(JHCusDescInProCommentImgStatus)status {
    
    switch (status) {
        case JHCusDescInProCommentImgStatus_Yellow: {
            self.timeImageView.backgroundColor = HEXCOLOR(0xFEE100);
            self.timeImageView.layer.borderWidth = 0;
            self.timeImageView.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(11.f);
            }];
        }
            break;
        case JHCusDescInProCommentImgStatus_GrayWithoutCenter: {
            self.timeImageView.backgroundColor = HEXCOLOR(0xFFFFFF);
            self.timeImageView.layer.borderWidth = 1.f;
            self.timeImageView.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top);
            }];
        }
            break;

        case JHCusDescInProCommentImgStatus_Gray: {
            self.timeImageView.backgroundColor = HEXCOLOR(0xEEEEEE);
            self.timeImageView.layer.borderWidth = 1.f;
            self.timeImageView.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
            [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHProcessPicOrVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHProcessPicOrVideoCollectionViewCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75.f, 75.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.imgDataArray removeAllObjects];
    for (JHCustomizeCommentPublishImgList *model in self.dataSourceArray) {
        [self.imgDataArray addObject:model];
    }
    if (self.commentClickBlock) {
        self.commentClickBlock(indexPath.row, self.imgDataArray);
    }
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

//- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font cgsize:(CGSize)cgsize {
//    CGSize size = [string boundingRectWithSize:cgsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
//    return size;
//}


- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font cgsize:(CGSize)cgsize {
    CGSize size = [string boundingRectWithSize:cgsize
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}



- (NSInteger)hideLabelLayoutHeight:(NSString *)content withTextFontSize:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;  // 段落高度
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithString:content];
    [attributes addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, content.length)];
    [attributes addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(ScreenW - 36.f - 15.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attSize.height;
}


- (void)setSupplementBtnShow:(BOOL)isShow {
    self.supplementBtn.hidden = !isShow;
}


- (void)setViewModel:(id)viewModel {
    @weakify(self);
    [JHDispatch ui:^{
        @strongify(self);
        JHCustomizeCommentInfoVOModel *model = [JHCustomizeCommentInfoVOModel cast:viewModel];
        if (!model) {
            return;
        }
        /// 时间
        self.timeLabel.text = model.pushTimeStr;

        /// 名称
        NSString *nameStr = @"";
        if (model.customerName.length >8) {
            nameStr = [NSString stringWithFormat:@"%@...",[model.customerName substringWithRange:NSMakeRange(0, 8)]];
        } else {
            nameStr = NONNULL_STR(model.customerName);
        }
        
        /// 名称颜色
        UIColor *publishTypeColor = HEXCOLOR(0x333333);
        if ([model.finishFlag isEqualToString:@"1"]) { /// 已完成
            publishTypeColor = HEXCOLOR(0x333333);
        } else {
            publishTypeColor = HEXCOLOR(0x999999);
        }
        
        NSMutableAttributedString *nameAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",nameStr] attributes:@{
            NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15.f],
            NSForegroundColorAttributeName:HEXCOLOR(0x333333)
        }];

        NSAttributedString *publishTypeAttStr = [[NSAttributedString alloc] initWithString:model.publishType attributes:@{
                NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15.f],
                NSForegroundColorAttributeName:publishTypeColor
        }];
        
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
        [commentString appendAttributedString:nameAttStr];
        [commentString appendAttributedString:publishTypeAttStr];
        self.customerTitleLabel.attributedText = commentString;
        
        
        ///
        [self.customerIconImageView jhSetImageWithURL:[NSURL URLWithString:model.customerImg] placeholder:kDefaultAvatarImage];

        if (isEmpty(model.publishDesc)) {
            self.descLabel.text = @"";
            [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.customerIconImageView.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        } else {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.publishDesc];
            [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attStr font:_descLabel.font];
            
//            CGSize size = [self calculationTextWidthWith:model.publishDesc font:[UIFont fontWithName:kFontNormal size:12.f] cgsize:CGSizeMake(ScreenW - 36.f - 15.f, CGFLOAT_MAX)];
            
            CGFloat sizeHeight = [self hideLabelLayoutHeight:model.publishDesc withTextFontSize:[UIFont fontWithName:kFontNormal size:12.f]];
            
            if (sizeHeight > 18) {
                [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.customerIconImageView.mas_bottom).offset(5.f);
                    make.height.mas_equalTo(sizeHeight);
                }];
            } else {
                [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.customerIconImageView.mas_bottom).offset(5.f);
                    make.height.mas_equalTo(18.f);
                }];
            }
            self.descLabel.attributedText = attStr; /// 发布的内容
        }
        
        [self.dataSourceArray removeAllObjects];
        [self.imgDataArray removeAllObjects];
        if (model.publishImgList.count > 0) {
            [self.dataSourceArray addObjectsFromArray:model.publishImgList];
            [self.customerCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.descLabel.mas_bottom).offset(10.f);
                make.height.mas_equalTo(75.f);
            }];
        } else {
            [self.customerCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.descLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
        [self.customerCollectionView reloadData];
        
        if (model.customizeCommentItemVOS.count >0) {
            [self.commentView setViewModel:model.customizeCommentItemVOS];
            CGFloat height = [self countHeight:model.customizeCommentItemVOS];
            [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.customerCollectionView.mas_bottom).offset(10.f);
                make.height.mas_equalTo(height);
            }];
        } else {
            [self.commentView setViewModel:nil];
            [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.customerCollectionView.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
    }];
}

- (CGFloat)countHeight:(NSArray<JHCustomizeCommentItemVOSModel*> *)array {
    __block CGFloat commentHeight = 0.f;
    [array jh_each:^(JHCustomizeCommentItemVOSModel * _Nonnull item, NSUInteger index) {
        if (!isEmpty(item.content)) {
//            CGSize size = [self calculationTextWidthWith:item.content font:[UIFont fontWithName:kFontNormal size:12.f]];
            CGSize size = [self calculationTextWidthWith:item.content font:[UIFont fontWithName:kFontNormal size:12.f] cgsize:CGSizeMake(ScreenW - 36.f - 15.f -20.f, CGFLOAT_MAX)];
            if (size.height > 17.f) {
                commentHeight = commentHeight + 5.f + size.height + 1;
            } else {
                commentHeight = commentHeight + 5.f + 17.f;
            }
        }
        if (item.commentItemImgList.count > 0) {
            commentHeight = commentHeight + 75.f + 5.f;
        }
        if (!isEmpty(item.pushTimeStr)) {
            commentHeight = commentHeight + 16.f + 5.f + 5.f;
        }
    }];
    commentHeight = commentHeight + 5.f + 5.f; /// tableView 上下距离
    return commentHeight;
}


@end
