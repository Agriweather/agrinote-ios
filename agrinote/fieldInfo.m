//
//  fieldInfo.m
//  agrinote
//
//  Created by VimyHsieh on 2017/11/3.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "fieldInfo.h"

@implementation fieldInfo
@synthesize userID;
@synthesize farmID, farmName, farmImg, farmLandNum, farmCrops, farmAddress, farmLatitude, farmLongitude, farmPlantDate;
@synthesize cropID, cropName, cropItem, cropVar, cropImg, cropIcon, cropPlantDate, cropWorkDate, cropWorkItem, cropAlert, cropPeriod, cropNo;
@synthesize noteID, noteDateTime, noteImg, noteItem, noteRemark, noteRecordDate, noteUseQuantity, noteUseUnit, noteUseDilutionMultiple, noteFarmMaterials, noteFarmMaterialsFee;
@synthesize workItemID, workItemName;
@synthesize sensorID;

//for database: farm
-(id)initWithFarmDB:(NSString *)theID andName:(NSString *)theName andLandNum:(NSString *)theLandNum andSensorID:(NSString *)theSensorID andPlantDate:(NSString *)thePlantDate andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude andAddress:(NSString *)theAddress andImg:(NSString *)theImg andUserID:(NSString *)theUserID {
    
    self = [super init];
    
    if(self){
        self.farmID = theID;
        self.farmName = theName;
        self.farmLandNum = theLandNum;
        self.sensorID = theSensorID;
        self.farmPlantDate = thePlantDate;
        self.farmLatitude = theLatitude;
        self.farmLongitude = theLongitude;
        self.farmAddress = theAddress;
        self.farmImg = theImg;
        self.userID = theUserID;
    }
    
    return self;
}

//for database: crop
-(id)initWithCropDB:(NSString *)theID andPeriod:(NSString *)thePeriod andName:(NSString *)theName andItem:(NSString *)theItem andVar:(NSString *)theVar andPlantDate:(NSString *)thePlantDate andImg:(NSString *)theImg andFarmID:(NSString *)theFarmID {
    
    self = [super init];
    
    if(self){
        self.cropID = theID;
        self.cropPeriod = thePeriod;
        self.cropName = theName;
        self.cropItem = theItem; //作物品項
        self.cropVar = theVar; //作物品種
        self.cropPlantDate = thePlantDate;
        self.cropImg = theImg;
        
        self.farmID = theFarmID;
    }

    return self;
}

//for database: note
-(id)initWithNoteDB:(NSString *)theID andItem:(NSString *)theItem andRemark:(NSString *)theRemark andImg:(NSString *)theImg andRecordDate:(NSString *)theRecordDate andUseQuantity:(NSString *)theUseQuantity andUseUnit:(NSString *)theUseUnit andUseDilutionMultiple:(NSString *)theUseDilutionMultiple andFarmMaterials:(NSString *)theFarmMaterials andFarmMaterialsFee:(NSString *)theFarmMaterialsFee andCropID:(NSString *)theCropID {
    
    self = [super init];
    
    if(self){
        self.noteID = theID;
        self.noteItem = theItem;
        self.noteRemark = theRemark;
        self.noteImg = theImg;
        self.noteRecordDate = theRecordDate;
        self.noteUseQuantity = theUseQuantity;
        self.noteUseUnit = theUseUnit;
        self.noteUseDilutionMultiple = theUseDilutionMultiple;
        self.noteFarmMaterials = theFarmMaterials;
        self.noteFarmMaterialsFee = theFarmMaterialsFee;
        
        self.cropID = theCropID;
    }
    
    return self;
}

//for database: farm list
-(id)initWithFarmListDB:(NSString *)theID andName:(NSString *)theName andLandNum:(NSString *)theLandNum andSensorID:(NSString *)theSensorID andPlantDate:(NSString *)thePlantDate andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude andAddress:(NSString *)theAddress andImg:(NSString *)theImg andCropNo:(NSString *)theCropNo andUserID:(NSString *)theUserID {
    
    self = [super init];
    
    if(self){
        self.farmID = theID;
        self.farmName = theName;
        self.farmLandNum = theLandNum;
        self.sensorID = theSensorID;
        self.farmPlantDate = thePlantDate;
        self.farmLatitude = theLatitude;
        self.farmLongitude = theLongitude;
        self.farmAddress = theAddress;
        self.farmImg = theImg;
        
        self.cropNo = theCropNo;
        
        self.userID = theUserID;
    }
    
    return self;
}

//for database: crop list
-(id)initWithCropListDB:(NSString *)theID andPeriod:(NSString *)thePeriod andName:(NSString *)theName andItem:(NSString *)theItem andVar:(NSString *)theVar andPlantDate:(NSString *)thePlantDate andImg:(NSString *)theImg andIcon:(NSData *)theIcon andLastWorkDate:(NSString *)theLastWorkDate andLastWorkItem:(NSString *)theLastWorkItem andFarmID:(NSString *)theFarmID {
    
    self = [super init];
    
    if(self){
        self.cropID = theID;
        self.cropPeriod = thePeriod;
        self.cropName = theName;
        self.cropItem = theItem; //作物品項
        self.cropVar = theVar; //作物品種
        self.cropPlantDate = thePlantDate;
        self.cropImg = theImg;
        self.cropIcon = theIcon;
        
        self.noteDateTime = theLastWorkDate;
        self.noteItem = theLastWorkItem;
        
        self.farmID = theFarmID;
    }
    
    return self;
}

//for database: work item list
-(id)initWithWorkItemListDB:(NSString *)theID andWorkItem:(NSString *)theWorkItem {
    self = [super init];
    
    if(self){
        self.workItemID = theID;
        self.workItemName = theWorkItem;
    }
    
    return self;
}
@end
