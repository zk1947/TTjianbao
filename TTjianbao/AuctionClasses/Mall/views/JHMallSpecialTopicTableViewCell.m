//
//  JHMallSpecialTopicTableViewCell.m
//  TTjianbao
//  卖场首页专题
//  Created by 姜超 on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallSpecialTopicTableViewCell.h"
#import "MallAttentionCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "MBProgressHUD.h"
#import "JHMallSpecialTopicCollectionViewCell.h"

@interface  JHMallSpecialTopicTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)  UICollectionView *collectionView;

@end

@implementation JHMallSpecialTopicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor  clearColor];
        
        UIView *back = [[UIView alloc] init];
//        back.layer.cornerRadius = 4;
//        back.layer.masksToBounds = YES;
//        back.backgroundColor = [CommHelp  toUIColorByStr:@"#ffffff"];
        [self.contentView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.offset(10);
            make.right.offset(-10);
        }];
//        UILabel *label = [[UILabel alloc] init];
//        label.backgroundColor = [CommHelp  toUIColorByStr:@"#ffffff"];
//        label.font = [UIFont fontWithName:kFontMedium size:15];
//        label.text = @"我的关注";
//        label.textColor = kColor333;
//        [back addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self);
//            make.left.offset(10);
//            make.right.offset(-10);
//            make.height.offset(30);
//        }];
        
        [back addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.edges.equalTo(self);
            make.top.equalTo(back);
            make.bottom.equalTo(back);
            make.left.offset(0);
            make.right.offset(0);
        }];

    }
    return self;
}
-(UICollectionView*)collectionView
{
    if (!_collectionView) {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        flowLayout.sectionInset = UIEdgeInsetsMake(0,0, 0,0);
        flowLayout.minimumLineSpacing=0;
        flowLayout.minimumInteritemSpacing=0;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[JHMallSpecialTopicCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallSpecialTopicCollectionViewCell class])];
        
    }
    return _collectionView;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.specialTopicModes.count>10) {
         return 10;
    }
    return self.specialTopicModes.count;
   // return 10.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallSpecialTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallSpecialTopicCollectionViewCell class]) forIndexPath:indexPath];
    cell.specialTopicMode=self.specialTopicModes[indexPath.row];
        return cell;
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW-20)/5, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMallSpecialTopicModel *model = self.specialTopicModes[indexPath.row];
   
    [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:@""];
    NSDictionary *dic = @{
        @"position":model.code,
        @"topicId":model.operationSubjectId,
        @"play_name":NONNULL_STR(model.name)
    };
    [JHGrowingIO trackEventId:JHTrackMallSpecialTopicClick variables:dic];
    
}
-(void)setSpecialTopicModes:(NSMutableArray<JHMallSpecialTopicModel *> *)specialTopicModes{
    
    _specialTopicModes=specialTopicModes;
    [self.collectionView reloadData];
    
}
@end
