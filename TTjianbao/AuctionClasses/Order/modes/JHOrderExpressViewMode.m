//
//  JHOrderExpressViewMode.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderExpressViewMode.h"
#import "SVProgressHUD.h"
@implementation JHOrderExpressSectionMode
-(CGFloat)headerHeight{
    
    CGFloat height = 0;
    if (self.sectionType == JHExpressSectionSellerSend) {
       
        return 45;
    }
    else if (self.sectionType == JHExpressSectionPlatAppraise) {
        
        return 85;
    }
    else  {
       
        return 80;
    }
    
    return height;
}
@end


@implementation JHOrderExpressViewMode
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)getExpressInfo{
    
    NSString *string = [NSString stringWithFormat:@"/auth/express/query/%@",self.orderId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(string) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        
        self.orderStatusModel = [ExpressOrderStatusModel mj_objectWithKeyValues :respondObject.data[@"expressOrderStatusShowVo"]];
       
        self.orderMlOptHisVos =  [ExpressAppraiseMode mj_objectArrayWithKeyValuesArray:respondObject.data[@"orderMlOptHisVos"]];

        self.platSendExpressVo = [ExpressVo mj_objectWithKeyValues :respondObject.data[@"platSendExpressVo"]];

        [self setupData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message];
        [self setupData];
    }];
    
    [SVProgressHUD show];
    
}
-(void)setupData{
    
    self.sectionList = [NSMutableArray array];
   
    if (self.platSendExpressVo.data.count>0)
    {
        JHOrderExpressSectionMode *mode = [[JHOrderExpressSectionMode alloc ]init];
        mode.sectionType = JHExpressSectionPlatSend;
        [self.sectionList addObject:mode];
    }
    
    if (self.orderMlOptHisVos.count>0)
    {
        JHOrderExpressSectionMode *mode = [[JHOrderExpressSectionMode alloc ]init];
        mode.sectionType = JHExpressSectionPlatAppraise;
        [self.sectionList addObject:mode];
    }
    if (self.orderStatusModel.orderStatusLogVos.count>0) {
        JHOrderExpressSectionMode *mode = [[JHOrderExpressSectionMode alloc ]init];
        mode.sectionType = JHExpressSectionSellerSend;
        [self.sectionList addObject:mode];
    }
    
    // 刷新列表
    [self.refreshTableView sendNext:nil];
    
}
- (RACReplaySubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACReplaySubject subject];
    }
    return _refreshTableView;
}
-(JHExpressStepType)expressStep{
    
    if (self.platSendExpressVo) {
        return JHExpressStepTypePlatSend;
    }
   else if (self.orderMlOptHisVos.count>0) {
        return JHExpressStepTypePlatAppraise;
    }
   else  if (self.orderStatusModel.orderStatusLogVos.count>0){
       return JHExpressStepTypeSellerSend;
   }
    return -1;
}
@end
