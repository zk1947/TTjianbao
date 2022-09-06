//
//  JHTopicListCCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicListCCell.h"
#import "CTopicModel.h"
#import "YYKit.h"
#import <YDCategoryKit/YDCategoryKit.h>

#define kContentCountLabelWidth ((ScreenWidth - 20 - 24 - 30) / 2 - 40 - 5 - 14 - 5)
static const NSInteger  kColumnCount = 2; //列数
static const CGFloat    kCCellHeight = 40.0; //ccell高度
static const CGFloat    kMarginX = 5.0; //横向间距
//static const CGFloat    kMarginY = 10.0; //纵向的间距

@interface JHTopicListCCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentCountLabel;
@property (nonatomic, strong) UIImageView *imgTagView; //热门标签

@end


@implementation JHTopicListCCell

+ (CGSize)ccellSize {
    CGFloat itemWidth = (ScreenWidth - 30 - kMarginX*(kColumnCount - 1)) / kColumnCount;
    return CGSizeMake(itemWidth, kCCellHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!_imgView) {
            _imgView = [UIImageView new];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            _imgView.clipsToBounds = YES;
            _imgView.layer.cornerRadius = 2.0;
            [self.contentView addSubview:_imgView];
        }
        
        if (!_titleLabel) {
            _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:13.0] textColor:kColor333];
            [self.contentView addSubview:_titleLabel];
        }
        
        if (!_contentCountLabel) {
            _contentCountLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10.0] textColor:kColor999];
            [self.contentView addSubview:_contentCountLabel];
        }
        
        if (!_imgTagView) {
            _imgTagView = [UIImageView new];
            _imgTagView.contentMode = UIViewContentModeScaleAspectFill;
            _imgTagView.clipsToBounds = YES;
            [self.contentView addSubview:_imgTagView];
        }
        
        //布局
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imgView);
            make.left.equalTo(_imgView.mas_right).offset(5.0);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo([[self class] ccellSize].height / 2);
        }];
        
        [_contentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom);
            make.left.equalTo(_titleLabel);
            make.width.lessThanOrEqualTo(@(kContentCountLabelWidth));
            make.height.mas_equalTo([[self class] ccellSize].height / 2);
        }];
        
        [_imgTagView setHidden:YES];
        [_imgTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentCountLabel);
            make.left.mas_equalTo(self.contentCountLabel.mas_right).offset(5);
            make.height.width.mas_equalTo(14);
        }];
        
    }
    return self;
}

- (void)setCurData:(CTopicData *)curData {
    if (!curData) return;
    _curData = curData;
    [_imgView jhSetImageWithURL:[NSURL URLWithString:curData.preview_image]
                              placeholder:[UIImage imageNamed:@"topic_list_icon_normal"]];
    _titleLabel.text = [NSString stringWithFormat:@"# %@", curData.title];
    _contentCountLabel.text = curData.content;
    if([curData.tag_url length] > 0 && curData.tag_type > JHTopicTagTypeDefault && curData.tag_type < JHTopicTagTypeCount)
    {
        [_imgTagView setHidden:NO];
        [_imgTagView jhSetImageWithURL:[NSURL URLWithString:curData.tag_url]];
        if(curData.tag_type == JHTopicTagTypeRecommand || curData.tag_type == JHTopicTagTypeAward)
        {
            [_imgTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(24);
            }];
        }
        else
        {
            [_imgTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(14);
            }];
        }
    }
    else
    {
        [_imgTagView setHidden:YES];
//        [_imgTagView setImage:[UIImage imageNamed:@"discover_topic_icon_hot"]];
    }
}

@end
