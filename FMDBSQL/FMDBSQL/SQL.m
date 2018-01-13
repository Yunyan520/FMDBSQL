//
//  SQL.m
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/28.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "SQL.h"
#define kFileName @"RSSReader.sqlite"
@implementation SQL
- (NSString *)filePath
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [file stringByAppendingPathComponent:kFileName];
    NSLog(@"%@", file);
    return filePath;
}
- (void)createTable:(NSString *)sqlString
{
    sqlite3 *sqlite = nil;
    int result = sqlite3_open([self.filePath UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"createTable打开数据库失败");
        sqlite3_close(sqlite);
    }
    
    char *errMsg;
    result = sqlite3_exec(sqlite, [sqlString UTF8String], NULL, NULL, &errMsg);
    if (result != SQLITE_OK) {
        NSLog(@"createTable创建表失败:%s", errMsg);
        sqlite3_close(sqlite);
    }
    
    NSLog(@"createTable创建表成功");
    
    sqlite3_close(sqlite);
}
- (BOOL)dealSql:(NSString *)sqlString params:(NSArray *)params
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    //打开数据库
    int result = sqlite3_open([self.filePath UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return NO;
    }
    
    //编译SQL语句
    result = sqlite3_prepare(sqlite, [sqlString UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"数据库语句编译失败");
        sqlite3_close(sqlite);
        return NO;
    }
    
    //绑定数据并执行sql语句
    for (int i = 0; i < params.count; i++) {
        NSString *value = [params objectAtIndex:i];
        sqlite3_bind_text(stmt, i + 1, [value UTF8String], -1, NULL);
    }
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR) {
        NSLog(@"数据库操作失败");
        sqlite3_close(sqlite);
        return NO;
    }
    
    //关闭数据库
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return YES;
}
- (NSMutableArray *)selectData:(NSString *)sqlString columnCount:(NSInteger)count
{
    sqlite3 *sqlite = nil;
    sqlite3_stmt *stmt = nil;
    
    //打开数据库
    int result = sqlite3_open([self.filePath UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        sqlite3_close(sqlite);
        return nil;
    }
    
    //编译SQL语句
    result = sqlite3_prepare(sqlite, [sqlString UTF8String], -1, &stmt, NULL);
    if (result != SQLITE_OK) {
        NSLog(@"数据库语句编译失败");
        sqlite3_close(sqlite);
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    result = sqlite3_step(stmt);
    while (result == SQLITE_ROW) {
        NSMutableArray *everyData = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            NSString *everyColumn = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, i) encoding:NSUTF8StringEncoding];
            [everyData addObject:everyColumn];
        }
        [resultArray addObject:everyData];
        result = sqlite3_step(stmt);
    }
    
    //关闭数据库
    sqlite3_finalize(stmt);
    sqlite3_close(sqlite);
    return resultArray;
}
- (BOOL)insertData:(NSString *)sqlString params:(NSArray *)params
{
    return [self dealSql:sqlString params:params];
}
- (BOOL)deleteData:(NSString *)sqlString params:(NSArray *)params
{
    return [self dealSql:sqlString params:params];
}
- (BOOL)modifyData:(NSString *)sqlString params:(NSArray *)params
{
    return [self dealSql:sqlString params:params];
}
@end
