//
//  JHCustomizeAddProgramPictsTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddProgramPictsTableViewCell.h"
#import "JHImagePickerPublishManager.h"
#import "JHSQCustomizeProgramAssetsView.h"
#import "JHSQPublishVideoView.h"
#import "UIButton+ImageTitleSpacing.h"


@interface JHCustomizeAddProgramPictsTableViewCell ()
@property (nonatomic, strong) UILabel                        *nameLabel;
@property (nonatomic, strong) JHSQCustomizeProgramAssetsView *assetsView;
@property (nonatomic, strong) UIButton                       *addBtn;
@end

@implementation JHCustomizeAddProgramPictsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (CGFloat)itemWidth {
    return (ScreenW - 10.f*5 - 10.f*2)/4.f;
}

/// 图片View
- (JHSQCustomizeProgramAssetsView *)assetsView {
    if(!_assetsView) {
        _assetsView = [JHSQCustomizeProgramAssetsView new];
        _assetsView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _assetsView;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    
    self.contentView.layer.cornerRadius = 8.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;

    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text          = @"设计稿";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.width.mas_equalTo(60.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"customize_addProgramm_next"] forState:UIControlStateNormal];
    _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(44.f);
        make.height.mas_equalTo(17.f);
    }];
    [_addBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5.];
    
    
    [self.contentView addSubview:self.assetsView];
    [self.assetsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.height.mas_greaterThanOrEqualTo([self itemWidth]);
        make.height.mas_lessThanOrEqualTo([self itemWidth]*2 + 10.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    @weakify(self);
    self.assetsView.addAlbumBlock = ^(BOOL isImage) {
        @strongify(self);
        if (self.addBlock) {
            self.addBlock(isImage);
        }
    };
    
    self.assetsView.deleteActionBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.deleteBlock) {
            self.deleteBlock(index);
        }
    };
}

- (void)addBtnAction:(UIButton *)sender {
    if (self.assetsView.dataArray.count >0) {
        JHAlbumPickerModel *model = self.assetsView.dataArray[0];
        if (model.isVideo) {
            if (self.addBlock) {
                self.addBlock(YES);
            }
        } else {
            if (self.addBlock) {
                self.addBlock(NO);
            }
        }
    } else {
        if (self.addBlock) {
            self.addBlock(NO);
        }
    }
}

- (void)setViewModel:(id)viewModel {
    NSMutableArray<JHAlbumPickerModel *> *dataArray = viewModel;
    self.assetsView.dataArray = dataArray;
    if (dataArray && dataArray.count >0) {
        NSInteger index = 1;
        JHAlbumPickerModel *model = self.assetsView.dataArray[0];
        if (!model.isVideo) {
            if (self.assetsView.dataArray.count>=3) {
                index = 2;
            }
        } else {
            if (self.assetsView.dataArray.count>3) {
                index = 2;
            }
        }
        CGFloat space = index>1?(index - 1):0.f;
        [self.assetsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([self itemWidth]*(index) + 10.f*space);
        }];
        if (self.pictsHasValue) {
            self.pictsHasValue(YES);
        }
    } else {
        if (self.pictsHasValue) {
            self.pictsHasValue(NO);
        }
    }
}





@end
