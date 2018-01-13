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
- (void)createRSSTable;

- (BOOL)addRSS:(SQLModel *)model;

- (BOOL)deleteRSS:(SQLModel *)model;

- (NSMutableArray *)selectRSS;
@end
