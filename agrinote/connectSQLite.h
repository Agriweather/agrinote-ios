//
//  connectSQLite.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/18.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "JSONKit.h"

@interface connectSQLite : NSObject{
    
}

-(NSMutableArray *)accessSQLite:(NSInteger)type andParam:(NSMutableDictionary *)params;
@end
