//
//  JHNewShopUserCommentViewModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopUserCommentViewModel.h"
#import "JHNewShopDetailBusiness.h"
#import <SVProgressHUD.h>

@interface JHNewShopUserCommentViewModel ()
@property (nonatomic, assign) NSUInteger pageSize;
@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isSelectedTag;

@end

@implementation JHNewShopUserCommentViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.pageSize = 20;
    self.pageNum = 1;
    @weakify(self)
    [self.shopUserCommentCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [self constructData:x];
        }else{
            [self.errorRefreshSubject sendNext:@YES];
        }
    }];
    

}
- (void)constructData:(id)data {
    RequestModel *model = (RequestModel *)data;
    self.userCommentModel = [JHNewShopUserCommentModel mj_objectWithKeyValues:model.data];

    if (self.isRefresh) {
        [self.commentDataArray removeAllObjects];
        [self.commentDataArray addObjectsFromArray:self.userCommentModel.commentList];
        if (self.isSelectedTag) {//不需要更新tag标签
            [self.updateShopSubject sendNext:@NO];
        }else{
            [self.updateShopSubject sendNext:@YES];
        }
    }else{
        [self.commentDataArray addObjectsFromArray:self.userCommentModel.commentList];
        //刷新列表
        [self.moreShopSubject sendNext:@YES];
        
    }
    //数据加载完了
    if (self.userCommentModel.commentList.count > 0) {
        self.pageNum ++;
    }else{
        if (self.pageNum > 1) {
            [self.noMoreDataSubject sendNext:@YES];
        }
    }
    
}
    
#pragma mark - Lazy

    
- (NSMutableArray *)commentDataArray{
    if (!_commentDataArray) {
        _commentDataArray = [NSMutableArray array];
    }
    return _commentDataArray;
}
- (RACCommand *)shopUserCommentCommand{
    if (!_shopUserCommentCommand) {
        @weakify(self)
        _shopUserCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self)
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                self.isRefresh = [input[@"isRefresh"] boolValue];
                self.isSelectedTag = [input[@"isSelectedTag"] boolValue];
                if (self.isRefresh) {
                    self.pageNum = 1;
                }
                NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
                requestDic[@"sellerId"] = input[@"sellerId"];
                requestDic[@"tagCode"] = input[@"tagCode"];
                requestDic[@"pageSize"] = @(self.pageSize);
                requestDic[@"pageNo"] = @(self.pageNum);
                [JHNewShopDetailBusiness requestShopUserCommentWithParams:requestDic Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                    if (!error ) {
                        [subscriber sendNext:respondObject];
                    }else{
                        [subscriber sendNext:nil];
                        JHTOAST(error.localizedDescription);
                    }
                    [subscriber sendCompleted];

                }];
                
                return nil;
            }];
        }];
    }
    return _shopUserCommentCommand;
}


@end
