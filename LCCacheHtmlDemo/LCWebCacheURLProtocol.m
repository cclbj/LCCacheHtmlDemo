//
//  LCWebCacheURLProtocol.m
//  LCCacheHtmlDemo
//
//  Created by lcc on 2018/7/2.
//  Copyright © 2018年 come.lcc. All rights reserved.
//

#import "LCWebCacheURLProtocol.h"

static NSString * const filiterKeyword = @"gc";
static NSString * const replaceKeyword = @"gc://";
static NSString * const dealRequestKey = @"dealRequestKey";

@interface LCWebCacheURLProtocol()<NSURLSessionDelegate>

@property (nonatomic,strong) NSURLSession *session;

@property (nonatomic, strong) NSURLConnection *connection;

@property (atomic, strong) NSMutableData *data;

//是否处于下载模板中
@property (nonatomic, assign) BOOL isDownloadingTemplate;

@end

@implementation LCWebCacheURLProtocol

+ (void)registCacheUrlProtocol{
    
    [self registerClass:[self class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    
    NSString *scheme = request.URL.scheme;
    
    //如果处理过请求，放行
    if ([NSURLProtocol propertyForKey:dealRequestKey inRequest:request]) {
        NSLog(@"已经处理，放行");
        return NO;
    }
    
    //拦截带有特定标识的请求
    if ([scheme isEqualToString:filiterKeyword]) {
        
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    
    return YES;
}

- (void)startLoading{
    
    NSString *scheme = self.request.URL.scheme;

    NSMutableURLRequest *modifityRequest = [self.request mutableCopy];
    NSString *url = modifityRequest.URL.absoluteString;

    //处理需要处理的请求
    if ([scheme isEqualToString:filiterKeyword]) {

        /*** 获取项目中的文件路径 ***/
        NSString  *file = [url lastPathComponent];
        //扩展名
        NSString *suffix = [file pathExtension];
        //文件名字
        NSString *fileName = [file stringByDeletingPathExtension];

        NSString *modifiyPath = [[NSBundle mainBundle] pathForResource:fileName ofType:suffix];

        //判断本地文件是否存在
        BOOL isVaild = [[NSURL fileURLWithPath:modifiyPath] checkResourceIsReachableAndReturnError:nil];

        if (isVaild) {

            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:modifiyPath]];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[NSURL fileURLWithPath:modifiyPath] MIMEType:suffix expectedContentLength:data.length textEncodingName:nil];

            //响应请求者数据
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [self.client URLProtocol:self didLoadData:data];
            [self.client URLProtocolDidFinishLoading:self];

        }

        //文件不存在，加载线上地址
        else{
            
            self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
            NSMutableURLRequest *changeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];


            NSLog(@"modifityURL:%@",changeRequest.URL.description);

            //设置当前处理的请求的标志,防止重复处理请求
            [NSURLProtocol setProperty:@YES
                                forKey:dealRequestKey
                             inRequest:changeRequest];

            NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request];
            [task resume];
            
            /*********** 以下是处理异步下载模板的逻辑（为下次加载当前页面的模板做准备）****/
            /*
            self.isDownloadingTemplate = YES;
            //异步下载模板
            WeakObj(self);
            [GCHtmlTemplateTool updateDetailHtmlStyle:^{
                NSLog(@"下载模板成功");
                selfWeak.isDownloadingTemplate = NO;
            }];
             */
            

        }

    }

    
}

- (void)stopLoading{
    
    [self.session invalidateAndCancel];
    
}

#pragma -mark- NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
    
    self.data = [NSMutableData new];

    
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
 
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (error) {
        
        [self.client URLProtocol:self didFailWithError:error];
    }
    
    else {
        [self.client URLProtocol:self didLoadData:self.data];
        [self.client URLProtocolDidFinishLoading:self];
    }
    
}


@end
