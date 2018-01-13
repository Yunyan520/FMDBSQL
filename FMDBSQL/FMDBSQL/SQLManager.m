//
//  SQLManager.m
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/26.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "SQLManager.h"
#import "FMDatabase.h"
@implementation SQLModel
@end

@implementation SQLManager
{
    FMDatabase *_fmdb;
    NSMutableDictionary *_tableObjDic;
}
+ (SQLManager *)shanredSQLManager
{
    static SQLManager *instance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[SQLManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //1.数据库文件路径
        NSString * path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/AlarmInfos.db"];
        NSLog(@"%@", path);
        //2.实例化FMDataBase对象
        _fmdb = [[FMDatabase alloc]initWithPath:path];
        _tableObjDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)createRSSTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    //参数链表指针
    va_list list;
    //遍历开始
    va_start(list, firstObj);
    //知道读取到下一个时nil时结束递增
    for (NSString *str = firstObj; str != nil; str = va_arg(list, NSString*)) {
        NSLog(@"%@",str);
        [objs addObject:str];
    }
    //结束遍历
    va_end(list);
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    for(NSInteger i = 0;i < objs.count; i++)
    {
        if(i < objs.count-1)
        {
            [sql appendFormat:@"%@", [NSString stringWithFormat:@"%@ varchar(256),",objs[i]]];
        }
        else
        {
            [sql appendFormat:@"%@", [NSString stringWithFormat:@"%@ varchar(256)",objs[i]]];
        }
    }
    NSLog(@"sql*******%@",sql);
    BOOL isOpen = [_fmdb open];
    if(isOpen)
    {
        NSString * priceAlertSql = [NSString stringWithFormat:@"create table if not exists %@(%@)",tableName,sql];
        BOOL isTableSuccess = [_fmdb executeUpdate:priceAlertSql];
        if(isTableSuccess){
            NSLog(@"表创建成功");
            [_tableObjDic setObject:objs forKey:tableName];
        }else{
            NSLog(@"表创建失败%@", _fmdb.lastErrorMessage);
        }
    }
}
- (void)addObjToTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    //保存所有参数
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    //参数链表指针
    va_list list;
    //遍历开始
    va_start(list, firstObj);
    //知道读取到下一个时nil时结束递增
    for (NSString *str = firstObj; str != nil; str = va_arg(list, NSString*)) {
        NSLog(@"%@",str);
        [objs addObject:str];
    }
    //结束遍历
    va_end(list);
    //获取列表中所有键
    NSArray *allKays = [_tableObjDic objectForKey:tableName];
    NSMutableString *sql_key = [[NSMutableString alloc] init];
    for(NSInteger i = 0;i < allKays.count; i++)
    {
        if(i < objs.count-1)
        {
            [sql_key appendFormat:@"%@,", objs[i]];
        }
        else
        {
            [sql_key appendFormat:@"%@,", objs[i]];
        }
    }
    NSMutableString *sql_obj = [[NSMutableString alloc] init];
    for(NSInteger i = 0;i < objs.count; i++)
    {
        if(i < objs.count-1)
        {
            [sql_obj appendFormat:@"?,"];
        }
        else
        {
            [sql_obj appendFormat:@"?"];
        }
    }
    if ([_fmdb open]) {
//        //写sql语句
//        NSString *sql = @"replace into AlarmTable(currencyArea,coinName,id,alarmPrice,priceType,switch) values(?,?,?,?,?,?)";
        NSString *sql = [NSString stringWithFormat:@"replace into %@(%@) values(%@)",tableName,sql_key,sql_obj];
//
//        BOOL isSuc = [_fmdb executeUpdate:sql,currencyArea,coinName, idString, price, priceType, swit];
//
//        if (isSuc) {
//
//            NSLog(@"添加成功");
//        } else {
//
//            NSLog(@"添加失败");
//
//        }
    }
    
    [_fmdb close];
}
- (NSArray *)getAllObj:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    //参数链表指针
    va_list list;
    //遍历开始
    va_start(list, firstObj);
    //知道读取到下一个时nil时结束递增
    for (NSString *str = firstObj; str != nil; str = va_arg(list, NSString*)) {
        NSLog(@"%@",str);
        [objs addObject:str];
    }
    //结束遍历
    va_end(list);
    return [objs copy];
}
@end







