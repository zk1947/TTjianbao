//
//  JHCustomerDescCommentPictTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescCommentPictTableViewCell.h"
#import "JHProcessPicOrVideoCollectionViewCell.h"
#import "JHCustomerDescInProcessModel.h"
#import "JHCustomerDescInProcessModel.h"
#import "PPStickerDataManager.h"

@interface JHCustomerDescCommentPictTableViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel          *userNameLabel;
//@property (nonatomic, strong) UILabel          *userSpeakLabel;
@property (nonatomic, strong) UILabel          *timeLabel;
@property (nonatomic, strong) UICollectionView *cdcpCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, strong) NSMutableArray   *imgDataArray; /// UIImage 数组

@end

@implementation JHCustomerDescCommentPictTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xF9FAF9);
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
    _userNameLabel               = [[UILabel alloc] init];
    _userNameLabel.textColor     = HEXCOLOR(0x333333);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    _userNameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _userNameLabel.numberOfLines = 0;
    [self.contentView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
//    _userSpeakLabel               = [[UILabel alloc] init];
//    _userSpeakLabel.textColor     = HEXCOLOR(0x666666);
//    _userSpeakLabel.textAlignment = NSTextAlignmentLeft;
//    _userSpeakLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
//    _userSpeakLabel.numberOfLines = 2;
//    [self.contentView addSubview:_userSpeakLabel];
//    [_userSpeakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.userNameLabel.mas_right).offset(2.f);
//        make.top.equalTo(self.contentView.mas_top).offset(5.f);
//        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
//        make.height.mas_equalTo(18.f);
//    }];
    
    [self.contentView addSubview:self.cdcpCollectionView];
    [self.cdcpCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(75.f);
    }];
    
    
    
    
    
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.textColor     = HEXCOLOR(0x999999);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font          = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.cdcpCollectionView.mas_bottom).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

- (UICollectionView *)cdcpCollectionView {
    if (!_cdcpCollectionView) {
        UICollectionViewFlowLayout *layout                 = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing                     = 10.f;
        layout.minimumLineSpacing                          = 10.f;
        layout.scrollDirection                             = UICollectionViewScrollDirectionHorizontal;
        _cdcpCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _cdcpCollectionView.backgroundColor                = HEXCOLOR(0xF9FAF9);
        _cdcpCollectionView.delegate                       = self;
        _cdcpCollectionView.dataSource                     = self;
        _cdcpCollectionView.showsHorizontalScrollIndicator = NO;
        _cdcpCollectionView.contentInset                   = UIEdgeInsetsMake(0, 0, 0.f, 15.f);

        [_cdcpCollectionView registerClass:[JHProcessPicOrVideoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHProcessPicOrVideoCollectionViewCell class])];
    }
    return _cdcpCollectionView;
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
    if (self.pictActionBlock) {
        self.pictActionBlock(indexPath.row, self.imgDataArray);
    }
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    return [self calculationTextWidthWith:string font:font CGSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font CGSize:(CGSize)cgsize {
    CGSize size = [string boundingRectWithSize:cgsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeCommentItemVOSModel *model = [JHCustomizeCommentItemVOSModel cast:viewModel];
    if (!model) {
        return;
    }
    
    /// 名称 + 内容
    NSString *nameStr = @"";
    if (isEmpty(model.customerName)) {
        nameStr = @"";
    } else {
        nameStr = [NSString stringWithFormat:@"%@：",model.customerName];
    }
    NSString *contentStr = @"";
    if (isEmpty(model.content)) {
        contentStr = @"";
    } else {
        contentStr = model.content;
    }
    NSString *finalStr = [NSString stringWithFormat:@"%@ %@",nameStr,contentStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:finalStr];
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attStr font:self.userNameLabel.font];
    CGSize titleSize = [self calculationTextWidthWith:finalStr font:[UIFont fontWithName:kFontNormal size:12.f] CGSize:CGSizeMake(ScreenWidth - 36.f - 15.f-20.f, CGFLOAT_MAX)];

    if (titleSize.height >17.f) {
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(titleSize.height);
        }];
    } else {
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17.f);
        }];
    }
    
    self.userNameLabel.attributedText = attStr;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [self.dataSourceArray removeAllObjects];
    [self.imgDataArray removeAllObjects];
    if (model.commentItemImgList.count >0) {
        [self.dataSourceArray addObjectsFromArray:model.commentItemImgList];
        [self.cdcpCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(75.f);
        }];
    } else {
        [self.cdcpCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
    [self.cdcpCollectionView reloadData];
    
    if (isEmpty(model.pushTimeStr)) {
        self.timeLabel.text = @"";
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cdcpCollectionView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    } else {
        self.timeLabel.text = model.pushTimeStr;
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16.f);
        }];
    }
}

@end
