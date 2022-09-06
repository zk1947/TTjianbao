//
//  JHGoodManagerFilterBusiness.m
//  TTjianbao
//
//  Created by user on 2021/8/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerFilterBusiness.h"

@implementation JHGoodManagerFilterBusiness




+ (NSArray *)channelFilterDataSourceArray {
    NSArray *aaa =  @[
             @{
            @"title":@"全部"
        },
             @{
            @"title":@"一级0",
            @"data":@[
                     @{
                    @"title":@"二级0",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                },
                     @{
                    @"title":@"二级1",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                },
                     @{
                    @"title":@"二级2",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                },
                     @{
                    @"title":@"二级3",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                }
            ]
        },
             @{
            @"title":@"一级1",
            @"data":@[
                     @{
                    @"title":@"二级0",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                },
                     @{
                    @"title":@"二级1",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                },
                     @{
                    @"title":@"二级2",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                },
                     @{
                    @"title":@"二级3",
                    @"data":@[
                             @{
                            @"title":@"三级0"
                        },
                             @{
                            @"title":@"三级1"
                        },
                             @{
                            @"title":@"三级2"
                        },
                             @{
                            @"title":@"三级3"
                        }
                    ]
                }
            ]
        }
    ];
    return aaa;
}


+ (void)getChannelFilterSuccessBlock:(succeedBlock)success
                        failureBlock:(failureBlock)failure {
    NSDictionary *dict = @{
        //业务线类型(商城-MALL,直播-LIVE,回收-RECYCLE)【必须】"
        @"businessLineType":@"MALL"
    };
    NSString *url = FILE_BASE_STRING(@"/api/mall/backCate/listTreeByContract");
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (success) {
            success(respondObject);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (failure) {
            failure(respondObject);
        }
    }];
}


@end
