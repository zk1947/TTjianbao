//
//  JHCustomerMpEditPictsTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerMpEditPictsTableViewCell.h"
#import "JHSQPublishImageView.h"
#import "JHImagePickerPublishManager.h"

@interface JHCustomerMpEditPictsTableViewCell ()
@property (nonatomic, strong) JHSQPublishImageView *imagesView;
@end

@implementation JHCustomerMpEditPictsTableViewCell

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


/// 图片View
- (JHSQPublishImageView *)imagesView {
    if(!_imagesView) {
        _imagesView = [JHSQPublishImageView new];
        _imagesView.backgroundColor = HEXCOLOR(0xffffff);
        _imagesView.customizeNeedThis = YES;
    }
    return _imagesView;
}

- (CGFloat)itemWidth {
    return (ScreenW - 10.f*2 - 5.f*2)/3.f;
}

- (void)setupImagesView {
    [self.contentView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.height.mas_greaterThanOrEqualTo([self itemWidth] + 10.f + 10.f);
        make.height.mas_lessThanOrEqualTo([self itemWidth]*3 + 10.f + 10.f + 5.f*2);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    @weakify(self);
    _imagesView.addAlbumBlock = ^{
        @strongify(self);
        if (self.addBlock) {
            self.addBlock();
        }
    };
    
    _imagesView.deleteActionBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.deleteBlock) {
            self.deleteBlock(index);
        }
    };
}

- (void)setViewModel:(id)viewModel {
    NSMutableArray<JHAlbumPickerModel *> *dataArray = viewModel;
    if (dataArray && dataArray.count >0) {
        self.imagesView.dataArray = dataArray;
        NSInteger index = 1;
        if (self.imagesView.dataArray.count>2) {
            index = 2;
        }
        if (self.imagesView.dataArray.count>5) {
            index = 3;
        }
        CGFloat space = index>1?(index - 1):0.f;
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self itemWidth]*(index) + 10.f + 10.f + 5.f*space);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
        }];
    } else {
        self.imagesView.dataArray = dataArray;
    }
}


@end
