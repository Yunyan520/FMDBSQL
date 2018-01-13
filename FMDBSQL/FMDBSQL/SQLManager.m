//
//  SQLManager.m
//  SQL数据库操作
//
//  Created by lidianchao on 2017/6/26.
//  Copyright © 2017年 lidianchao. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLModel
@end

@implementation SQLManager
+ (SQLManager *)shanredSQLManager
{
    static SQLManager *instance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[SQLManager alloc] init];
    });
    return instance;
}
- (void)createRSSTable
{
    NSString *sql = @"CREATE TABLE IF NOT EXISTS RSSArtical(link TEXT primary key,name TEXT,date TEXT,category TEXT,imageUrlString TEXT)";
    [self createTable:sql];
}

- (BOOL)addRSS:(SQLModel *)model
{
    NSString *sql = @"INSERT INTO RSSArtical(link,name,date,category,imageUrlString) VALUES(?,?,?,?,?)";
    
    NSArray *array = [NSArray arrayWithObjects:model.link, model.name, model.date, model.category, model.imageUrlString, nil];
    
    return [self insertData:sql params:array];
}

- (BOOL)deleteRSS:(SQLModel *)model
{
    NSString *sql = @"DELETE FROM RSSArtical WHERE link=?";
    NSArray *array = [NSArray arrayWithObject:model.link];
    return [self deleteData:sql params:array];
}

- (NSMutableArray *)selectRSS
{
    NSString *sql = @"SELECT link,name,date,category,imageUrlString FROM RSSArtical";
    NSArray *data = [self selectData:sql columnCount:5];
    NSMutableArray *rssArticals = [NSMutableArray array];
    for (NSArray *array in data) {
        SQLModel *model = [[SQLModel alloc] init];
        model.link = array[0];
        model.name = array[1];
        model.date = array[2];
        model.category = array[3];
        model.imageUrlString = array[4];
        [rssArticals addObject:model];
    }
    return rssArticals;
}
@end







