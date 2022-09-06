//
//  JHPublishTopicRecordTableCell.m
//  TTjianbao
//
//  Created by jesee on 17/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishTopicRecordTableCell.h"
#import "JHPublishTopicModel.h"
#import "JHImage.h"

#define kMarginX 15

@interface JHPublishTopicRecordTableCell () <JHDetailCollectionDelegate>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* deleteButton; //title 后面-右侧-删除
@property (nonatomic, strong) JHCollectionView* collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation JHPublishTopicRecordTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kMarginX);
            make.right.equalTo(self).offset(0 - kMarginX);
            make.top.bottom.equalTo(self);
        }];
        
        //title 内容
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"历史记录";
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        self.titleLabel.font = JHMediumFont(15);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(15);
            make.height.mas_offset(21);
        }];
        
        [self drawSubviews];
    }
    return self;
}

- (void)drawSubviews
{
    //区分collection样式
    self.collectionView = [[JHCollectionView alloc] initWithFrame:CGRectZero type:JHDetailCollectionCellTypeImageTextScroll];
    self.collectionView.delegate = self;
    [self.collectionView makeLayout:CGSizeMake(67, 24) lineSpace:10 itemSpace:10];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5); //cell下补偿5像素,让两种类型cell高度一致
    }];
    //删除
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[JHImage imageScaleSize:CGSizeMake(16, 16) image:@"publish_delete_topic_img"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel).offset(-5);
        make.size.mas_offset(26); //image=18,加大点击区域
    }];
    
}

#pragma mark - update data
- (void)updateData:(NSArray*)senderArray
{
    NSMutableArray *array = [NSMutableArray new];
    for (id model in senderArray) {
        if([model isKindOfClass:[JHPublishTopicDetailModel class]])
        {
            JHPublishTopicRecordModel *m = [JHPublishTopicRecordModel new];
            JHPublishTopicDetailModel* detail = (JHPublishTopicDetailModel*)model;
            m.itemId = detail.itemId;
            m.title = detail.title;
            m.image = detail.image;
            [array addObject:m];
        }
        else if([model isKindOfClass:[JHPublishTopicRecordModel class]])
        {
            JHPublishTopicRecordModel *m = [JHPublishTopicRecordModel new];
            JHPublishTopicRecordModel* record = (JHPublishTopicRecordModel*)model;
            m.itemId = record.itemId;
            m.title = record.title;
            m.image = record.image;
            [array addObject:m];
        }
    }
    
    self.dataArray = array;

    [self.collectionView updateData:array];
}

#pragma mark - JHDetailCollectionDelegate
- (void)clickCollectionItem:(JHPublishTopicRecordModel*)item
{
    if([self.delegate respondsToSelector:@selector(clickCollectionItem:)])
    {
        [self.delegate clickCollectionItem:item];
    }
}

- (void)pressDeleteButton
{
    if(self.deleteTopicBlock)
    {
        self.deleteTopicBlock(nil);
    }
}

@end

@implementation JHPublishTopicRecordTableCellExt

- (void)drawSubviews
{
    //title 内容
    self.titleLabel.text = @"已选话题3/3";
    //区分collection样式:带x号
    self.collectionView = [[JHCollectionView alloc] initWithFrame:CGRectZero type:JHDetailCollectionCellTypeImageTextScrollCross];
    self.collectionView.delegate = self;
    [self.collectionView makeLayout:CGSizeMake(120, 36) lineSpace:10 itemSpace:10];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5); //cell下补偿5像素,让两种类型cell高度一致
    }];
}

#pragma mark - update data
- (void)updateData:(NSArray*)senderArray
{
    NSMutableArray *array = [NSMutableArray new];
    for (id model in senderArray) {
        if([model isKindOfClass:[JHPublishTopicDetailModel class]])
        {
            JHPublishTopicRecordModel *m = [JHPublishTopicRecordModel new];
            JHPublishTopicDetailModel* detail = (JHPublishTopicDetailModel*)model;
            m.itemId = detail.itemId;
            m.title = detail.title;
            m.image = detail.image;
            [array addObject:m];
        }
        else if([model isKindOfClass:[JHPublishTopicRecordModel class]])
        {
            JHPublishTopicRecordModel *m = [JHPublishTopicRecordModel new];
            JHPublishTopicRecordModel* record = (JHPublishTopicRecordModel*)model;
            m.itemId = record.itemId;
            m.title = record.title;
            m.image = record.image;
            [array addObject:m];
        }
    }
    
    self.dataArray = array;

    NSInteger count = [array count];
    self.titleLabel.text = [NSString stringWithFormat: @"已选话题%zd/3", count];
    [self.collectionView updateData:array];
}

@end
