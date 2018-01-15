//
//  SQLManager.m
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/26.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "SQLManager.h"
#import "FMDatabase.h"

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
    //参数链表指针
    va_list list;
    //遍历开始
    va_start(list, firstObj);
    NSMutableArray *objs = [[NSMutableArray alloc] init];
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
        if(i < allKays.count-1)
        {
            [sql_key appendFormat:@"%@,", allKays[i]];
        }
        else
        {
            [sql_key appendFormat:@"%@", allKays[i]];
        }
    }
    NSMutableString *sql_obj = [[NSMutableString alloc] init];
    for(NSInteger i = 0;i < allKays.count; i++)
    {
        if(i < allKays.count-1)
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
        NSString *sql = [NSString stringWithFormat:@"replace into %@(%@) values(%@)",tableName,sql_key,sql_obj];
        BOOL isSuc = [_fmdb executeUpdate:sql withArgumentsInArray:objs];
        if (isSuc) {

            NSLog(@"添加成功");
        } else {

            NSLog(@"添加失败%@", _fmdb.lastErrorMessage);
        }
    }
    [_fmdb close];
}
- (void)deleteObjInTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    //参数链表指针
    va_list list;
    //遍历开始
    va_start(list, firstObj);
    //知道读取到下一个时nil时结束递增
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    for (NSString *str = firstObj; str != nil; str = va_arg(list, NSString*)) {
        NSLog(@"%@",str);
        [objs addObject:str];
    }
    //结束遍历
    va_end(list);
    NSArray *allkeys = [_tableObjDic objectForKey:tableName];
    NSMutableString *sql_Obj = [[NSMutableString alloc] init];
    for(NSInteger i = 0; i < allkeys.count; i++)
    {
        if(i < allkeys.count-1)
        {
            [sql_Obj appendFormat:@"%@", [NSString stringWithFormat:@"%@ = '%@' and ",allkeys[i],objs[i]]];
        }
        else
        {
            [sql_Obj appendFormat:@"%@", [NSString stringWithFormat:@"%@ = '%@'",allkeys[i],objs[i]]];
        }
    }
    
    if ([_fmdb open]) {
        
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@",
                               tableName,sql_Obj];
        BOOL res = [_fmdb executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
            
        }
    }
    [_fmdb close];
}
- (void)updateObjInTable:(NSString *)tableName whereObj:(NSString *)where newValue:(NSString *)newValue objs:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION
{
    //参数链表指针
    va_list list;
    //遍历开始
    va_start(list, firstValue);
    //知道读取到下一个时nil时结束递增
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    for (NSString *str = firstValue; str != nil; str = va_arg(list, NSString*)) {
        NSLog(@"%@",str);
        [objs addObject:str];
    }
    //结束遍历
    va_end(list);
    NSArray *allkeys = [_tableObjDic objectForKey:tableName];
    NSMutableString *sql_Obj = [[NSMutableString alloc] init];
    for(NSInteger i = 0; i < allkeys.count; i++)
    {
        if(i < allkeys.count-1)
        {
            [sql_Obj appendFormat:@"%@", [NSString stringWithFormat:@"%@='%@' and ",allkeys[i],objs[i]]];
        }
        else
        {
            [sql_Obj appendFormat:@"%@", [NSString stringWithFormat:@"%@='%@'",allkeys[i],objs[i]]];
        }
    }
    if ([_fmdb open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"update %@ set %@='%@' where %@",tableName,where,newValue,
                               sql_Obj];
        BOOL res = [_fmdb executeUpdate:updateSql];
        
        if (!res) {
            NSLog(@"error when update db table%@",_fmdb.lastErrorMessage);
        } else {
            NSLog(@"success to update db table");
        }
        [_fmdb close];
    }
}
- (NSArray *)getAllMessage:(NSString *)tableName where:(NSString *)where value:(NSString *)value
{
    [_fmdb open];
    NSMutableArray *historyArr = [NSMutableArray array];
    if (historyArr.count > 0) {
        [historyArr removeAllObjects];
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",tableName,where,value];
        FMResultSet *rs = [_fmdb executeQuery:sql];
        while ([rs next]) {
            for (NSString *obj in [_tableObjDic objectForKey:tableName]) {
                NSString *value = [rs stringForColumn:obj];
                [historyArr addObject:value];
            }
        }
    }
    return historyArr;
}
@end







