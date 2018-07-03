//
//  LCJSExportApi.m
//  LCCacheHtmlDemo
//
//  Created by lcc on 2018/6/29.
//  Copyright © 2018年 come.lcc. All rights reserved.
//

#import "LCJSExportApi.h"

@implementation LCJSExportApi

- (void)transToRespnose:(NSArray *)array{
    
    [self.context[@"returnData"] callWithArguments:array];
};

- (void)requestData{
    
    NSLog(@"网络请求");
    
    //保存当前的线程
    NSThread *currentThread = [NSThread currentThread];
    //模拟网络请求
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            NSString *path = [[NSBundle mainBundle] pathForResource:@"response" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSString *title = dataDict[@"title"];
            NSString *content = dataDict[@"content"];
            
            //由于网络请求是异步请求，在获取到数据之后放在之前的线程中进行数据的回传
            [self performSelector:@selector(transToRespnose:) onThread:currentThread withObject:@[title,content] waitUntilDone:NO];
            
        });
       
    });
    
    
    
}
                   
                   

@end
