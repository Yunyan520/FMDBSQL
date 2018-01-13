//
//  SQL.h
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/28.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SQL : NSObject

- (void)createTable:(NSString *)sqlString;

- (BOOL)insertData:(NSString *)sqlString params:(NSArray *)params;

/**删除数据, params:字符串数组*/
- (BOOL)deleteData:(NSString *)sqlString params:(NSArray *)params;

/**更改数据, params:字符串数组*/
- (BOOL)modifyData:(NSString *)sqlString params:(NSArray *)params;

- (NSMutableArray *)selectData:(NSString *)sqlString columnCount:(NSInteger)count;
@end
