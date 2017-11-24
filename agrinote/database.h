//
//  database.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/18.
//  Copyright © 2017年 agri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "fieldInfo.h"

@interface database : NSObject {
    
}

- (void)setupSQL;

//資料庫開啟
- (BOOL)openSQL;

//資料庫關閉
- (void)closeSQL;

//資料庫初始化
- (void)dropTable;
-(BOOL) createDatabase;

//新增資料
- (void)insertFarmData:(fieldInfo *)data;
- (void)insertCropData:(fieldInfo *)data;
- (void)insertNoteData:(fieldInfo *)data;
- (NSData*)insertCropIcon:(NSString *)iconName; //新增作物圖示

//查詢資料
- (NSMutableArray*)selectFarmList; //查詢農田清單
- (NSMutableArray*)selectCropList:(NSString *)farmID; //查詢作物清單
- (NSMutableArray*)selectNoteList:(NSString *)cropID; //查詢日誌清單
- (NSMutableArray*)selectNoteData:(NSString *)noteID; //查詢日誌
- (NSData*)selectCropIcon:(NSString *)cropItem; //查詢作物圖示
- (NSMutableArray*)selectWorkingItem; //查詢農務工作主項目
- (NSMutableArray*)selectWorkingItem:(NSString *)parentID; //查詢農務工作附項目

//更新資料
//- (void)updateNoteData:(NSString *)noteID andData:(fieldInfo *)data; //更新日誌
- (void)updateNoteData:(fieldInfo *)data; //更新日誌

//刪除資料
- (void)deleteData;

//同步資料
- (void)syncData;

//示範資料
- (void)demoData;
@end
