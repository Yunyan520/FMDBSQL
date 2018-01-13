//
//  ViewController.m
//  FMDBSQL
//
//  Created by king on 2018/1/13.
//  Copyright © 2018年 king. All rights reserved.
//

#import "ViewController.h"
#import "SQLManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  SQL];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)SQL {
    [[SQLManager shanredSQLManager] createRSSTable];
    SQLModel *model = [[SQLModel alloc] init];
    model.link = @"link";
    model.name = @"name";
    model.date = @"date";
    model.category = @"category";
    model.imageUrlString = @"imageUrlString";
    [[SQLManager shanredSQLManager] addRSS:model];
    [[SQLManager shanredSQLManager] selectRSS];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
