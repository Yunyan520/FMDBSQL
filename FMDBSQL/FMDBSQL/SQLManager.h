//
//  SQLManager.h
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/26.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLManager : NSObject
+ (SQLManager *)shanredSQLManager;
/**
 创建表格

 @param tableName 表格名称
 @param firstObj 键列表
 */
- (void)createRSSTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
/**
 向表中插入数据

 @param tableName 表格名称
 @param firstObj 插入数据列表
 */
- (void)addObjToTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
/**
 删除数据

 @param tableName 表格名称
 @param firstObj 删除的数据列表
 */
- (void)deleteObjInTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
/**
 更改表中数据

 @param tableName 表格名称
 @param where 要修改的键
 @param newValue 修改后的值
 @param firstValue 修改前其他值列表
 */
- (void)updateObjInTable:(NSString *)tableName whereObj:(NSString *)where newValue:(NSString *)newValue objs:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION;
/**
 获取一行所有数据

 @param tableName 表格名称
 @param where 键
 @param value 值
 @return 返回所有数据
 */
- (NSArray *)getAllMessage:(NSString *)tableName where:(NSString *)where value:(NSString *)value;
@end
