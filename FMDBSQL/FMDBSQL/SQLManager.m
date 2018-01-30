//
//  SQLManager.m
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/26.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "SQLManager.h"
#import "FMDatabase.h"
#import <FMDatabaseQueue.h>


//链表操作
#define VA_LIST_CREATE(__object)  \
                    va_list list; \
                    va_start(list, __object);

#define VA_LIST_CLEAR(__list) va_end(__list)





// 创建 table的专用
#define VA_LIST_ER_ARRAY(__LIST, __object ,__ARRAY) \
do { \
    if(![__ARRAY isKindOfClass:[NSMutableArray class]] || ![__ARRAY isKindOfClass:[NSArray class]]) { \
        return; \
    } \
    for (NSString *str = __object; str != nil; str = va_arg(__LIST, NSString*)) { \
        [__ARRAY addObject:str]; \
    } \
} while(0)





// 获取链表 并 遍历参数 给数组
#define VA_LIST_CREATE_ARRAY( __object ,__ARRAY) \
do { \
    VA_LIST_CREATE(__object); \
\
    if(![__ARRAY isKindOfClass:[NSMutableArray class]] || ![__ARRAY isKindOfClass:[NSArray class]]) { \
        return; \
    } \
    for (NSString *str = __object; str != nil; str = va_arg(list, NSString*)) { \
        [__ARRAY addObject:str]; \
    } \
\
    VA_LIST_CLEAR(list); \
} while(0)

@implementation SQLManager
{
    FMDatabase *_fmdb;
    NSMutableDictionary *_tableObjDic;
    FMDatabaseQueue * _ioQueue;
}



+ (SQLManager *)shanredSQLManager {
    static SQLManager *instance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        //我处理这个了
        instance = [[SQLManager alloc] initConfig];
    });
    return instance;
}


- (instancetype)initConfig {
    //我处理这个了
    if(self = [super init]) {
        //1.数据库文件路径
        NSString * path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/AlarmInfos.db"];
        NSLog(@"%@", path);
        //2.实例化FMDataBase对象
        _fmdb = [[FMDatabase alloc] initWithPath:path];
        _tableObjDic = [[NSMutableDictionary alloc] init];
        
        /*线程安全*/
        _ioQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        
    }
    return self;
}


#pragma mark 创建表格
- (void)createRSSTable:(NSString *)tableName objs:(NSString *)firstObj, ... {
    VA_LIST_CREATE(firstObj);
    [self createRSSTable:tableName complete:nil objs:firstObj orVAList:list];
    VA_LIST_CLEAR(list);
}


- (void)createRSSTable:(NSString *)tableName complete:(void(^)(void))complete objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    VA_LIST_CREATE(firstObj);
    [self createRSSTable:tableName complete:complete objs:firstObj orVAList:list];
    VA_LIST_CLEAR(list);
}

- (void)createRSSTable:(NSString *)tableName complete:(void(^)(void))complete objs:(NSString *)firstObj orVAList:(va_list)list {
    
    NSParameterAssert(tableName);
    
    NSMutableArray *objs = [NSMutableArray new];
    VA_LIST_ER_ARRAY(list, firstObj, objs);

    if(objs.count == 0) {
        if(complete) {
            NSLog(@"objs 为空！！！");
            complete();
        }
        return;
    }
    
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
        [_ioQueue inDatabase:^(FMDatabase *db) {
            BOOL isTableSuccess = [_fmdb executeUpdate:priceAlertSql];
            if(isTableSuccess){
                NSLog(@"表创建成功");
                [_tableObjDic setObject:objs forKey:tableName];
            }else{
                NSLog(@"表创建失败%@", _fmdb.lastErrorMessage);
            }
            [_fmdb close];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(complete) {
                    complete();
                }
            });
        }];
    }
    else {
        [_fmdb close];
    }
    
    
    
}




#pragma mark 向表中插入数据
- (void)addObjToTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
  
    NSParameterAssert(tableName);
    
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    VA_LIST_CREATE_ARRAY(firstObj, objs);

    if(objs.count == 0) {
        NSLog(@"没有参数");
        return;
    }
    
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
        [_ioQueue inDatabase:^(FMDatabase *db) {
            BOOL isSuc = [_fmdb executeUpdate:sql withArgumentsInArray:objs];
            if (isSuc) {
                
                NSLog(@"添加成功");
            } else {
                
                NSLog(@"添加失败%@", _fmdb.lastErrorMessage);
            }
            [_fmdb close];
        }];
    }
    else {
        [_fmdb close];
    }
}



#pragma mark 删除数据
- (void)deleteObjInTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSParameterAssert(tableName);
    
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    VA_LIST_CREATE_ARRAY(firstObj, objs);
    if(objs.count == 0) {
        NSLog(@"没有参数");
        return;
    }
    
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
        [_ioQueue inDatabase:^(FMDatabase *db) {
            BOOL res = [_fmdb executeUpdate:deleteSql];
            
            if (!res) {
                NSLog(@"error when delete db table");
            } else {
                NSLog(@"success to delete db table");
            }
            [_fmdb close];
        }];
    }
    else {
        [_fmdb close];
    }
}


#pragma mark 更改表中数据
- (void)updateObjInTable:(NSString *)tableName whereObj:(NSString *)where newValue:(NSString *)newValue objs:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSParameterAssert(tableName);
    NSParameterAssert(where);
    NSParameterAssert(newValue);
    
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    VA_LIST_CREATE_ARRAY(firstValue, objs);
    if(objs.count == 0) {
        NSLog(@"没有参数");
        return;
    }
    
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
        [_ioQueue inDatabase:^(FMDatabase *db) {
            BOOL res = [_fmdb executeUpdate:updateSql];
            
            if (!res) {
                NSLog(@"error when update db table%@",_fmdb.lastErrorMessage);
            } else {
                NSLog(@"success to update db table");
            }
            [_fmdb close];
        }];
         
        
    }else {
         [_fmdb close];
     }
}



#pragma mark 获取一行所有数据
- (NSArray *)getAllMessage:(NSString *)tableName where:(NSString *)where value:(NSString *)value {
    NSParameterAssert(tableName);
    NSParameterAssert(where);
    NSParameterAssert(value);
    
    NSMutableArray *historyArr = [NSMutableArray array];
    if (historyArr.count > 0) {
        [historyArr removeAllObjects];
    }
    if ([_fmdb open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'",tableName,where,value];
         [_ioQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [_fmdb executeQuery:sql];
            while ([rs next]) {
                for (NSString *obj in [_tableObjDic objectForKey:tableName]) {
                    NSString *value = [rs stringForColumn:obj];
                    [historyArr addObject:value];
                }
            }
             [_fmdb close];
         }];
    }
    else {
        [_fmdb close];
    }
    return historyArr;
}
@end







