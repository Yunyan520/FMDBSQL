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
    /*
     //错误写法  ❌
     SQLManager * sql_manager = [SQLManager new];
     SQLManager * sql_manager2 = [[SQLManager alloc] init];
     */
    
    [SQLMANAGER_SHARE createRSSTable:@"table_test" complete:nil objs:@"name",@"score", nil];
    
    //    [SQLMANAGER_SHARE createRSSTable:@"table_test" objs:@"name",@"ege", @"score",nil];
    //    [SQLMANAGER_SHARE createRSSTable:@"table_test1" objs:@"name",@"ege", @"score",nil];
    //    [SQLMANAGER_SHARE addObjToTable:@"table_test" objs:@"job",@"23",@"80" ,nil];
    //    [SQLMANAGER_SHARE addObjToTable:@"table_test" objs:@"job1",@"231",@"801" ,nil];
    //    [SQLMANAGER_SHARE addObjToTable:@"table_test" objs:@"job2",@"232",@"802" ,nil];
    //    [SQLMANAGER_SHARE addObjToTable:@"table_test" objs:@"job3",@"233",@"803" ,nil];
    //    [SQLMANAGER_SHARE addObjToTable:@"table_test" objs:@"job4",@"234",@"804" ,nil];
    //    [SQLMANAGER_SHARE addObjToTable:@"table_test" objs:@"job1",@"203",@"880" ,nil];
    //    [SQLMANAGER_SHARE deleteObjInTable:@"table_test" objs:@"job",@"23",@"80", nil];
    //    [SQLMANAGER_SHARE updateObjInTable:@"table_test" whereObj:@"name" newValue:@"jobChange" objs:@"job",@"23",@"80", nil];
    
    //暂不支持 参数为nil
    [SQLMANAGER_SHARE getAllMessage:@"table_test" where:nil value:@"job1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

