//
//  JHAlbumSelectView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAlbumSelectView.h"
#import <Photos/PhotosTypes.h>
#import "TZImagePickerController.h"

@interface JHAlbumSelectView ()<UITableViewDataSource, UITableViewDelegate, PHPhotoLibraryChangeObserver>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *albumArr;

@property (nonatomic, copy) void (^selectModelBlock) (TZAlbumModel *model);

@end


@implementation JHAlbumSelectView

- (instancetype)initWithFrame:(CGRect)frame
            allowPickingImage:(BOOL)allowPickingImage
            allowPickingVideo:(BOOL)allowPickingVideo
                        title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        self.allowPickingVideo = allowPickingVideo;
        self.allowPickingImage = allowPickingImage;
        
        UIView *view = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(UI.statusAndNavBarHeight);
        }];
        
        ///线
        [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(view);
            make.height.mas_equalTo(1.f);
        }];
        
        UILabel *titleLabel = [UILabel jh_labelWithFont:18 textColor:RGB515151 addToSuperView:view];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.bottom.equalTo(view);
            make.height.mas_equalTo(UI.navBarHeight);
        }];
        @weakify(self);
        [titleLabel jh_addTapGesture:^{
            @strongify(self);
            [self removeFromSuperview];
        }];
        titleLabel.attributedText = [self showTitleWithString:title];
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews
{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    [self configTableView];
}

- (void)configTableView {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[TZImageManager manager] getAllAlbums:self.allowPickingVideo allowPickingImage:self.allowPickingImage needFetchAssets:NO completion:^(NSArray<TZAlbumModel *> *models) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumArr = [NSMutableArray arrayWithArray:models];

                    [self.tableView reloadData];
            });
        }];
    });
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

-(UITableView *)tableView
{
    if(!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.rowHeight = 75;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = APP_BACKGROUND_COLOR;
        tableView.separatorInset = UIEdgeInsetsMake(0, 76, 0, 0);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerClass:[TZAlbumCell class] forCellReuseIdentifier:@"TZAlbumCell"];
        [self addSubview:tableView];
//        [tableView jh_cornerRadius:12 rectCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight bounds:CGRectMake(0, 0, ScreenW, ScreenH - UI.statusAndNavBarHeight - 34)];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(UI.statusAndNavBarHeight);
            make.bottom.equalTo(self).offset(-54);
        }];
        _tableView = tableView;
    }
    return _tableView;
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configTableView];
    });
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZAlbumCell"];
    cell.model = _albumArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TZAlbumModel *model = _albumArr[indexPath.row];
    if(_selectModelBlock && model)
    {
        _selectModelBlock(model);
        [self removeFromSuperview];
    }
}

- (NSAttributedString *)showTitleWithString:(NSString *)title
{
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage tz_imageNamedFromMyBundle:@"tz_photo_title_icon_2"];
    attach.bounds = CGRectMake(0, 3 , 14, 7);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [textAttrStr appendAttributedString:imgStr];
    
    return textAttrStr;
}

/// type  0-全部    1-图片      2-视频
+ (void)showAlbumSelectViewWithView:(UIView *)view
                  allowPickingImage:(BOOL)allowPickingImage
                  allowPickingVideo:(BOOL)allowPickingVideo
                              title:(NSString *)title
                          dataBlock:(void (^)(TZAlbumModel *model))dataBlock
{
    JHAlbumSelectView *albumView = [[JHAlbumSelectView alloc] initWithFrame:view.bounds allowPickingImage:allowPickingImage allowPickingVideo:allowPickingVideo title:title];
    [view addSubview:albumView];
    albumView.selectModelBlock = dataBlock;
}

@end

