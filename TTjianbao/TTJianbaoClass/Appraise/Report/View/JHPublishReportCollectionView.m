//
//  JHPublishReportCollectionView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportCollectionView.h"
#import "JHBaseListView.h"
#import "JHPublishReportModel.h"

@interface JHPublishReportCollectionCell : JHBaseCollectionViewCell

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UIView *bgView;

@end

@implementation JHPublishReportCollectionCell

- (void)addSelfSubViews
{
    _bgView = [UIView jh_viewWithColor:RGB(245, 245, 245) addToSuperview:self.contentView];
    [_bgView jh_cornerRadius:14];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _nameLabel = [UILabel jh_labelWithFont:13 textColor:RGB102102102 textAlignment:1 addToSuperView:self.contentView];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 6, 0, 6));
    }];
}

+ (CGSize)itemSize {
    return CGSizeMake(78.f , 28.0);
}

- (void)setSelected:(BOOL)selected {
    self.bgView.backgroundColor = selected ? RGB(252, 236, 157) : RGB(245, 245, 245);
    self.nameLabel.textColor = selected ? RGB(34, 34, 34) : RGB102102102;
}

//-(void)setModel:(JHLoginSelectLabelModel *)model
//{
//    if (model) {
//        _model = model;
//        _titleLabel.text = _model.label;
//        _jhImageView.image = _model.isSelected ? JHIMAGENAMED(APP_RED_IMAGE) : JHIMAGENAMED(APP_BLACK_IMAGE);
//    }
//}


@end

@interface JHPublishReportCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation JHPublishReportCollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(IS_ARRAY(self.recommendArray) && self.recommendArray.count > 0) {
        return self.recommendArray.count;
    }
    else if(IS_ARRAY(self.cateArray) && self.cateArray.count > 0) {
        return self.cateArray.count;
    }
    else if(self.catePropertyModel && IS_ARRAY(self.catePropertyModel.fieldValues)) {
        return self.catePropertyModel.fieldValues.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPublishReportCollectionCell *cell = [JHPublishReportCollectionCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if(IS_ARRAY(self.recommendArray) && self.recommendArray.count > 0) {
        JHReportRecommendLabelModel *model = self.recommendArray[indexPath.item];
        cell.nameLabel.text = model.label;
        cell.selected = model.selected;
    }
    else if(IS_ARRAY(self.cateArray) && self.cateArray.count > 0) {
        JHReportCateModel *model = self.cateArray[indexPath.item];
        cell.nameLabel.text = model.name;
        cell.selected = model.selected;
    }
    else if(self.catePropertyModel && IS_ARRAY(self.catePropertyModel.fieldValues)) {
        NSString *oldName = self.catePropertyModel.selectValue;
        NSString *currentName = self.catePropertyModel.fieldValues[indexPath.item];
        if(IS_STRING(oldName) && IS_STRING(currentName) && [oldName isEqualToString:currentName]) {
            cell.selected = YES;
        }
        else {
            cell.selected = NO;
        }
        cell.nameLabel.text = self.catePropertyModel.fieldValues[indexPath.item];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_ARRAY(self.recommendArray) && self.recommendArray.count > 0) {
        
        JHReportRecommendLabelModel *model = self.recommendArray[indexPath.item];
        for (JHReportRecommendLabelModel *m in self.recommendArray) {
            if(m.selected){
                m.selected = NO;
            }
        }
        model.selected = YES;
    }
    else if(IS_ARRAY(self.cateArray) && self.cateArray.count > 0) {
        JHReportCateModel *model = self.cateArray[indexPath.row];
        for (JHReportCateModel *m in self.cateArray) {
            if(m.selected){
                m.selected = NO;
            }
        }
        model.selected = YES;
    }
    else if(self.catePropertyModel && IS_ARRAY(self.catePropertyModel.fieldValues)) {
        self.catePropertyModel.selectValue = self.catePropertyModel.fieldValues[indexPath.item];
    }
    [self.collectionView reloadData];
    
    if(self.selectBlock) {
        self.selectBlock(indexPath.item);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        if(_recommendArray) {
            NSInteger width = (ScreenW - 60) / 4.f;
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            layout.itemSize = CGSizeMake(width, 28);
        }
        else {
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(72, 28);
        }
        
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[JHPublishReportCollectionCell class] forCellWithReuseIdentifier:[JHPublishReportCollectionCell cellIdentifier]];
        [self addSubview:collectionView];
        collectionView.backgroundColor = UIColor.whiteColor;
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (void)setRecommendArray:(NSMutableArray<JHReportRecommendLabelModel *> *)recommendArray {
    _recommendArray = recommendArray;
    [self.collectionView reloadData];
}

- (void)setCateArray:(NSMutableArray<JHReportCateModel *> *)cateArray {
    _cateArray = cateArray;
    [self.collectionView reloadData];
}

- (void)setCatePropertyModel:(JHReportCatePropertyModel *)catePropertyModel {
    _catePropertyModel = catePropertyModel;
    [self.collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
