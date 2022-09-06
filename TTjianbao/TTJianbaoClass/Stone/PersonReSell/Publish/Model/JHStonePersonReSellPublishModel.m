//
//  JHStonePersonReSellPublishModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStonePersonReSellPublishModel.h"
#import "SVProgressHUD.h"

@implementation JHStonePersonReSellPublishMediaModel

@end


@implementation JHStonePersonReSellPublishModel

-(NSMutableArray<JHStonePersonReSellPublishMediaModel *> *)urlList{
    if(!_urlList){
        _urlList = [NSMutableArray arrayWithCapacity:7];
    }
    return _urlList;
}

@end
