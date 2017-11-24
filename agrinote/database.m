//
//  db.m
//  agrinote
//
//  Created by VimyHsieh on 2017/11/18.
//  Copyright © 2017年 agri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "database.h"
#import "fieldInfo.h" //for demo

@implementation database

NSString *dbName = @"agrinote.sqlite";
sqlite3 *Database = nil;

- (void)setupSQL {
    
    //設定資料庫檔案的路徑
    NSString *url = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:dbName];
    sqlite3 *database = nil;
    
    if (sqlite3_open([url UTF8String], &database) == SQLITE_OK) {
        NSLog(@"DB OK");
        //這裡寫入要對資料庫操作的程式碼
        
        //使用完畢後關閉資料庫聯繫
        sqlite3_close(database);
    }
}

- (BOOL)openSQL{
    
    NSArray *dbFolderPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbFilePath = [[dbFolderPath objectAtIndex:0] stringByAppendingPathComponent:dbName];
    return (sqlite3_open([dbFilePath UTF8String], &Database) == SQLITE_OK);
}

- (void)closeSQL{
    if (Database != nil) {
        sqlite3_close(Database);
    }
}


- (void)dropTable {
    char *errorMsg;
    NSString *sqlString;
    
    if (Database != nil) {
        
       //farms
        sqlString = @"DROP TABLE IF EXISTS farms";
 
        const char *createFarmSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createFarmSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        //crops
        sqlString = @"DROP TABLE IF EXISTS crops";
        const char *createCropSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createCropSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        //notes
        sqlString = @"DROP TABLE IF EXISTS notes";
        const char *createNoteSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createNoteSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        /* 以下為內建資料選項 */
        //cropicon_mapping
        sqlString = @"DROP TABLE IF EXISTS cropicon_mapping";
        const char *createIconMappingSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createIconMappingSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        //crop_items
        sqlString = @"DROP TABLE IF EXISTS crop_items";
        const char *createCropItemSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createCropItemSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        //working_item
        sqlString = @"DROP TABLE IF EXISTS working_item";
        const char *createWorkingItemSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createWorkingItemSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        //farming_item
        sqlString = @"DROP TABLE IF EXISTS farming_item";
        const char *createFarmItemSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createFarmItemSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
        
        //machine_item
        sqlString = @"DROP TABLE IF EXISTS machine_item";
        const char *createMachineItemSQL = [sqlString UTF8String];
        if (sqlite3_exec(Database, createMachineItemSQL, NULL, NULL, &errorMsg) != SQLITE_OK) {
            NSLog(@"error: %s", errorMsg);
            sqlite3_free(errorMsg);
        }
    }
}

-(BOOL) createDatabase {
    NSString *docsDir;
    NSArray *dirPath;
    sqlite3 *db;
    BOOL success = YES;
    // Get the documents directory
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPath objectAtIndex:0];
    
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: dbName]];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK) {
        
        success = [self createTable:db];
        sqlite3_close(db);
    }
    else {
        NSLog( @"Failed to open/create database");
        success = NO;
    }
    
    return success;
}

-(BOOL) createTable:(sqlite3 *)db {
    char *errMsg;
    const char *sql;
    
    /* create farms table */
    sql = "CREATE TABLE IF NOT EXISTS farms ( id INTEGER PRIMARY KEY, name TEXT, land_no TEXT, sensor_id INTEGER, start_date DATETIME, latitude REAL, longitude REAL, address TEXT, user_id INTEGER, pic_path TEXT )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create farms table");
        return NO;
    }
    
    /* create crops table */
    sql = "CREATE TABLE IF NOT EXISTS crops ( id INTEGER PRIMARY KEY, name TEXT, item TEXT, variety TEXT, period INTEGER, planting_date DATETIME, pic_path TEXT, farm_id INTEGER, alert INTEGER )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create crops table");
        return NO;
    }
    
    /* create notes table */
    sql = "CREATE TABLE IF NOT EXISTS notes ( id INTEGER PRIMARY KEY, record_date DATETIME, work_item TEXT, remark TEXT, pic_path TEXT, use_quantity INTEGER, use_unit TEXT, use_dilutionMultiple INTEGER, farm_materials TEXT, farm_materials_fee TEXT, crop_id INTEGER )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create notes table");
        return NO;
    }
    
    /* create cropicon_mapping table */
    sql = "CREATE TABLE IF NOT EXISTS cropicon_mapping (id TEXT PRIMARY KEY, icon_name TEXT, icon_url TEXT, icon_image BLOB )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create crop_items table");
        return NO;
    }
    
    /* create crop_items table */
    sql = "CREATE TABLE IF NOT EXISTS crop_items (id TEXT PRIMARY KEY, parent_id TEXT, type TEXT, name TEXT, icon TEXT )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create crop_items table");
        return NO;
    }
    
    /* create working_item table */
    sql = "CREATE TABLE IF NOT EXISTS working_item (id TEXT PRIMARY KEY, parent_id TEXT, name TEXT )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create working_item table");
        return NO;
    }
    
    /* create farming_item table */
    sql = "CREATE TABLE IF NOT EXISTS farming_item ( id TEXT PRIMARY KEY, parent_id TEXT, name TEXT )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create farming_item table");
        return NO;
    }
    
    /* create machine_item table */
    sql = "CREATE TABLE IF NOT EXISTS machine_item ( id INTEGER PRIMARY KEY, name TEXT )";
    if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog( @"Failed to create machine_item table");
        return NO;
    }
    return YES;
}

- (void)insertFarmData:(fieldInfo *)data {

    sqlite3_stmt *addStmt = nil;
    NSInteger ID = 0;
    
    const char *sql ="INSERT INTO farms (name, land_no, sensor_id, start_date, latitude, longitude, address, user_id, pic_path) VALUES(?,?,?,?,?,?,?,?,?)";
    if(sqlite3_prepare_v2(Database, sql, -1, &addStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(Database));

    //sqlite3_bind_int64(addStmt, 1, ID);
    sqlite3_bind_text(addStmt, 1, [data.farmName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 2, [data.farmLandNum UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 3, [data.sensorID integerValue]);
    sqlite3_bind_text(addStmt, 4, [data.farmPlantDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 5, [data.farmLatitude UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 6, [data.farmLongitude UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 7, [data.farmAddress UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 8, [data.userID integerValue]);
    sqlite3_bind_text(addStmt, 9, [data.farmImg UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt)) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(Database));
    } else {
        NSLog(@"Inserted farm data");
        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
        ID = sqlite3_last_insert_rowid(Database);
    }
    
    // Finalize and close database.
    sqlite3_finalize(addStmt);
}

- (void)insertCropData:(fieldInfo *)data {
    
    sqlite3_stmt *addStmt = nil;
    NSInteger ID = 0;
    
    const char *sql ="INSERT INTO crops (name, item, variety, period, planting_date, pic_path, farm_id) VALUES(?,?,?,?,?,?,?)";
    if(sqlite3_prepare_v2(Database, sql, -1, &addStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(Database));
    
    //sqlite3_bind_int64(addStmt, 1, ID);
    sqlite3_bind_text(addStmt, 1, [data.cropName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 2, [data.cropItem UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 3, [data.cropVar UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 4, [data.cropPeriod integerValue]);
    sqlite3_bind_text(addStmt, 5, [data.cropPlantDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 6, [data.cropImg UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 7, [data.farmID integerValue]);

    if(SQLITE_DONE != sqlite3_step(addStmt)) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(Database));
    } else {
        NSLog(@"Inserted crop data");
        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
        ID = sqlite3_last_insert_rowid(Database);
    }
    
    // Finalize and close database.
    sqlite3_finalize(addStmt);
}

- (void)insertNoteData:(fieldInfo *)data {
    
    sqlite3_stmt *addStmt = nil;
    NSInteger ID = 0;

    const char *sql ="INSERT INTO notes (record_date, work_item, remark, pic_path, use_quantity, use_unit, use_dilutionMultiple, farm_materials, farm_materials_fee, crop_id) VALUES(?,?,?,?,?,?,?,?,?,?)";
    if(sqlite3_prepare_v2(Database, sql, -1, &addStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(Database));
    
    sqlite3_bind_int64(addStmt, 0, ID);
    sqlite3_bind_text(addStmt, 1, [data.noteRecordDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 2, [data.noteItem UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 3, [data.noteRemark UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 4, [data.noteImg UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 5, [data.noteUseQuantity integerValue]);
    sqlite3_bind_text(addStmt, 6, [data.noteUseUnit UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 7, [data.noteUseDilutionMultiple integerValue]);
    sqlite3_bind_text(addStmt, 8, [data.noteFarmMaterials UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 9, [data.noteFarmMaterialsFee UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(addStmt, 10, [data.cropID integerValue]);
    
    if(SQLITE_DONE != sqlite3_step(addStmt)) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(Database));
    } else {
        NSLog(@"Inserted note data");
        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
        ID = sqlite3_last_insert_rowid(Database);
    }
    
    // Finalize and close database.
    sqlite3_finalize(addStmt);

}

- (void)updateNoteData:(fieldInfo *)data {
    
    sqlite3_stmt *updateStmt = nil;

    const char *sql = "UPDATE notes SET record_date = ?, work_item = ?, remark = ?, pic_path = ?, use_quantity = ?, use_unit = ?, use_dilutionMultiple = ?, farm_materials = ?, farm_materials_fee = ? WHERE id = ?";
    
    if(sqlite3_prepare_v2(Database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(Database));
    
    //sqlite3_bind_int64(updateStmt, 0, ID);
    sqlite3_bind_text(updateStmt, 1, [data.noteRecordDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStmt, 2, [data.noteItem UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStmt, 3, [data.noteRemark UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStmt, 4, [data.noteImg UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(updateStmt, 5, [data.noteUseQuantity integerValue]);
    sqlite3_bind_text(updateStmt, 6, [data.noteUseUnit UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(updateStmt, 7, [data.noteUseDilutionMultiple integerValue]);
    sqlite3_bind_text(updateStmt, 8, [data.noteFarmMaterials UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateStmt, 9, [data.noteFarmMaterialsFee UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int64(updateStmt, 10, [data.noteID integerValue]);
    
    if(SQLITE_DONE != sqlite3_step(updateStmt)) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(Database));
    } else {
        NSLog(@"Updated note data");
        
        //Reset the update statement.
        sqlite3_reset(updateStmt);
    }
    
    // Finalize and close database.
    sqlite3_finalize(updateStmt);
    
}

//查詢農田清單
- (NSMutableArray*)selectFarmList {

    NSMutableArray *datalist = [[NSMutableArray alloc] init];
    [datalist removeAllObjects];
    const char *sql = "SELECT * FROM farms";
    
    //statement 將存放查詢結果
    sqlite3_stmt *statement =nil;
    
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {

        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *ID, *name, *land_no, *sensorID, *startDate, *latitude, *longitude, *addr, *userID, *img;
            NSInteger result;
            
            result = sqlite3_column_int64(statement, 0);
            ID = [NSString stringWithFormat:@"%ld", (long)result];
            
            name = ((char *)sqlite3_column_text(statement, 1))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]: nil;
            land_no = ((char *)sqlite3_column_text(statement, 2))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]: nil;
            
            result = sqlite3_column_int64(statement, 3);
            sensorID = [NSString stringWithFormat:@"%ld", (long)result];

            startDate = ((char *)sqlite3_column_text(statement, 4))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]: nil;
            latitude = ((char *)sqlite3_column_text(statement, 5))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]: nil;
            longitude = ((char *)sqlite3_column_text(statement, 6))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]: nil;
            addr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];

            result = sqlite3_column_int64(statement, 8);
            userID = [NSString stringWithFormat:@"%ld", (long)result];
            
            img = ((char *)sqlite3_column_text(statement, 9))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]: nil;

            NSMutableArray *croplist = [self selectCropList:ID];
            NSString *cropNo = [NSString stringWithFormat: @"%ld", (long)[croplist count]];
            NSLog(@"cropNo: %@",cropNo);
            NSDictionary* data = @{ @"farmID" : ID,
                                    @"farmName": name,
                                    @"farmLandNum": land_no,
                                    @"farmStartDate": startDate,
                                    @"farmLatitude": latitude,
                                    @"farmLongitude": longitude,
                                    @"farmAddr": addr,
                                    @"farmPhoto" : img,
                                    @"cropNo": cropNo,
                                    @"userID": userID,
                                    @"sensorID": sensorID
                                    };

            [datalist addObject:data];
        }
    }
    
    sqlite3_finalize(statement);
    
    return datalist;
}

//查詢作物圖示
- (NSData*)selectCropIcon:(NSString *)cropItem {
    NSString *iconName = @"";
    NSData *iconData = nil;
    BOOL needtoInsert = NO;
   
    /* 查詢作物圖示檔名 */
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM crop_items WHERE name = '%@'", cropItem];
    const char *sql = [sqlStr UTF8String];

    sqlite3_stmt *statement =nil;
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {

            iconName = ((char *)sqlite3_column_text(statement, 4))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]: nil;
        }
    }

    sqlite3_finalize(statement);
    
    /* 查詢作物圖檔 */
    NSString *sqlStr1 = [NSString stringWithFormat:@"SELECT icon_image FROM cropicon_mapping WHERE icon_name = '%@'", iconName];
    const char *sql1 = [sqlStr1 UTF8String];

    if (sqlite3_prepare_v2(Database, sql1, -1, &statement, NULL) == SQLITE_OK) {

        if (sqlite3_step(statement) == SQLITE_ROW) {
            
                int length = sqlite3_column_bytes(statement, 0);
                iconData = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
        } else {

            needtoInsert = YES;
        }
    }
    
    sqlite3_finalize(statement);

    /* 新增 crop icon */
    if(needtoInsert) {
        iconData = [self insertCropIcon:iconName];
    }

    return iconData;
}

//新增作物圖示
- (NSData *)insertCropIcon:(NSString *)iconName {
    sqlite3_stmt *addStmt = nil;
    NSInteger ID = 0;
    NSString *iconURL = @"";
    UIImage *iconImage = [UIImage imageNamed:iconName];
    NSData *iconData = UIImagePNGRepresentation(iconImage);
    
    const char *sql ="INSERT INTO cropicon_mapping (icon_name, icon_url, icon_image) VALUES(?,?,?)";
    if(sqlite3_prepare_v2(Database, sql, -1, &addStmt, NULL) != SQLITE_OK)
        NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(Database));
    
    //sqlite3_bind_int64(addStmt, 0, ID);
    sqlite3_bind_text(addStmt, 1, [iconName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(addStmt, 2, [iconURL UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_blob(addStmt, 3, [iconData bytes], (int)[iconData length], SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(addStmt)) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(Database));
    } else {
        NSLog(@"Inserted cropicon_mapping data");
        //SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
        ID = sqlite3_last_insert_rowid(Database);
    }
    
    // Finalize and close database.
    sqlite3_finalize(addStmt);
    
    return iconData;
}

//查詢作物清單
- (NSMutableArray*)selectCropList:(NSString *)farmID {
    NSMutableArray *datalist = [[NSMutableArray alloc] init];
    [datalist removeAllObjects];

    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM crops WHERE farm_id = %ld", (long)[farmID integerValue]];

    const char *sql = [sqlStr UTF8String];

    //statement 將存放查詢結果
    sqlite3_stmt *statement =nil;
    
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *ID, *name, *item, *variety, *period, *plantDate, *img, *farmID, *alert;
            NSInteger result;
            
            result = sqlite3_column_int64(statement, 0);
            ID = [NSString stringWithFormat:@"%ld", (long)result];
            
            NSMutableArray *notelist = [self selectNoteList:ID];

            NSDictionary *entry;
            if(notelist) {
                entry = [notelist objectAtIndex:([notelist count]-1)];
            } else {
                entry = @{ @"noteRecordDate" : @"",
                           @"noteWorkItem": @""
                           };
            }

            name = ((char *)sqlite3_column_text(statement, 1))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]: nil;
            item = ((char *)sqlite3_column_text(statement, 2))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]: nil;
            variety = ((char *)sqlite3_column_text(statement, 3))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]: nil;

            result = sqlite3_column_int64(statement,4);
            period = [NSString stringWithFormat:@"%ld", (long)result];
            
            plantDate = ((char *)sqlite3_column_text(statement, 5))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]: nil;
            img = ((char *)sqlite3_column_text(statement, 6))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]: nil;
            
            result = sqlite3_column_int64(statement, 7);
            farmID = [NSString stringWithFormat:@"%ld", (long)result];
            
            result = sqlite3_column_int64(statement, 8);
            alert = [NSString stringWithFormat:@"%ld", (long)result];
            
            NSData *iconImage = [[NSData alloc] init];
            if(item) {
                iconImage =  [self selectCropIcon:item];
            }
            
            if(!iconImage){
                UIImage *image = [UIImage imageNamed:@"crop"];
                iconImage = UIImagePNGRepresentation(image);
            }
            
            NSDictionary* data = @{ @"cropID" : ID,
                                    @"cropName": name,
                                    @"cropItem": item,
                                    @"cropVeriety": variety,
                                    @"cropPeriod": period,
                                    @"cropPlantingDate": plantDate,
                                    @"cropPhoto" : img,
                                    @"cropIcon": iconImage,
                                    @"farmID": farmID,
                                    @"noteDateTime":  [entry objectForKey:@"noteRecordDate"],
                                    @"noteItem": [entry objectForKey:@"noteWorkItem"],
                                    @"alert": @false
                                    };
            
            [datalist addObject:data];
        }
    }
    
    sqlite3_finalize(statement);
    
    return datalist;
}

//查詢日誌清單
- (NSMutableArray*)selectNoteList:(NSString *)cropID {
    NSMutableArray *datalist = [[NSMutableArray alloc] init];
    [datalist removeAllObjects];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM notes WHERE crop_id = %ld", (long)[cropID integerValue]];

    const char *sql = [sqlStr UTF8String];
    
    //statement 將存放查詢結果
    sqlite3_stmt *statement =nil;
    
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {

        if (sqlite3_step(statement) == SQLITE_ROW) {

            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *ID, *recordDate, *workItem, *remark, *img, *useQuantity, *useUnit, *useDilutionMultiple, *farmMaterials, *farmMaterialsFee, *cropID;
                NSInteger result;
                
                result = sqlite3_column_int64(statement, 0);
                ID = [NSString stringWithFormat:@"%ld", (long)result];
                
                recordDate = ((char *)sqlite3_column_text(statement, 1))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]: nil;
                workItem = ((char *)sqlite3_column_text(statement, 2))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]: nil;
                remark = ((char *)sqlite3_column_text(statement, 3))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]: nil;
                img = ((char *)sqlite3_column_text(statement, 4))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]: nil;
                
                result = sqlite3_column_int64(statement, 5);
                useQuantity = [NSString stringWithFormat:@"%ld", (long)result];
                
                useUnit = ((char *)sqlite3_column_text(statement, 6))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]: nil;
                
                result = sqlite3_column_int64(statement, 7);
                useDilutionMultiple = [NSString stringWithFormat:@"%ld", (long)result];
                
                farmMaterials = ((char *)sqlite3_column_text(statement, 8))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]: nil;
                farmMaterialsFee = ((char *)sqlite3_column_text(statement, 9))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]: nil;
                
                result = sqlite3_column_int64(statement, 10);
                cropID = [NSString stringWithFormat:@"%ld", (long)result];
                
                NSDictionary* data = @{ @"noteID" : ID,
                                        @"noteRecordDate": recordDate,
                                        @"noteWorkItem": workItem,
                                        @"noteRemark": remark,
                                        @"notePhoto" : img,
                                        @"noteUseQuantity" : useQuantity,
                                        @"noteUseUnit" : useUnit,
                                        @"noteUseDilutionMultiple" : useDilutionMultiple,
                                        @"noteFarmMaterials" : farmMaterials,
                                        @"noteFarmMaterialsFee" : farmMaterialsFee,
                                        @"cropID": cropID
                                        };

                [datalist addObject:data];
            }
        } else {
            return nil;
        }
    }

    sqlite3_finalize(statement);
    
    return datalist;
}

//查詢日誌
- (NSMutableArray*)selectNoteData:(NSString *)noteID {
    
    NSMutableArray *datalist = [[NSMutableArray alloc] init];
    [datalist removeAllObjects];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM notes WHERE id = %ld", (long)[noteID integerValue]];
    const char *sql = [sqlStr UTF8String];
    
    //statement 將存放查詢結果
    sqlite3_stmt *statement =nil;
    
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *ID, *recordDate, *workItem, *remark, *img, *useQuantity, *useUnit, *useDilutionMultiple, *farmMaterials, *farmMaterialsFee, *cropID;
            NSInteger result;
            
            result = sqlite3_column_int64(statement, 0);
            ID = [NSString stringWithFormat:@"%ld", (long)result];
            
            recordDate = ((char *)sqlite3_column_text(statement, 1))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]: nil;
            workItem = ((char *)sqlite3_column_text(statement, 2))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]: nil;
            remark = ((char *)sqlite3_column_text(statement, 3))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]: nil;
            img = ((char *)sqlite3_column_text(statement, 4))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]: nil;
            
            result = sqlite3_column_int64(statement, 5);
            useQuantity = [NSString stringWithFormat:@"%ld", (long)result];
            
            useUnit = ((char *)sqlite3_column_text(statement, 6))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]: nil;
            
            result = sqlite3_column_int64(statement, 7);
            useDilutionMultiple = [NSString stringWithFormat:@"%ld", (long)result];
            
            farmMaterials = ((char *)sqlite3_column_text(statement, 8))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]: nil;
            farmMaterialsFee = ((char *)sqlite3_column_text(statement, 9))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]: nil;
            
            result = sqlite3_column_int64(statement, 10);
            cropID = [NSString stringWithFormat:@"%ld", (long)result];
            
            NSDictionary* data = @{ @"noteID" : ID,
                                    @"noteRecordDate": recordDate,
                                    @"noteWorkItem": workItem,
                                    @"noteRemark": remark,
                                    @"notePhoto" : img,
                                    @"noteUseQuantity" : useQuantity,
                                    @"noteUseUnit" : useUnit,
                                    @"noteUseDilutionMultiple" : useDilutionMultiple,
                                    @"noteFarmMaterials" : farmMaterials,
                                    @"noteFarmMaterialsFee" : farmMaterialsFee,
                                    @"cropID": cropID
                                    };
            
           [datalist addObject:data];
        }
    }
    
    sqlite3_finalize(statement);
    
    return datalist;
}

//查詢農務工作主項目
- (NSMutableArray*)selectWorkingItem {
    NSDictionary* data;
    int count = 0;
    NSMutableArray *datalist = [[NSMutableArray alloc] init];
    [datalist removeAllObjects];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM working_item"];
    const char *sql = [sqlStr UTF8String];
    
    //statement 將存放查詢結果
    sqlite3_stmt *statement =nil;
    
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            if (sqlite3_column_type(statement, 1) == SQLITE_NULL) {
                NSString *ID, *name;
                
                ID = ((char *)sqlite3_column_text(statement, 0))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]: nil;
                name = ((char *)sqlite3_column_text(statement, 2))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]: nil;

                data = @{ @"workingItemID" : ID,
                          @"workingItemName": name
                          };

                count = sqlite3_column_int(statement, 0);
                
            } else {
                continue;
            }

            [datalist addObject:data];
        }
    }
    
    sqlite3_finalize(statement);
    
    return datalist;
}

//查詢農務工作附項目
- (NSMutableArray*)selectWorkingItem:(NSString *)parentID {
    NSMutableArray *datalist = [[NSMutableArray alloc] init];
    [datalist removeAllObjects];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM working_item WEERE parent_id = %ld", (long)[parentID integerValue]];
    const char *sql = [sqlStr UTF8String];
    
    //statement 將存放查詢結果
    sqlite3_stmt *statement =nil;
    
    if (sqlite3_prepare_v2(Database, sql, -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *ID, *parentID, *name;
            
            ID = ((char *)sqlite3_column_text(statement, 0))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]: nil;
            parentID = ((char *)sqlite3_column_text(statement, 1))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]: nil;
            name = ((char *)sqlite3_column_text(statement, 2))? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]: nil;
            
            NSDictionary *data = @{ @"workingItemID" : ID,
                                    @"workingItemParentID" : parentID,
                                    @"workingItemName": name
                                    };

            [datalist addObject:data];
        }
    }
    
    sqlite3_finalize(statement);
    
    return datalist;
}

//同步資料
- (void)syncData {
    char *errorMsg;

    //crop_items 作物種類
    NSArray *crop_items = [ [ NSArray alloc ] initWithObjects:@"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('fa34a062-99dc-4ccd-b2bf-f5d19db0e466',null,null,'水稻','crop_rice.png')", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0e680872-2ba3-4e1b-b06f-7d333cf916ec','fa34a062-99dc-4ccd-b2bf-f5d19db0e466',null,'稉稻',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('60bce977-f56b-4cff-9685-8e4ee7bbf3e7','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台梗2號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('07df0821-2582-4dc6-8c34-54140e0b78f3','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台梗8號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('419ed7a4-b510-411a-862e-02ab9dfc6ccb','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台梗9號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('41812938-d866-457b-b291-6cfdfda745d8','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台梗14號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('7d4f9559-b801-49e2-91b1-95816758cd8b','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台梗16號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('36738316-8e44-4c22-bf2a-413e2593e56f','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台中192號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('babb83e3-d960-4fb7-80af-fceefee9477b','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台南11號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('fdff5c78-8454-4f9a-8061-8e6eae7f3528','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','高雄139號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('f2408df4-7e2b-49ae-ac6b-094f1ec9b7f9','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台農71號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('5f51687f-3590-4191-a741-864f8d0890dd','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台東30號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('b0e44fed-feb5-4619-b16f-22d3b61de686','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台東33號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('fc362c05-272f-4e3d-b7cb-9a281a6c9bf3','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台梗4號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('17222afd-c658-4cf2-bf15-464e44f52452','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','桃園3號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('2cf75fff-cc29-46c6-85b5-612b038f02d4','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','台南16號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('acd39a97-51f6-4ffe-854c-da211b3a29d9','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','高雄145號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('54972680-a1b8-4657-93bc-62a9d7753cae','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','高雄147號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('c75b6a73-a845-4fa3-b741-561581a96105','0e680872-2ba3-4e1b-b06f-7d333cf916ec','水稻工作','苗栗1號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('eb3a9e86-f7f0-4eaa-a3bf-59d651d05bd8','fa34a062-99dc-4ccd-b2bf-f5d19db0e466',null,'秈稻',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0088f1d1-7993-4598-a471-d42e1d9c9ecf','eb3a9e86-f7f0-4eaa-a3bf-59d651d05bd8','水稻工作','台中秈10號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('29dca2a0-81cf-4f75-b68b-19d3fc4cebdf','eb3a9e86-f7f0-4eaa-a3bf-59d651d05bd8','水稻工作','台中秈17號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('eea79e06-9054-4e1c-96aa-e17eb65c2588','eb3a9e86-f7f0-4eaa-a3bf-59d651d05bd8','水稻工作','高雄秈7號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('d1034d1e-8b9f-48f9-aa22-679c73f7a51d','fa34a062-99dc-4ccd-b2bf-f5d19db0e466',null,'糯稻',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('71c94311-8e10-4de8-9970-d9dd9fc772f6','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','台中秈糯1號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a4493f9d-8abe-4f7b-bfc9-9730d6bfc216','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','台中秈糯2號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a8bb3035-e994-4013-bbd7-804d818d01e6','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','高雄秈糯8號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('13a61c1b-33ec-4854-ad0f-c1368f723c8c','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','台農糯73號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('074b0383-f7c6-4c92-9367-eaeff27c7955','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','台梗糯1號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('615d9ec2-502b-45e4-8e42-95f53ffb1134','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','台梗糯3號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('b8767c51-2886-44fd-85cc-706030811c60','d1034d1e-8b9f-48f9-aa22-679c73f7a51d','水稻工作','台東糯31號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('bae1dd57-1f62-4fa3-a9af-a0fe6d35978f',null,null,'玉米','crop_corn.png')", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('fd441e3a-a655-46aa-83c3-777981ec1178','bae1dd57-1f62-4fa3-a9af-a0fe6d35978f',null,'食用甜玉米','crop_corn1.png')", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('edc6e0e7-655d-4b7c-b7a4-d8bcc9fd3a0e','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','華珍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('15c5066c-a2b9-4b3e-9ff7-74080aba6f03','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','彩珍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('1be26b6d-6d24-4677-ac43-a6c9075f7e36','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','金蜜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('15383ee8-8eda-49aa-9977-91b6e340f0b0','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','236超甜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('5936bd1b-291e-41a3-93d8-51f6f807d317','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','好滋味金銀',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('99a853f7-2ead-4650-96ce-1b196838f56a','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','黃后',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('95bc1d3e-ee4e-4b6f-998a-a56abf2fea72','fd441e3a-a655-46aa-83c3-777981ec1178','蔬菜類工作','台南26號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('2233360c-34a5-4438-b0f9-847f2d6b9329','bae1dd57-1f62-4fa3-a9af-a0fe6d35978f',null,'食用白玉米',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('9111a7ad-3344-40f9-aa2f-4936fea2f2a0','2233360c-34a5-4438-b0f9-847f2d6b9329','蔬菜類工作','台南22號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('cd5145f2-5606-4fe4-9ece-f2c5edea534e','2233360c-34a5-4438-b0f9-847f2d6b9329','蔬菜類工作','台農4號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('42564b42-e0f0-4422-9dae-a48aa27a29a1','2233360c-34a5-4438-b0f9-847f2d6b9329','蔬菜類工作','台南白',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0dae7d74-dde7-4fdd-ab4f-efe386f837ce','bae1dd57-1f62-4fa3-a9af-a0fe6d35978f',null,'食用糯玉米',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('7b4323bc-ae1f-4d25-877c-a30637afa596','0dae7d74-dde7-4fdd-ab4f-efe386f837ce','蔬菜類工作','美珍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0b039d2c-f2fd-44e0-a667-ca281814da36','0dae7d74-dde7-4fdd-ab4f-efe386f837ce','蔬菜類工作','玉美珍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('d1314fa2-ba09-4fc0-b2f8-8a4229c3ca17','0dae7d74-dde7-4fdd-ab4f-efe386f837ce','蔬菜類工作','黑美珍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('1082f211-73e6-43a8-b000-b3051d866faa','0dae7d74-dde7-4fdd-ab4f-efe386f837ce','蔬菜類工作','台農5號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('c70a2bad-2d9a-4005-a548-ff0acc4dd844','bae1dd57-1f62-4fa3-a9af-a0fe6d35978f',null,'飼料玉米',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('93d2c818-02df-48b3-871f-5f1a9cd076d7','c70a2bad-2d9a-4005-a548-ff0acc4dd844','蔬菜類工作','台農1號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('b1b29545-7178-410c-bbef-84bb2faefcb4','c70a2bad-2d9a-4005-a548-ff0acc4dd844','蔬菜類工作','台南20號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('1c42492c-2972-4e87-b86c-dad52dab351b','c70a2bad-2d9a-4005-a548-ff0acc4dd844','蔬菜類工作','台南24號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('eb21177f-fded-4079-a0ad-86fb166fc6bb','c70a2bad-2d9a-4005-a548-ff0acc4dd844','蔬菜類工作','台南29號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('525772b9-f911-4d8e-ba7f-f08d1f8d95d0','c70a2bad-2d9a-4005-a548-ff0acc4dd844','蔬菜類工作','明豐3號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('450e9c93-479c-457b-9532-1794b89e5bcb','bae1dd57-1f62-4fa3-a9af-a0fe6d35978f',null,'青割玉米',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('cbea5850-3aef-4323-8f3f-7941e24ec040','450e9c93-479c-457b-9532-1794b89e5bcb','蔬菜類工作','台南19號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('abfe1062-1d4a-4ed1-9237-7d0d93c067a0','450e9c93-479c-457b-9532-1794b89e5bcb','蔬菜類工作','台農2號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('641dbc18-aeb6-484e-b8af-8b7c8685e171','450e9c93-479c-457b-9532-1794b89e5bcb','蔬菜類工作','台南21號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('18fae035-33d4-4d70-a657-82bfb84fdd28','450e9c93-479c-457b-9532-1794b89e5bcb','蔬菜類工作','台南24號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('4177f429-bce4-40d5-a582-6d96e38f1a8e','450e9c93-479c-457b-9532-1794b89e5bcb','蔬菜類工作','台農3號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('8c5c497c-0efd-4503-9964-c4c87964f0d5','450e9c93-479c-457b-9532-1794b89e5bcb','蔬菜類工作','墾丁1號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('edda50b6-8272-42ad-bb84-9c396a070330',null,null,'雜糧類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0aca9fe9-319f-48da-8254-3178dd9f536e','edda50b6-8272-42ad-bb84-9c396a070330','蔬菜類工作','番薯',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('cd90daa8-664d-4192-985b-57dba153f6cd','edda50b6-8272-42ad-bb84-9c396a070330','蔬菜類工作','馬鈴薯',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('c38a34e1-2c98-4dbf-a57e-ac08413dabf0','edda50b6-8272-42ad-bb84-9c396a070330','蔬菜類工作','黃豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a33ff9fc-7336-475c-b888-68dcd512205b',null,null,'根菜類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('3c73eb7a-b759-4269-8e70-93062d62e7de','a33ff9fc-7336-475c-b888-68dcd512205b','蔬菜類工作','蘿蔔',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('3f008f28-b89a-483f-84db-bf52f2ef4701','a33ff9fc-7336-475c-b888-68dcd512205b','蔬菜類工作','胡蘿蔔','crop_carrot.png')", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('ec71d6ce-eb27-4354-b693-724421787dce','a33ff9fc-7336-475c-b888-68dcd512205b','蔬菜類工作','芋頭',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('9ffdf6ab-ad5d-417e-9866-552779cd62fd','a33ff9fc-7336-475c-b888-68dcd512205b','攀爬蔬菜類工作','豆薯',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a7c4bc48-f069-4784-9882-9e01d10d1ae8','a33ff9fc-7336-475c-b888-68dcd512205b','蔬菜類工作','荸薺',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('393fcbcb-233c-43a8-a4f9-eb2005070807','a33ff9fc-7336-475c-b888-68dcd512205b','蔬菜類工作','牛蒡',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('640a0831-5daa-4f41-9c6b-063006528e06','a33ff9fc-7336-475c-b888-68dcd512205b','蔬菜類工作','山藥',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('c3a0e236-6378-4b2c-9256-b1f2d901c766',null,null,'莖菜類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('cbdf9b2c-003d-4eb6-9066-f4a895df13fd','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','青蔥',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('30abe955-e7db-43c1-87ab-a297931187eb','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','韭菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('76b46be1-5327-4e72-aac3-65956803d057','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','大蒜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('78e4fe6c-463e-448b-8cce-935015930889','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','洋蔥',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('068899bf-61bb-4612-8b45-e5ad700a942d','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','薑',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('af64579a-7ba4-4490-b106-9242b5906f94','c3a0e236-6378-4b2c-9256-b1f2d901c766','筍類工作','綠竹筍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('c57d1b0e-fb31-4ff1-b64c-5803f0a74992','c3a0e236-6378-4b2c-9256-b1f2d901c766','筍類工作','麻竹筍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('3791c367-9f15-45d5-8d30-e3fbe20a651e','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','茭白筍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0b97828e-8e42-44b6-b87c-30f3fe0ac3d1','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','蘆筍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('7d0440fa-e711-447b-9088-b7249df1949c','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','球莖甘藍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('16910948-1fbe-473d-8bbf-7f2e000f0d3a','c3a0e236-6378-4b2c-9256-b1f2d901c766','蔬菜類工作','蓮藕',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('eba85c17-5531-43ca-b1ec-9d96d7a8b6ac',null,null,'葉菜類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a1defa39-4b26-46a9-b465-6c0d97b63b4c','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','甘藍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('1064014e-e145-4961-b7fa-afa119ff8fa7','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','白菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a547dbde-3b0c-4890-a67a-83d66206e3f8','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','油菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('2cb0bae0-2e01-44cf-9b08-0d028adfeab5','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','芥藍',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('ae6b5f9b-467b-423b-9968-5ac3c48f72ab','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','蕹菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('df4772b2-06c6-4595-886e-1bcc98d49d82','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','菠菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('2a6f4da1-d292-40b2-b4fa-b2e40965e676','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','芹菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('46dd62a9-3eab-4415-b1c7-5de3dfebcff4','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','萵苣',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('3eb96788-18f3-4e19-8687-44884747f1f8','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','芥菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('235e8ea1-76a9-4845-8d28-1cfd96202aac','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','茼蒿',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('f6667542-d003-4896-8843-042ece81e718','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','莧菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0aad2017-e228-4ad8-8a21-f07ea61daf00','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','地瓜葉',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('7c052906-0bd0-4ecd-9aa9-89992905e713','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','紅鳳菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a50e6df3-c4a0-4756-ac04-4905b01ea02e','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','皇宮菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('ab2c3917-761c-45fd-b9e6-cdba4fb19f8b','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','過貓',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('880f3646-e079-447d-b833-743b79cdef38','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','山蘇',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('cfbd426b-6343-48d3-bbb1-fb0f3fb6d4b1','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','川七',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('4346e6e4-d80f-4fc1-85e5-856dfec77367','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','龍鬚菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('b243536d-5c40-4827-8a94-b15154bd23e5','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','九層塔',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('786f6b52-e2ae-4ced-90d5-89c089ac081e','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','香菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('feaa4b1b-cf1e-4a61-ba8c-97f82e948514','eba85c17-5531-43ca-b1ec-9d96d7a8b6ac','蔬菜類工作','香芹',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('5d13eb43-5629-4adf-8e75-13a4c7fa58dd',null,null,'花菜類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('9bf84d4a-276f-45e4-afdf-b97f0a2a4d50','5d13eb43-5629-4adf-8e75-13a4c7fa58dd','蔬菜類工作','花椰菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('269ca940-95cc-4ab2-9dce-29cc791bb73b','5d13eb43-5629-4adf-8e75-13a4c7fa58dd','蔬菜類工作','青花菜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('8742e081-41c4-411c-af54-e792fa8fb352','5d13eb43-5629-4adf-8e75-13a4c7fa58dd','蔬菜類工作','金針花',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('40fe5360-a457-4680-bb8d-668bbe415e45','5d13eb43-5629-4adf-8e75-13a4c7fa58dd','攀爬蔬菜類工作','南瓜花',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('e863e9d1-fa85-4f21-9f87-594f1805f615',null,null,'果菜類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('a9b3d08c-1b92-41aa-a1e2-43779f786dce','e863e9d1-fa85-4f21-9f87-594f1805f615','蔬菜類工作','冬瓜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('9eab6d57-086c-47f3-8585-152e2d0e3768','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','胡瓜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('af91fa56-87f0-438a-ac49-20e7f2823835','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','絲瓜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('05ef1af9-49ef-458a-9e0b-74870c7b29b6','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','苦瓜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('89ac2eaa-02ff-482e-8eb2-c986484cb129','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','扁蒲',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('90ce70da-ffd5-416e-9998-4336f006e694','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','茄子',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('11a6299f-4e51-4dab-9ef3-d641d292054c','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','番茄','crop_tomato.png')", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('c746557b-bc7a-4a6e-935f-b94283259091','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','甜椒',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('627d7e4a-4360-44f2-a23e-ca59f7c188aa','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','南瓜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('279d1a5d-2daf-46d5-80ce-1f487bad79c2','e863e9d1-fa85-4f21-9f87-594f1805f615','蔬菜類工作','菱角',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('4102c0ea-3de3-480b-9fc0-89e1abc3fb4c','e863e9d1-fa85-4f21-9f87-594f1805f615','攀爬蔬菜類工作','夏南瓜',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('e11265ef-cd55-49d3-982f-d3b543f4cbc8',null,null,'豆菜類',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('7bd53cef-ef0c-42ed-b196-2ef720609685','e11265ef-cd55-49d3-982f-d3b543f4cbc8','攀爬蔬菜類工作','豌豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('312294b3-5d0b-4d75-b97d-59e074630c3c','e11265ef-cd55-49d3-982f-d3b543f4cbc8','攀爬蔬菜類工作','豇豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('b5347d6e-b412-4840-a879-9005dfc38d84','e11265ef-cd55-49d3-982f-d3b543f4cbc8','攀爬蔬菜類工作','四季豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('6fb33fd4-3828-452a-8bb1-07e04923a34f','e11265ef-cd55-49d3-982f-d3b543f4cbc8','攀爬蔬菜類工作','皇帝豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('0d0188a9-44e3-40c1-95c5-eae3b5ec8c69','e11265ef-cd55-49d3-982f-d3b543f4cbc8','蔬菜類工作','毛豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('7953b1ed-0be2-43fd-b67f-7a5535ad65c6','e11265ef-cd55-49d3-982f-d3b543f4cbc8','蔬菜類工作','矮生長豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('f1929511-9833-4831-ac2f-dc442022ea67',null,null,'綠肥',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('aed36b57-f53d-450b-91f1-0575779dcca4','f1929511-9833-4831-ac2f-dc442022ea67',null,'大豆',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('9dba563c-3c2f-4198-815e-9bb62b9b3e08','aed36b57-f53d-450b-91f1-0575779dcca4','蔬菜類工作','高雄11號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('051f2246-fda7-485d-9a0d-1b82d32e44e6','aed36b57-f53d-450b-91f1-0575779dcca4','蔬菜類工作','台南4號',null)", @"INSERT INTO crop_items(id, parent_id, type, name, icon) VALUES ('588c4fd2-e382-4eec-bd66-dd1a7e304968','aed36b57-f53d-450b-91f1-0575779dcca4','蔬菜類工作','台南選1號',null)", nil];
    
    NSLog(@"[crop_items count]: %ld",[crop_items count]);
    for(int i=0; i<[crop_items count]; i++) {
        NSString *sql = [crop_items objectAtIndex:i];

        if (sqlite3_exec(Database, (const char*)[sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
            //NSLog(@"INSERT OK");
        } else {
            NSLog(@"INSERT failed: %s", errorMsg);
        }
    }

    //working_item 農務工作項目
    NSArray *working_item = [ [ NSArray alloc ] initWithObjects:
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('3ceb10ea-cfd8-4607-9773-1bc89ebe6203',null,'蟲害防治')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('a762e65e-4e8b-49ee-b627-a72b7becd924','3ceb10ea-cfd8-4607-9773-1bc89ebe6203','人為捕捉')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('3f0a6871-fe45-45de-8355-0589defe5e55','3ceb10ea-cfd8-4607-9773-1bc89ebe6203','生物機制')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('31098f1a-67d0-4769-9822-23c6b2050d08','3ceb10ea-cfd8-4607-9773-1bc89ebe6203','蓋網')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('4c7752dc-8254-4365-bddf-f2a5a84aa5f7','3ceb10ea-cfd8-4607-9773-1bc89ebe6203','藥物(化學or生物)')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('e0ad907c-4e0c-478b-b44c-29144052c97d',null,'病害防治')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('1c6247c4-e140-4305-9022-e6e6d3287534','e0ad907c-4e0c-478b-b44c-29144052c97d','化學藥物')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('9e8a50f7-ce13-4146-9b20-99fe38dea4da','e0ad907c-4e0c-478b-b44c-29144052c97d','生物機制')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('97644297-f44c-42d8-9193-fc5c47d6bd08','e0ad907c-4e0c-478b-b44c-29144052c97d','人為隔離')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('3e8876d7-dbee-4d0a-b637-a123c6f1f0cf',null,'病蟲害發現')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('cf92cec7-ef21-4214-8bf8-b21fb0921423','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','小菜蛾')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('aa1af52c-7953-4c6c-8eec-4604d3c436bc','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','切根蟲')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('e03e40a3-e5a9-41c9-8b4c-8089e1fc8351','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','苗立枯病')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('6db3aa37-6066-421a-9ba6-c9bc47cdd482','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','紋白蝶')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('e857ccce-e38c-4710-af36-f36f616abc53','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','蚜蟲類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('c106614b-2bcf-4b6e-843c-f1641456229f','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','斜紋夜盜蟲')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('46d75a4d-ff2c-4b0f-b7cd-967ecae8bf1c','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','甜菜夜蛾')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('310edb91-1a0e-45cb-ba0c-129afa718d74','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','細菌性病害')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('82c14e95-16e0-4040-a83e-208a49a04d5e','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','斑潛蠅')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('576ea557-e2f0-477d-80f9-217dcb346f25','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','黃條葉蚤')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('044bacc9-e351-4fc2-8e87-d80391637bf2','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','黑斑病')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('0bac6bdf-712b-4dac-a266-7a706e1a250a','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷天蛾類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('e0445dc3-e254-46ed-8d2c-847a2f4975c2','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷甘藷猿葉蟲')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('229f5ce5-3084-40f2-a27e-bee7e732a2d5','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷甘藷蟻象')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('cf67ee45-f646-438f-a8e5-eefb66feb495','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷夜蛾類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('ad46895e-b24e-4234-a8b3-bb781c827a68','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷粉蝨類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('dfd5860e-938c-4be8-9be5-4934f100be36','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷蚜蟲類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('2af4774b-d035-48cf-a6f7-770527c3ebb0','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷鳥羽蛾類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('fc12a7ee-7ffc-4f10-a17b-d875687c6b74','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷斑潛蠅類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('e7c15c33-abd5-4c44-8667-90ee95b48c88','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷象鼻蟲類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('cc1165f5-cb78-4494-bc4c-ca691fa0293a','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷葉蟎類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('845cb525-3fbf-41f2-b221-9932c2643cf0','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷潛葉蛾')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('0e0a6daf-b4a0-41e1-9daf-bc52424ee60e','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷蝦殼天蛾')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('294777e5-bca4-4ad9-bd4a-299d9bd32838','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷螟蛾')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('5d8f73c9-7e05-47a8-9de9-e897c96ec0b9','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉用甘藷螟蛾類')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('02fdf752-d6c4-4877-88ab-e3e4c976c032','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','葉斑病')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('126b611c-cc8c-43d5-ad02-d50f3d41b472','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','銀葉粉蝨')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('a7110ba7-4e2f-490a-9355-93d2ac81a649','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','露菌病')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('57779a61-d31b-4371-b635-08b763522c9d','3e8876d7-dbee-4d0a-b637-a123c6f1f0cf','白粉病')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('942c9337-cd52-4494-9341-7cd965f005e5',null,'土壤改良')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('1c636080-882a-42a3-af63-98036a3b4b7d','942c9337-cd52-4494-9341-7cd965f005e5','有機質')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('4b912f2b-c9c6-4ff0-83f3-fcfa1172735e','942c9337-cd52-4494-9341-7cd965f005e5','土壤結構')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('6a2f090c-b6ec-41e9-84b3-ce8ec0edd825','942c9337-cd52-4494-9341-7cd965f005e5','酸鹼值')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('1354e8d2-196c-446b-85bb-11076a1a2caa','942c9337-cd52-4494-9341-7cd965f005e5','營養素(氮磷鉀鋁等)')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('87c8f4b1-2594-4af9-a25b-04ab3d07dd2a',null,'整地(翻犁)')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('2c5fdb33-796c-4787-b74d-4fdda35b8397',null,'作畦')",
                             @"INSERT INTO working_item(id, parent_id, name) VALUES ('d727892b-cc7a-4c9a-93cb-fc54c5de6571',null,'中耕')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('dd6162d6-4a88-4117-8e34-ece9c7af098a',null,'鬆土')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('89da70fd-070d-4bc7-8e1b-f2911c1ecd23',null,'育苗')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('403efb1d-177d-4259-9194-00d93b7ad082',null,'播種')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('e3700b7c-b286-4924-83c8-a335763c81a0','403efb1d-177d-4259-9194-00d93b7ad082','灑播')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('58343931-4d42-4023-a03a-cae4b192d656','403efb1d-177d-4259-9194-00d93b7ad082','條播')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('aeb2f771-5237-428f-a81f-df0247c7ab7b','403efb1d-177d-4259-9194-00d93b7ad082','點播')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('78ed7683-0f90-4ff9-882c-9f5c52c3d540',null,'扦插')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('a5fc51f0-1b65-4bd8-a1ec-a2a0482b8534',null,'分株')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('042cf99c-3b0e-4a98-bcd5-dd077ca6e789',null,'牽藤(整蔓)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('75932c7e-4a64-46ce-bafb-c478979b26c4',null,'疏苗(間拔)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('9f555d54-9db4-42c5-adcc-6fc51bb5838c',null,'定植(移植)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('6d6ea853-384c-48d5-983b-d09adc77594f',null,'補植(補秧)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('62450064-9af1-42da-9501-31c7211878bd','62450064-9af1-42da-9501-31c7211878bd','灌溉')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('609cfadf-bc34-4c0e-9a11-3ab058e1ad90','62450064-9af1-42da-9501-31c7211878bd','淹灌')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('d633fe91-dc48-4e4d-bb64-be2b6f96fd90','62450064-9af1-42da-9501-31c7211878bd','溝灌')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('4cd2311b-b547-431a-855a-25feb8929ee5','62450064-9af1-42da-9501-31c7211878bd','澆灌')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('1d58ee56-bc34-493a-8dd1-75e50437c589','62450064-9af1-42da-9501-31c7211878bd','滴灌')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('500742a9-3ae8-4833-8508-f092d67e52a4',null,'施肥')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('b0b1ea2b-9104-45e7-a07d-c3b314bd3c9d',null,'培土')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('b8a0975e-b5ed-49a9-84d2-0cd57d88da25',null,'雜草防除')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('265c0fd4-4a2a-4ce2-97c5-f022712f8bec','b8a0975e-b5ed-49a9-84d2-0cd57d88da25','物理(連根拔起)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('72295227-b3eb-4029-9887-d15e72e92d6d','b8a0975e-b5ed-49a9-84d2-0cd57d88da25','物理(不連根拔起)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('32e63d6f-d7fe-4d41-8296-9d2679d243d6','b8a0975e-b5ed-49a9-84d2-0cd57d88da25','化學藥劑')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('cd84fed7-bdef-4d06-8934-2791cdca2d8e',null,'整枝(蔓)修剪')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('d876d716-7b84-48cb-9d01-4daecd9c97e4',null,'疏果')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('13a5ac83-9d8f-4296-9c95-558c302a1532',null,'套袋')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('2fb86549-cbcf-47a9-9f5c-7fdf105e25af',null,'授粉')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('8a964b31-b3cc-42b3-8261-d747ca770ad3','2fb86549-cbcf-47a9-9f5c-7fdf105e25af','飼養授粉昆蟲')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('26f927b4-e915-4c87-aef7-3e4bad871e28','2fb86549-cbcf-47a9-9f5c-7fdf105e25af','果實誘引')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('e8c376d2-8366-490e-9d3f-160f244b42d2','2fb86549-cbcf-47a9-9f5c-7fdf105e25af','人工授粉')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('7bbb9222-70a6-4823-8729-5ea23286a9d3',null,'高接')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('a0e8a1ce-bdc8-4013-8510-2c28a17ea7a4',null,'嫁接')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('f3f22dcc-6599-4880-a497-9a6a99932326',null,'採收')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('afc7455a-8727-4783-aac0-a90ff1510f84',null,'敷蓋')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('125c0111-aada-4821-b2c7-c3736667be5c','afc7455a-8727-4783-aac0-a90ff1510f84','架設')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('c2325375-2149-461f-a64d-0101e8f2baec','afc7455a-8727-4783-aac0-a90ff1510f84','移除')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('59f40daf-4436-4340-8aa4-2944dc123fbd',null,'遮陰')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('3e9bd465-fd15-4f4b-84dc-a4dbef27c55a','59f40daf-4436-4340-8aa4-2944dc123fbd','架設')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('880c6204-35ef-42ab-a3e8-b2a6253c749d','59f40daf-4436-4340-8aa4-2944dc123fbd','移除')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('34839dff-768c-4997-a1a7-31542131e552',null,'疏花')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('93463e20-d4d0-493d-8c61-d9b070acfb4c',null,'去死叢')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('70e52ad2-f8c6-43ba-8aa5-0eb4e3998720',null,'防曬')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('8d5c3eb7-54a2-41c2-9883-539f98cf8e15',null,'催花')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('4c722e4f-741b-4ead-a4df-4aefefd9399b',null,'收鳳梨帽')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('5936b191-c6ad-48a9-8248-4b3bce5eaf86',null,'搭架(網)')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('31c18378-3a03-466f-81d7-8247a58842dd','5936b191-c6ad-48a9-8248-4b3bce5eaf86','架設')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('ae3fff14-d05a-4031-a1f0-d84c474d6b26','5936b191-c6ad-48a9-8248-4b3bce5eaf86','移除')", @"INSERT INTO working_item(id, parent_id, name) VALUES ('a8d822ba-1b28-45a9-b599-92f6c2445ffd',null,'其他')", nil];

    for(int i=0; i<[working_item count]; i++) {
        NSString *sql = [working_item objectAtIndex:i];

         if (sqlite3_exec(Database, (const char*)[sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
             //NSLog(@"INSERT OK");
         } else {
             NSLog(@"INSERT failed: %s", errorMsg);
         }
    }
    
    //farming_item 土壤改良資材
    NSArray *farming_item = [ [ NSArray alloc ] initWithObjects: @"INSERT INTO farming_item(id, parent_id, name) VALUES ('f291aac0-70a8-4150-b888-5afd5f86759f',null,'有機肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('8c2d517c-564c-43e7-a1a8-5d73283fff1d','f291aac0-70a8-4150-b888-5afd5f86759f','台肥生技1號有機肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('0e75ee11-cbd2-430d-baf9-74122cab50fa','f291aac0-70a8-4150-b888-5afd5f86759f','台肥生技3號有機肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('107938b4-eda2-4a32-a55f-da06c67c4c35','f291aac0-70a8-4150-b888-5afd5f86759f','台肥生技5號有機肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('6068c7ac-970a-4930-8ab1-aa8974363959','f291aac0-70a8-4150-b888-5afd5f86759f','台肥生技11號有機肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('34b5afca-b083-4780-8930-f892b59e88b9','f291aac0-70a8-4150-b888-5afd5f86759f','台肥2號有機肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('b83150a8-b72a-49ea-bb3d-b8addd30add0','f291aac0-70a8-4150-b888-5afd5f86759f','禽畜糞堆肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('1a876f99-1c35-44c1-869c-594d17f2f357','f291aac0-70a8-4150-b888-5afd5f86759f','乾雞糞')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('1698d499-ae1d-43ce-a552-5208297f0414','f291aac0-70a8-4150-b888-5afd5f86759f','草木灰')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('df94f1bf-9fb1-4843-b945-0e1ee4f96956','f291aac0-70a8-4150-b888-5afd5f86759f','矽酸爐渣')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('a2a5f0e8-261b-4e04-aa5f-6cdf4b7891d3','f291aac0-70a8-4150-b888-5afd5f86759f','花生粕')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('7b5be846-12f6-47bf-86d2-645ff1c20f8d','f291aac0-70a8-4150-b888-5afd5f86759f','大豆粕')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('f2862715-3ed9-4fde-a9e7-1ce6be399d80','f291aac0-70a8-4150-b888-5afd5f86759f','米糠')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('2870f2df-6571-4e21-8168-1222c2c59c90','f291aac0-70a8-4150-b888-5afd5f86759f','其他')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('b0467f96-25f0-433e-a526-a0eb48df6515',null,'化學肥料')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('c93a66e3-7bb7-4b71-b88b-708df3ab81ba','b0467f96-25f0-433e-a526-a0eb48df6515','硫酸銨')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('cb765ccf-5ef4-41c1-b8fb-516a78b110cc','b0467f96-25f0-433e-a526-a0eb48df6515','尿素')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('3d56ec58-5612-4216-82c4-71bb53cd5295','b0467f96-25f0-433e-a526-a0eb48df6515','過磷酸鈣')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('95da0032-be00-4592-8cf5-29b75c257a11','b0467f96-25f0-433e-a526-a0eb48df6515','硫酸鉀')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('573e152a-9ffb-430f-91b6-de3ca5ce491e','b0467f96-25f0-433e-a526-a0eb48df6515','氯化鉀')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('22f6cafd-3d83-4970-8fa2-29d419bf19f1','b0467f96-25f0-433e-a526-a0eb48df6515','台肥1號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('1f93db03-7265-4821-826a-9f852ffcac06','b0467f96-25f0-433e-a526-a0eb48df6515','台肥特1號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('e31c5a24-ddb1-4ecf-8a62-8e7c6f29987f','b0467f96-25f0-433e-a526-a0eb48df6515','台肥2號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('2ec29b4f-272d-4a99-9719-a764bb197e42','b0467f96-25f0-433e-a526-a0eb48df6515','台肥特4號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('62f549ef-499d-4088-955c-83466867be45','b0467f96-25f0-433e-a526-a0eb48df6515','台肥5號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('bda38ec7-e10b-4885-aa94-6439d203d8ba','b0467f96-25f0-433e-a526-a0eb48df6515','台肥特5號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('adf5258c-c7c6-4764-8e6e-8c5050017594','b0467f96-25f0-433e-a526-a0eb48df6515','台肥25號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('62ae4fee-53f2-4a07-ac9f-b9162a856a2d','b0467f96-25f0-433e-a526-a0eb48df6515','台肥36號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('026cde2a-26ce-4c7f-93af-b7ba4346ec0e','b0467f96-25f0-433e-a526-a0eb48df6515','台肥39號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('1b9a0842-2778-4bcb-820f-3c67ee9c48ea','b0467f96-25f0-433e-a526-a0eb48df6515','台肥42號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('9d62516e-80ac-497e-96af-2c8100dff1bf','b0467f96-25f0-433e-a526-a0eb48df6515','台肥特42號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('5de7a2fe-1132-4d22-bc13-f6e362124bcd','b0467f96-25f0-433e-a526-a0eb48df6515','台肥43號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('b891a7ae-0ea4-45ff-9f4f-401ee28da748','b0467f96-25f0-433e-a526-a0eb48df6515','台肥特43號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('4bc1cf03-b9e9-49b7-bede-92002a6e00a7','b0467f96-25f0-433e-a526-a0eb48df6515','台肥47號複合肥')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('d748610f-3f6d-4d66-adbe-033c69249dea','b0467f96-25f0-433e-a526-a0eb48df6515','台肥有機複合肥寶效1號')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('83b19770-be4e-42cb-a6a6-7621dfecbbd6','b0467f96-25f0-433e-a526-a0eb48df6515','台肥有機複合肥寶效2號')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('4c478b4b-e93c-4091-a54e-e0e541fa9b59','b0467f96-25f0-433e-a526-a0eb48df6515','其他')", @"INSERT INTO farming_item(id, parent_id, name) VALUES ('3fc67745-abb9-4cd2-aa8c-ad210ebcc563',null,'微生物製劑')", nil];
    
    for(int i=0; i<[farming_item count]; i++) {
        NSString *sql = [farming_item objectAtIndex:i];

         if (sqlite3_exec(Database, (const char*)[sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
             //NSLog(@"INSERT OK");
         } else {
             NSLog(@"INSERT failed: %s", errorMsg);
         }
    }
    
    //machine_item 使用農機具
    NSArray *machine_item = [ [ NSArray alloc ] initWithObjects: @"INSERT INTO machine_item(name) VALUES ('農具機可附掛機具')", @"INSERT INTO machine_item(name) VALUES ('農具機不可附掛機具')", @"INSERT INTO machine_item(name) VALUES ('農耕機')", @"INSERT INTO machine_item(name) VALUES ('播種機')", @"INSERT INTO machine_item(name) VALUES ('肥料散佈器')", @"INSERT INTO machine_item(name) VALUES ('中耕機')", @"INSERT INTO machine_item(name) VALUES ('抽水馬達')", @"INSERT INTO machine_item(name) VALUES ('背負式噴藥桶')", @"INSERT INTO machine_item(name) VALUES ('其他')", nil];
    
    for(int i=0; i<[machine_item count]; i++) {
        NSString *sql = [machine_item objectAtIndex:i];

         if (sqlite3_exec(Database, (const char*)[sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
             //NSLog(@"INSERT OK");
         } else {
             NSLog(@"INSERT failed: %s", errorMsg);
         }

    }
}

@end
