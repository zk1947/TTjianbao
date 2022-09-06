//
//  JHRecycleInfoCagetoryTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/4/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleInfoCagetoryTableViewCell.h"
#define kCollectionCellHeight (6+10+40)
@interface JHRecycleInfoCagetoryCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *nameLabel;
- (void)setViewModel:(NSString *)str;
@end

@implementation JHRecycleInfoCagetoryCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _nameLabel           = [[UILabel alloc] init];
    _nameLabel.textColor = kColor666;
    _nameLabel.font      = [UIFont fontWithName:kFontNormal size:13.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setViewModel:(NSString *)str {
    self.nameLabel.text = NONNULL_STR(str);
}
@end


@interface JHRecycleInfoCagetoryTableViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
//    UIImageView *imgHeader; //bg
//    UIImageView *imgView;
//    UILabel     *titleLabel;
}

@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) UICollectionView *infoCollectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation JHRecycleInfoCagetoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor]; //cell透明,使用imgHeader的圆角
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawAnchorHeaderSubviews];
    }
    return self;
}

- (void)drawAnchorHeaderSubviews {
    //bg header
//    imgHeader = [[UIImageView alloc] init];
//    imgHeader.contentMode = UIViewContentModeScaleAspectFill;
//    imgHeader.layer.cornerRadius = 8;
//    imgHeader.layer.masksToBounds = YES;
//    UIImage *image = [UIImage imageNamed:@"room_left_archor_bg"];
//    [imgHeader setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 10, 0) resizingMode:UIImageResizingModeStretch]];
//    [self.contentView addSubview:imgHeader];
//    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//
//    imgView = [[UIImageView alloc] init];
//    [imgView setImage:[UIImage imageNamed:@"livingRoon_recycle_cagetory"]];
//    [self.contentView addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(10);
//        make.top.equalTo(self.contentView).offset(16);
//        make.size.mas_equalTo(20);
//    }];
//
//    titleLabel = [[UILabel alloc]init];
//    titleLabel.font = JHMediumFont(16);
//    titleLabel.textColor = HEXCOLOR(0x333333);
//    titleLabel.text = @"回收类别";
//    titleLabel.numberOfLines = 0;
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(imgView.mas_right).offset(5);
//        make.top.equalTo(imgView).offset(-1);
//        make.height.mas_equalTo(22);
//    }];
    /// 回收类别
    [self showFeeInfoView];
}

- (void)showFeeInfoView {
    [self.infoCollectionView registerClass:[JHRecycleInfoCagetoryCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecycleInfoCagetoryCollectionCell class])];
    [self.contentView addSubview:self.infoCollectionView];
}

- (UILabel *)noDataLabel {
    if(!_noDataLabel) {
        _noDataLabel = [[UILabel alloc]init];
        _noDataLabel.font = JHFont(13);
        _noDataLabel.textColor = HEXCOLOR(0x333333);
        _noDataLabel.textAlignment = NSTextAlignmentLeft;
        _noDataLabel.text  = @"暂无回收类别~";
    }
    return _noDataLabel;
}

- (UICollectionView *)infoCollectionView {
    if (!_infoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;// 设置item的大小
        CGFloat itemW = (ScreenWidth-40) / 5 ;
        flowLayout.itemSize = CGSizeMake(itemW, 20);
        // 设置每个分区的 上左下右 的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0 ,0, 8);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _infoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _infoCollectionView.delegate = self;
        _infoCollectionView.dataSource = self;
        _infoCollectionView.showsVerticalScrollIndicator = NO;
        _infoCollectionView.showsHorizontalScrollIndicator = NO;
        _infoCollectionView.alwaysBounceVertical = YES;
        _infoCollectionView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _infoCollectionView;
}

#pragma mark - collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleInfoCagetoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecycleInfoCagetoryCollectionCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataArray[indexPath.item]];
    return cell;
}

#pragma mark - update data
- (void)updateData:(NSArray *)dataArr {
    self.dataArray = nil;
    [_noDataLabel removeFromSuperview];
    if ([dataArr count] > 0) {
        self.dataArray = dataArr;
        CGFloat height = 0;
        if (self.dataArray.count >4) {
            height = (self.dataArray.count/4 + self.dataArray.count%4) *25.f;
        } else {
            height = 25.f;
        }
        [self.infoCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(6.f);
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(self.contentView).offset(-16.f);
        }];
        [self.infoCollectionView reloadData];
    } else {
        [self.contentView addSubview:self.noDataLabel];
        [_noDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(6);
            make.height.offset(25);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    }
}

@end
