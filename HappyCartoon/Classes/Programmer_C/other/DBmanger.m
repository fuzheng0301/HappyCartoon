//
//  DBmanger.m
//  Project_A
//
//  Created by 付正 on 15/6/3.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import "DBmanger.h"
#import "CollectionModel.h"
#import "HistotyModel.h"

@implementation DBmanger

//创建一个管理数据库的单例
static DBmanger *dbManger=nil;
+(DBmanger *)sharedInstance
{
    @synchronized(self){
        if (nil==dbManger) {
            dbManger=[[DBmanger alloc]init];
        }
        return dbManger;
    }
}

static sqlite3 *db = nil;
////打开数据库
- (void)openDB
{
    
    //如果db已经打开，则直接返回，不用重复打开
    if (nil != db) {
//        NSLog(@"当前数据库不为空");
        return;
    }
    //存放数据库的路径和文件
    NSString *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath=[path stringByAppendingPathComponent:@"Collection.sqlite"];
    
//    NSLog(@"db filePath=%@",filePath);
    //打开数据库
    int result = sqlite3_open([filePath UTF8String], &db);
    if (result == SQLITE_OK) {
//        NSLog(@"打开数据库成功");
        
        NSString * createActivitySql = @"CREATE TABLE Collection(NAME TEXT PRIMARY KEY , author_name TEXT, cover TEXT, data BLOB)";
        //执行sql语句
        sqlite3_exec(db, [createActivitySql UTF8String], NULL, NULL, NULL);
        
    }
}

//增
- (void)insertCollectionNews:(Comic *)comic Contects:(NSData*)data
{
    
    //第一步:打开数据库
    [self openDB];
    //定义指针
    sqlite3_stmt *stmt = nil;
    
    NSString * sql = @"insert into Collection(NAME,author_name,cover,data) values (?,?,?,?)";
    
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    
    //验证
    if (result == SQLITE_OK) {
        
        //绑定数据
        sqlite3_bind_text(stmt, 1, [comic.name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [comic.author_name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [comic.cover UTF8String], -1, nil);
        sqlite3_bind_blob(stmt, 4, [data bytes], (int)[data length], nil);
        
        //执行
        sqlite3_step(stmt);
    }
    //释放
    sqlite3_finalize(stmt);
    
}

//删
- (void)deleteCollectionNewsByUrl:(NSString *)name
{
    [self openDB];
    
    sqlite3_stmt *stmt=nil;
    
    NSString *sql= @"delete from Collection where NAME = ?";
    
    //验证sql语句
    int result=sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    
    if (result==SQLITE_OK) {
        
        //绑定数据
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
        
        sqlite3_step(stmt);
        
    }
    //释放
    sqlite3_finalize(stmt);

}

//查
- (NSData *)selectCollectionNewsByUrl:(NSString *)name
{
    
    [self openDB];
    
    sqlite3_stmt * stmt = nil;
    
    NSString * sql = @"select data from Collection where NAME = ?";
    
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    
    NSData * data = nil;
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            
            data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
            
        }
        
    }
    
    sqlite3_finalize(stmt);
    
    return data;
}


//查询所有
- (NSMutableArray *)selectAllCollection
{
    [self openDB];
    
    sqlite3_stmt * stmt = nil;
    
    NSString * sql = @"select * from Collection";
    
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    
    NSMutableArray * collectArray = [NSMutableArray array];
    NSMutableDictionary * collectDic = [[NSMutableDictionary alloc]init];
    
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSString * name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString * author_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString * cover = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            
            
            [collectDic setObject:name forKey:@"name"];
            [collectDic setObject:author_name forKey:@"author"];
            [collectDic setObject:cover forKey:@"cover"];
            CollectionModel * model = [[CollectionModel alloc] init];
            [model setValuesForKeysWithDictionary:collectDic];
            [collectArray addObject:model];
        }
        
    }
    
    sqlite3_finalize(stmt);
    
    return collectArray;
    
}

//判断活动是否已经被收藏
- (BOOL)isFavorite:(NSString *)name
{
    NSData * data  = [self selectCollectionNewsByUrl:name];
    if (data == nil ) {
        
        return NO;
        
    }
    else
    {
        return YES;
    }
    
}

//关闭数据库
- (void)closeDB
{
    int reuslt = sqlite3_close(db);
    
    if (reuslt == SQLITE_OK) {
        
//        NSLog(@"数据库关闭成功!");
        db = nil;
    }
    
}


#pragma mark ----- 历史
//打开数据库
static sqlite3 *historyDb = nil;
-(void)openHistoryDB
{
    //如果db已经打开，则直接返回，不用重复打开
    if (nil != historyDb) {
        //        NSLog(@"当前数据库不为空");
        return;
    }
    //存放数据库的路径和文件
    NSString *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath=[path stringByAppendingPathComponent:@"Historys.sqlite"];
    
//    NSLog(@"db filePath=%@",filePath);
    //打开数据库
    int result = sqlite3_open([filePath UTF8String], &historyDb);
    if (result == SQLITE_OK) {
//        NSLog(@"打开历史数据库成功");
        
        //
        NSString * createActivitySql = @"CREATE TABLE History(NAME TEXT PRIMARY KEY , author_name TEXT, cover TEXT, data BLOB)";
        //执行sql语句
        sqlite3_exec(historyDb, [createActivitySql UTF8String], NULL, NULL, NULL);
        
    }
}

//增
- (void)insertHistoryNews:(Comic *)comic Contects:(NSData *)data
{
    //第一步:打开数据库
    [self openHistoryDB];
    //定义指针
    sqlite3_stmt *stmt = nil;
    
    NSString * sql = @"insert into History(NAME,author_name,cover,data) values (?,?,?,?)";
    
    int result = sqlite3_prepare_v2(historyDb, [sql UTF8String], -1, &stmt, nil);
    
    //验证
    if (result == SQLITE_OK) {
        
        //绑定数据
        sqlite3_bind_text(stmt, 1, [comic.name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [comic.author_name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [comic.cover UTF8String], -1, nil);
        sqlite3_bind_blob(stmt, 4, [data bytes], (int)[data length], nil);
        
        //执行
        sqlite3_step(stmt);
    }
    //释放
    sqlite3_finalize(stmt);
}
//删
- (void)deleteHistoryNewsByUrl:(NSString *)name
{
    [self openHistoryDB];
    
    sqlite3_stmt *stmt=nil;
    
    NSString *sql= @"delete from History where NAME = ?";
    
    //验证sql语句
    int result=sqlite3_prepare_v2(historyDb, [sql UTF8String], -1, &stmt, nil);
    
    if (result==SQLITE_OK) {
        
        //绑定数据
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
        
        sqlite3_step(stmt);
        
    }
    //释放
    sqlite3_finalize(stmt);
}

//查
- (NSData *)selectHistoryNewsByUrl:(NSString *)name
{
    [self openHistoryDB];
    
    sqlite3_stmt * stmt = nil;
    
    NSString * sql = @"select data from History where NAME = ?";
    
    int result = sqlite3_prepare_v2(historyDb, [sql UTF8String], -1, &stmt, NULL);
    
    NSData * data = nil;
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            
            data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
            
        }
    }
    sqlite3_finalize(stmt);
    
    return data;
}
- (NSMutableArray *)selectAllHistory
{
    [self openHistoryDB];
    
    sqlite3_stmt * stmt = nil;
    
    NSString * sql = @"select * from History";
    
    int result = sqlite3_prepare_v2(historyDb, [sql UTF8String], -1, &stmt, NULL);
    
    NSMutableArray * collectArray = [NSMutableArray array];
    NSMutableDictionary * collectDic = [[NSMutableDictionary alloc]init];
    
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSString * name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString * author_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString * cover = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            
            
            [collectDic setObject:name forKey:@"name"];
            [collectDic setObject:author_name forKey:@"author"];
            [collectDic setObject:cover forKey:@"cover"];
            HistotyModel * model = [[HistotyModel alloc] init];
            [model setValuesForKeysWithDictionary:collectDic];
            [collectArray addObject:model];
        }
        
    }
    
    sqlite3_finalize(stmt);
    
    return collectArray;
}

//判断活动是否已经存入历史
- (BOOL)isHistory:(NSString *)name
{
    NSData * data  = [self selectHistoryNewsByUrl:name];
    if (data == nil ) {
        
        return NO;
        
    }
    else
    {
        return YES;
    }
    
}

//关闭数据库
- (void)closeHistoryDB
{
    int reuslt = sqlite3_close(historyDb);
    
    if (reuslt == SQLITE_OK) {
        
//        NSLog(@"数据库关闭成功!");
        historyDb = nil;
    }
}


@end
