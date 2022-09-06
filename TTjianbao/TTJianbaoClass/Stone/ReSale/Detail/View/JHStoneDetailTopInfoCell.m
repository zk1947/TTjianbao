//
//  JHStoneDetailTopInfoCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailTopInfoCell.h"
#import "TTjianbaoMarcoKeyword.h"
#import "NSString+Common.h"

@interface JHStoneDetailTopInfoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *avatorView;

@end

@implementation JHStoneDetailTopInfoCollectionViewCell

-(void)addSelfSubViews
{
    _avatorView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_avatorView jh_cornerRadius:12.f];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

+(NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

+(CGSize)itemSize
{
    return CGSizeMake(25, 25);
}

@end

@interface JHStoneDetailTopInfoCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImageView *avatorView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *seenLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation JHStoneDetailTopInfoCell

-(void)addSelfSubViews
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _avatorView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    _avatorView.image = [UIImage imageNamed:@"connect_anchorheader"];
    [_avatorView jh_cornerRadius:11.5];
    [_avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13.5);
        make.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(23.f, 23.f));
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:13 textColor:RGB(153, 153, 153) addToSuperView:self.contentView];
    _nameLabel.text = @"卖家：123";
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorView.mas_right).offset(8.f);
        make.centerY.equalTo(self.avatorView);
    }];
    
    _priceLabel = [UILabel jh_labelWithText:@"0.0" font:22 textColor:RGB(255, 66, 0) textAlignment:1 addToSuperView:self.contentView];
    _priceLabel.font = JHDINBoldFont(22);
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorView);
        make.top.equalTo(self.avatorView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    _numberLabel = [UILabel jh_labelWithFont:13 textColor:RGB(51,51,51) addToSuperView:self.contentView];
    _numberLabel.text = @"编号：2837428374";
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(16.f);
        make.centerY.equalTo(self.priceLabel);
    }];
    
    _titleLabel = [UILabel jh_labelWithBoldFont:16 textColor:UIColor.blackColor addToSuperView:self.contentView];
    _titleLabel.text = @"天然和田老玉手镯优质油润白玉手镯天然和田老玉手镯优质油润白玉手镯";
    _titleLabel.numberOfLines = 0;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10.f);
        make.bottom.equalTo(self.contentView).offset(-60.f);
    }];
    
//    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView).offset(-60.f);
//    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(70.f);
        make.bottom.equalTo(self.contentView).offset(-20.f);
        make.right.equalTo(self.contentView).offset(-15.f);
        make.height.mas_equalTo(25);
    }];
    
    _seenLabel = [UILabel jh_labelWithText:@"3000人\n热度" font:12 textColor:RGB(102, 102, 102) textAlignment:1 addToSuperView:self.contentView];
    _seenLabel.numberOfLines = 2;
    _seenLabel.backgroundColor = UIColor.clearColor;
    [_seenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.collectionView);
        make.width.mas_equalTo(53);
    }];
}

#pragma mark ---------------------------- method ----------------------------
-(void)setAvatorUrl:(NSString *)url
               name:(NSString *)name
              price:(NSNumber *)price
             number:(NSString *)number
              title:(NSString *)title
         seekNumber:(NSInteger )seekNumber
              array:(NSMutableArray *)array
         resellFlag:(NSInteger)resellFlag
              
{
    [self.avatorView jh_setAvatorWithUrl:url];
    self.priceLabel.attributedText  = [self getAttributedString:price.floatValue];
    self.nameLabel.text   = [NSString stringWithFormat:@"卖家：%@",[NSString notEmpty:name]];
    if(resellFlag == 1){
        [self.numberLabel setHidden:YES];
    }else{
        [self.numberLabel setHidden:NO];
        self.numberLabel.text = [NSString stringWithFormat:@"编号：%@",number];
    }
    self.titleLabel.text  = title;
    self.seenLabel.text   = [NSString stringWithFormat:@"%lu人\n热度",seekNumber];
    
    self.dataArray = array;
    [self.collectionView reloadData];
    
    if(seekNumber > 0){
        self.collectionView.hidden = NO;
        self.seenLabel.hidden = NO;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-60.f);
        }];
    }
    else
    {
        self.collectionView.hidden = YES;
        self.seenLabel.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-20.f);
        }];
    }
}
#pragma mark ---------------------------- collection ----------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.dataArray.count,(ScreenW - 85.f)/40.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHStoneDetailTopInfoCollectionViewCell *cell = [JHStoneDetailTopInfoCollectionViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if (self.dataArray.count>indexPath.row) {
        [cell.avatorView jh_setAvatorWithUrl:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

#pragma mark ---------------------------- get set ----------------------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = [JHStoneDetailTopInfoCollectionViewCell itemSize];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[JHStoneDetailTopInfoCollectionViewCell class] forCellWithReuseIdentifier:[JHStoneDetailTopInfoCollectionViewCell cellIdentifier]];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}

-(NSMutableAttributedString *)getAttributedString:(CGFloat)price
{
//    NSString *string = [NSString stringWithFormat:@"￥%@",@((NSInteger)price)];
    NSString *string = [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(16), NSForegroundColorAttributeName: RGB(51, 51, 51)}];

    [attributedString addAttributes:@{NSForegroundColorAttributeName: RGB(255, 66, 0)} range:NSMakeRange(0, 1)];
    
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(22), NSForegroundColorAttributeName:RGB(255, 66, 0)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}

@end
