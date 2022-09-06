//
//  JHCustomerAddCommentPicsTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerAddCommentPicsTableViewCell.h"
#import "JHImagePickerPublishManager.h"
#import "JHSQCustomizeCommentAssetsView.h"
#import "JHSQPublishVideoView.h"

@interface JHCustomerAddCommentPicsTableViewCell ()
@property (nonatomic, strong) JHSQCustomizeCommentAssetsView *assetsView;
@end

@implementation JHCustomerAddCommentPicsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self setupImagesView];
}

// 图片View
- (JHSQCustomizeCommentAssetsView *)assetsView {
    if(!_assetsView) {
        _assetsView = [JHSQCustomizeCommentAssetsView new];
        _assetsView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _assetsView;
}

- (CGFloat)itemWidth {
    return (ScreenW - 10.f*2 - 5.f*2)/3.f;
}

- (void)setupImagesView {
    [self.contentView addSubview:self.assetsView];
    [self.assetsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.height.mas_greaterThanOrEqualTo([self itemWidth] + 10.f + 10.f);
        make.height.mas_lessThanOrEqualTo([self itemWidth]*3 + 10.f + 10.f + 5.f*2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
    
    @weakify(self);
    _assetsView.addAlbumBlock = ^{
        @strongify(self);
        if (self.addBlock) {
            self.addBlock();
        }
    };
    
    _assetsView.deleteActionBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.deleteBlock) {
            self.deleteBlock(index);
        }
    };
}

- (void)setViewModel:(id)viewModel {
    NSMutableArray<JHAlbumPickerModel *> *dataArray = viewModel;
    if (dataArray && dataArray.count >0) {
        self.assetsView.dataArray = dataArray;
        NSInteger index = 1;
        if (self.assetsView.dataArray.count>2) {
            index = 2;
        }
        if (self.assetsView.dataArray.count>5) {
            index = 3;
        }
        CGFloat space = index>1?(index - 1):0.f;
        [self.assetsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self itemWidth]*(index) + 10.f + 10.f + 5.f*space);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
        }];
    }
}


@end
