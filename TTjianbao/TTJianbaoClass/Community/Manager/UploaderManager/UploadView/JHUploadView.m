//
//  JHUploadView.m
//  TTjianbao
//
//  Created by apple on 2019/10/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUploadView.h"
#import "JHUploadViewCell.h"
#import "JHUploadManager.h"
#import <YDCategoryKit/YDCategoryKit.h>

@interface JHUploadView () <UITableViewDelegate, UITableViewDataSource, JHUploadViewCellDelegate>
{
    Class recordClass;
}
@property (nonatomic, strong) UITableView *uploadTableView;
@property (nonatomic, copy) NSArray *uploadImageArray;

@end


@implementation JHUploadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self  initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backgroundColor = [UIColor colorWithHexStr:@"f7f7f7"];
    UITableView *tableView = ({
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[JHUploadViewCell class] forCellReuseIdentifier:@"JHUploadViewCell"];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.separatorColor = [UIColor colorWithHexStr:@"f7f7f7"];
        tableView.scrollEnabled = NO;
        tableView;
    });
    self.uploadTableView = tableView;
    [self addSubview:tableView];
    [self.uploadTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@2);
        make.bottom.equalTo(self);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.uploadImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"JHUploadViewCell";
    JHUploadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.uploadImageArray.count) {
        JHArticleItemModel *model = self.uploadImageArray[indexPath.row];
        cell.indexPath = indexPath;
        cell.article = model;
        cell.delegate = self;
        ///如果状态为中断 则显示取消和重新上传按钮
        BOOL isShow = (model.uploadStatus == JHArticleUploadStatusInterrupt);
        [cell setIsShowReload:isShow];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

///刷新uploadView界面
- (void)reloadData {
    DDLogInfo(@"&&&& 刷新列表数据 &&&&&");
    self.uploadImageArray = [JHUploadManager shareInstance].articleArray;
    recordClass = object_getClass(_uploadImageArray);//old
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.uploadTableView reloadData];
        DDLogInfo(@"&&&& 更新界面 &&&&&");
        NSInteger number = self.uploadImageArray.count;
        if (number > 5) {
            self.uploadTableView.scrollEnabled = YES;
            number = 5;
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(number * 50 + 2));
        }];
        [self.uploadTableView reloadData];
    });
}

- (NSArray *)uploadImageArray
{
    Class arrayClass = object_getClass(_uploadImageArray);//new
    if(recordClass != arrayClass)
        return nil;

    return _uploadImageArray;
}

#pragma mark -  JHUploadViewCellDelegate 方法
///重新上传
- (void)reUpload:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(uploadView:reUpload:)]) {
        [self.delegate uploadView:self reUpload:indexPath];
    }
}
///取消上传
- (void)cancelUpload:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(uploadView:cancelUpload:)]) {
        [self.delegate uploadView:self cancelUpload:indexPath];
    }
}

#pragma mark - lazy loading


@end

