//
//  connectSQLite.m
//  agrinote
//
//  Created by VimyHsieh on 2017/11/18.
//  Copyright © 2017年 agri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "connectSQLite.h"
#import "database.h"

@implementation connectSQLite

-(NSMutableArray *)accessSQLite:(NSInteger)type andParam:(NSMutableDictionary *)params {
    NSMutableArray *data = NULL;
    
    switch (type) {
        case 1000: //建立帳號
            
            break;
        case 1001: //用戶登入
            
            break;
        case 1002: //用戶登出
            
            break;
        case 1100: //註冊推播
            
            break;
        case 1101: //解除註冊推播
            
            break;
        case 1200: //上傳照片
            
            break;
        case 1300: //查詢農田列表
            data = [self accessSQL1300];
            break;
        case 1301: //新增農田資訊
            data = [self accessSQL1301:params];
            break;
        case 1302: //查詢農田資訊
            
            break;
        case 1303: //更新農田資訊
            
            break;
        case 1304: //刪除農田資訊
            
            break;
        case 1400: //查詢農作物列表
            data = [self accessSQL1400:params];
            break;
        case 1401: //新增農作物資訊
            data = [self accessSQL1401:params];
            break;
        case 1402: //查詢農作物資訊
            
            break;
        case 1403: //更新農作物資訊
            
            break;
        case 1404: //刪除農作物資訊
            
            break;
        case 1500: //查詢日誌列表
            data = [self accessSQL1500:params];
            break;
        case 1501: //新增日誌
            data = [self accessSQL1501:params];
            break;
        case 1502: //查詢日誌
            data = [self accessSQL1502:params];
            break;
        case 1503: //更新日誌
            data = [self accessSQL1503:params];
            break;
        case 1504: //刪除日誌
            
            break;
        case 1600: //查詢作物種類
            
            break;
        case 1601: //查詢作物圖示
            data = [self accessSQL1601:params];
            break;
        case 1700: //查詢農務工作主項目
            data = [self accessSQL1700];
            break;
        case 1701: //查詢農務工作附項目
            data = [self accessSQL1701:params];
            break;
        case 1800: //查詢土壤改良資材
            
            break;
        case 1900: //查詢使用農機具
            
            break;
        case 2000: //取得系統資訊
            
            break;
        default:
            break;
    }
    
    return data;
}

-(NSMutableArray *)accessSQL1300 { //查詢農田列表
    database *db = [[database alloc] init];
    [db openSQL];
    NSMutableArray *data = [db selectFarmList];
    [db closeSQL];

    return data;
}

-(NSMutableArray *)accessSQL1301: (NSMutableDictionary *)params { //新增農田資訊
    database *db = [[database alloc] init];
    [db openSQL];
    [db insertFarmData:[params objectForKey:@"dbData"]];
    [db closeSQL];

    NSMutableArray *data = [[NSMutableArray alloc] init];
    return data;
}

-(NSMutableArray *)accessSQL1400: (NSMutableDictionary *)params { //查詢農作物列表
    database *db = [[database alloc] init];
    [db openSQL];
    NSMutableArray *data = [db selectCropList:[params objectForKey:@"dbData"]];
    [db closeSQL];

    return data;
}

-(NSMutableArray *)accessSQL1401: (NSMutableDictionary *)params { //新增農作物資訊
    database *db = [[database alloc] init];
    [db openSQL];
    [db insertCropData:[params objectForKey:@"dbData"]];
    [db closeSQL];

    NSMutableArray *data = [[NSMutableArray alloc] init];
    return data;
}

-(NSMutableArray *)accessSQL1500: (NSMutableDictionary *)params { //查詢日誌列表
    database *db = [[database alloc] init];
    [db openSQL];
    NSMutableArray *data = [db selectNoteList:[params objectForKey:@"dbData"]];
    [db closeSQL];

    return data;

}

-(NSMutableArray *)accessSQL1501: (NSMutableDictionary *)params { //新增日誌
    database *db = [[database alloc] init];
    [db openSQL];
    [db insertNoteData:[params objectForKey:@"dbData"]];
    [db closeSQL];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    return data;
}

-(NSMutableArray *)accessSQL1502: (NSMutableDictionary *)params { //查詢日誌
    database *db = [[database alloc] init];
    [db openSQL];
    NSMutableArray *data = [db selectNoteData:[params objectForKey:@"dbData"]];
    [db closeSQL];
    
    return data;

}

-(NSMutableArray *)accessSQL1503: (NSMutableDictionary *)params { //更新日誌
    database *db = [[database alloc] init];
    [db openSQL];
    [db updateNoteData:[params objectForKey:@"dbData"]];
    [db closeSQL];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    return data;
}

-(NSMutableArray *)accessSQL1601: (NSMutableDictionary *)params { //查詢作物圖示
    database *db = [[database alloc] init];
    [db openSQL];
    NSData *icon = [db selectCropIcon:[params objectForKey:@"dbData"]];
    [db closeSQL];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObject: icon];
    return data;
}

-(NSMutableArray *)accessSQL1700 { //查詢農務工作主項目
    database *db = [[database alloc] init];
    [db openSQL];
    NSMutableArray *data = [db selectWorkingItem];
    [db closeSQL];
    
    return data;

}

-(NSMutableArray *)accessSQL1701: (NSMutableDictionary *)params { //查詢農務工作附項目
    database *db = [[database alloc] init];
    [db openSQL];
    NSMutableArray *data = [db selectWorkingItem:[params objectForKey:@"dbData"]];
    [db closeSQL];

    return data;

}
@end
