//
//  JHMallCategoryTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallCategoryTableCell.h"
#import "JHMallCategoryCollectionCell.h"
#import "JHMallModel.h"
#import "TTjianbao.h"
#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"

@interface JHMallCategoryTableCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation JHMallCategoryTableCell

+ (CGFloat)viewHeight {
//    return [JHMallCategoryCollectionCell viewSize].height*2+12.f;
    return [JHMallCategoryCollectionCell viewSize].height;
}

- (void)setCategoryInfos:(NSArray <JHMallCategoryModel *>*)categoryInfos {
    if (!categoryInfos) {
        return;
    }
    _categoryInfos = categoryInfos;
    [self.collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.contentView addSubview:_collectionView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[JHMallCategoryCollectionCell class] forCellWithReuseIdentifier:@"JHMallCategoryCollectionCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        ///尽量不要修改间距 ！！！！！ UI确认完之后的
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 5.f, 0, 5.f));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryInfos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHMallCategoryCollectionCell" forIndexPath:indexPath];
    cell.cateModel = self.categoryInfos[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [JHMallCategoryCollectionCell viewSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoryInfos.count > 0) {
        JHMallCategoryModel *model = self.categoryInfos[indexPath.item];
        
        NSDictionary *dic = @{
            @"position":@(indexPath.item),
            @"topicId":model.operationSubjectId,
            @"play_name":NONNULL_STR(model.name)
        };
        [JHGrowingIO trackEventId:JHTrackMallSpecialTopicClick variables:dic];
        
        NSDictionary *dic2 = @{
            @"page_position":@"直播购物",
            @"model_type":@"金刚位",
            @"icon_name":NONNULL_STR(model.name)
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"zbgwIconClick" params:dic2 type:JHStatisticsTypeSensors];
        
        
        if (model.targetModel) {
            [JHRootController toNativeVC:model.targetModel.vc withParam:model.targetModel.params from:JHFromHomeSourceBuy];

        }
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
