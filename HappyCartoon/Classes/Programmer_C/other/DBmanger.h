//
//  DBmanger.h
//  Project_A
//
//  Created by 付正 on 15/6/3.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comic.h"
#import <sqlite3.h>

@interface DBmanger : NSObject

//创建一个管理数据库的单例
+(DBmanger *)sharedInstance;

//打开数据库
-(void)openDB;

//增
- (void)insertCollectionNews:(Comic *)comic Contects:(NSData *)data;
//删
- (void)deleteCollectionNewsByUrl:(NSString *)comic_id;

//查
- (NSData *)selectCollectionNewsByUrl:(NSString *)name;
- (NSMutableArray *)selectAllCollection;

//判断活动是否已经被收藏
- (BOOL)isFavorite:(NSString *)name;

//关闭数据库
- (void)closeDB;


#pragma mark ----- 历史
//打开数据库
-(void)openHistoryDB;

//增
- (void)insertHistoryNews:(Comic *)comic Contects:(NSData *)data;
//删
- (void)deleteHistoryNewsByUrl:(NSString *)name;

//查
- (NSData *)selectHistoryNewsByUrl:(NSString *)name;
- (NSMutableArray *)selectAllHistory;

//判断活动是否已经存入历史
- (BOOL)isHistory:(NSString *)name;

//关闭数据库
- (void)closeHistoryDB;


@end
