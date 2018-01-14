//
//  SQLManager.h
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/26.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQL.h"
@interface SQLModel : NSObject
@property(nonatomic, copy) NSString *link;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *category;
@property(nonatomic, copy) NSString *imageUrlString;
@end


@interface SQLManager : SQL
+ (SQLManager *)shanredSQLManager;
- (void)createRSSTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (void)addObjToTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (void)deleteObjInTable:(NSString *)tableName objs:(NSString *)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
- (void)updateObjInTable:(NSString *)tableName whereObj:(NSString *)where value:(NSString *)firstValue, ... NS_REQUIRES_NIL_TERMINATION;
@end
