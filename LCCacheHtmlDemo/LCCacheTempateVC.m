//
//  LCCacheTempateVC.m
//  LCCacheHtmlDemo
//
//  Created by lcc on 2018/6/28.
//  Copyright © 2018年 come.lcc. All rights reserved.
//

#import "LCCacheTempateVC.h"
#import "LCJSExportApi.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface LCCacheTempateVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) JSContext *jsContext;

@end

@implementation LCCacheTempateVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatView];
}

- (void)creatView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [UIWebView new];
    _webView.frame = self.view.bounds;
    _webView.delegate = self;
    
    //注入 js
    [self fillJsExportMethod];
    
    [self.view addSubview:self.webView];

    
    //加载线上资源
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"gc://news.html"]];
    
    [self.webView loadRequest:request];
}

- (void)fillJsExportMethod{
    
    //获取该UIWebview的javascript上下文
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    LCJSExportApi *JsObjct = [LCJSExportApi new];
    JsObjct.context = self.jsContext;
    
    [self.jsContext setObject:JsObjct forKeyedSubscript:@"fastConnect"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
