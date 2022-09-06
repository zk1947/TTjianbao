//
//  JHCustomizeFeeInfoTableCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFeeInfoTableCell.h"
#import "JHCustomizeFeeInfoCollectionCell.h"

#define kCollectionCellHeight (6+10+40)

@interface JHCustomizeFeeInfoTableCell () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIImageView* imgHeader; //bg
    UIImageView* imgView;
    UILabel* titleLabel;
}

@property (nonatomic, strong) UILabel*noDataLabel;
@property (nonatomic, strong) UICollectionView* infoCollectionView;
@property (nonatomic, strong) NSArray* dataArray;
@end

@implementation JHCustomizeFeeInfoTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor]; //cell透明,使用imgHeader的圆角
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawAnchorHeaderSubviews];
    }
    return self;
}

- (void)drawAnchorHeaderSubviews
{
    //bg header
    imgHeader = [[UIImageView alloc] init];
    imgHeader.contentMode = UIViewContentModeScaleAspectFill;
    imgHeader.layer.cornerRadius = 8;
    imgHeader.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"room_left_archor_bg"];
    [imgHeader setImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 10, 0) resizingMode:UIImageResizingModeStretch]];
    [self.contentView addSubview:imgHeader];
    [imgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    imgView = [[UIImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"icon_authen_fee"]];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(20);
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = JHMediumFont(16);
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.text = @"定制费用说明";
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.top.equalTo(imgView).offset(-1);
        make.height.mas_equalTo(22);
    }];
    //费用说明
    [self showFeeInfoView];
}

- (UILabel *)noDataLabel
{
    if(!_noDataLabel)
    {
        _noDataLabel = [[UILabel alloc]init];
        _noDataLabel.font = JHFont(13);
        _noDataLabel.textColor = HEXCOLOR(0x666666);
        _noDataLabel.textAlignment = NSTextAlignmentLeft;
//        _noDataLabel.text  = @"暂无定制费用说明~";
    }
    return _noDataLabel;
}

#pragma mark - content view
- (void)showFeeInfoView
{
    [self.infoCollectionView registerClass:[JHCustomizeFeeInfoCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeFeeInfoCollectionCell class])];

    [self.infoCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer"];
    
    [self.contentView addSubview:self.infoCollectionView];
}

- (UICollectionView *)infoCollectionView
{
    if (!_infoCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;// 设置item的大小
        CGFloat itemW = (ScreenWidth-80) / 2 ;
        flowLayout.itemSize = CGSizeMake(itemW, 50);
        // 设置每个分区的 上左下右 的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0 ,0, 10);
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHCustomizeFeeInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeFeeInfoCollectionCell class]) forIndexPath:indexPath];
    
    [cell updateData:self.dataArray[indexPath.item]];
    return cell;
}

#pragma mark - update data
- (void)updateData:(NSArray*)dataArr
{
    [_noDataLabel removeFromSuperview];
    if([dataArr count] > 0)
    {
        self.dataArray = dataArr;
        CGFloat height = (self.dataArray.count/2 + self.dataArray.count%2) * kCollectionCellHeight;
        [self.infoCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(6);
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(self.contentView).offset(-8);
        }];
        [self.infoCollectionView reloadData];
    }
    else
    {
        [self.contentView addSubview:self.noDataLabel];
        [_noDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.height.offset(80);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    }
}

@end
