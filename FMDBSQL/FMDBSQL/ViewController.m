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
    [[SQLManager shanredSQLManager] createRSSTable:@"table_test" objs:@"name",@"ege", @"score",nil];
//    [[SQLManager shanredSQLManager] createRSSTable:@"table_test1" objs:@"name",@"ege", @"score",nil];
//    [[SQLManager shanredSQLManager] addObjToTable:@"table_test" objs:@"job",@"23",@"80" ,nil];
//    [[SQLManager shanredSQLManager] addObjToTable:@"table_test" objs:@"job1",@"231",@"801" ,nil];
//    [[SQLManager shanredSQLManager] addObjToTable:@"table_test" objs:@"job2",@"232",@"802" ,nil];
//    [[SQLManager shanredSQLManager] addObjToTable:@"table_test" objs:@"job3",@"233",@"803" ,nil];
//    [[SQLManager shanredSQLManager] addObjToTable:@"table_test" objs:@"job4",@"234",@"804" ,nil];
//    [[SQLManager shanredSQLManager] addObjToTable:@"table_test" objs:@"job1",@"203",@"880" ,nil];
//    [[SQLManager shanredSQLManager] deleteObjInTable:@"table_test" objs:@"job",@"23",@"80", nil];
    [[SQLManager shanredSQLManager] updateObjInTable:@"table_test" whereObj:@"job" value:@"jobc",@"244",@"111", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
