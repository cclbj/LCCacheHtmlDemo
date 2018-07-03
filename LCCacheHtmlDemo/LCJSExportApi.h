//
//  LCJSExportApi.h
//  LCCacheHtmlDemo
//
//  Created by lcc on 2018/6/29.
//  Copyright © 2018年 come.lcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSExportDelegate<JSExport>

- (void)requestData;

@end

@interface LCJSExportApi : NSObject<JSExportDelegate>

@property(nonatomic,weak) JSContext *context;


- (void)requestData;

@end
