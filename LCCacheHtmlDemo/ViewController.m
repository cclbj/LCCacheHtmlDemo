//
//  ViewController.m
//  LCCacheHtmlDemo
//
//  Created by lcc on 2018/6/28.
//  Copyright © 2018年 come.lcc. All rights reserved.
//

#import "ViewController.h"
#import "LCCacheTempateVC.h"

static NSString * const cellID = @"pushID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString *sourceCopyStr;

@property (nonatomic,strong) NSString *sourceStr;

@end

@implementation ViewController{
    NSArray *_pushTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"webView 优化相关";
    
    self.sourceStr = @"hhhhh";
    self.sourceCopyStr = self.sourceStr;
    self.sourceStr = @"aaaa";
    
    NSLog(@"sourceStr:%@ sourceCopyStr:%@",self.sourceStr,self.sourceCopyStr);
    
    NSLog(@"sourceStr:%p sourceCopyStr:%p",self.sourceStr,self.sourceCopyStr);
    
    
    
    [self creatView];
    
}

- (void)creatView{
    
    _pushTitleArray = @[@"本地缓存模板实例"];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

#pragma -mark- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _pushTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = _pushTitleArray[indexPath.row];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LCCacheTempateVC *vc = [LCCacheTempateVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
