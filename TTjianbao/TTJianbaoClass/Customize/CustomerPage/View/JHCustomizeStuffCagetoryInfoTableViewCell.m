//
//  JHCustomizeStuffCagetoryInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeStuffCagetoryInfoTableViewCell.h"
#import "JHLiveRoomModel.h"

@interface JHCustomizeStuffCagetoryInfoCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *tagLabel;
- (void)setViewModel:(id)viewModel;
@end

@implementation JHCustomizeStuffCagetoryInfoCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor                 = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor     = HEXCOLOR(0xffffff);
    self.contentView.layer.borderWidth   = 0.5f;
    self.contentView.layer.borderColor   = HEXCOLOR(0xC8A470).CGColor;
    
    self.contentView.layer.cornerRadius  = 2.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius              = 2.f;
    self.layer.masksToBounds             = YES;
    
    _tagLabel           = [[UILabel alloc] init];
    _tagLabel.textColor = HEXCOLOR(0xC8A470);
    _tagLabel.font      = [UIFont fontWithName:kFontNormal size:11.f];
    [self.contentView addSubview:_tagLabel];
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5.f, 10.f, 5.f, 10.f));
        make.left.equalTo(self.contentView.mas_left).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-5.f);
        make.top.equalTo(self.contentView.mas_top).offset(3.f);
        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-3.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHCustomerMaterialsInfo *infoModel = [JHCustomerMaterialsInfo cast:viewModel];
    if (infoModel) {
        if (isEmpty(infoModel.name)) {
            self.tagLabel.text = @"";
            [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        } else {
            self.tagLabel.text = NONNULL_STR(infoModel.name);
            [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(5.f);
                make.height.mas_equalTo(16.f);
            }];
        }
    } else {
        self.tagLabel.text = @"";
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
    
}

@end

@interface JHCustomizeStuffCagetoryInfoTableViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *tagCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@end

@implementation JHCustomizeStuffCagetoryInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)setupViews {
    UICollectionViewFlowLayout *layout               = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing                   = 10.f;
    layout.minimumLineSpacing                        = 10.f;
    layout.scrollDirection                           = UICollectionViewScrollDirectionHorizontal;
    /// layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
    layout.estimatedItemSize                         = CGSizeMake(20.f, 0);
    UICollectionView *tagCollectionView              = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    tagCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
    tagCollectionView.delegate                       = self;
    tagCollectionView.dataSource                     = self;
    tagCollectionView.showsHorizontalScrollIndicator = NO;
    tagCollectionView.contentInset                   = UIEdgeInsetsMake(0, 15.f, 0.f, 0.f);
    [self.contentView addSubview:tagCollectionView];
    self.tagCollectionView                           = tagCollectionView;
    
    [tagCollectionView registerClass:[JHCustomizeStuffCagetoryInfoCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeStuffCagetoryInfoCollectionCell class])];
    
    [tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeStuffCagetoryInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeStuffCagetoryInfoCollectionCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (void)setViewModel:(id)viewModel {
    JHLiveRoomModel *model = [JHLiveRoomModel cast:viewModel];
    [self.dataSourceArray removeAllObjects];
    if (model) {
        [self.dataSourceArray addObjectsFromArray:model.materials];
    }
    [self.tagCollectionView reloadData];
}


@end
