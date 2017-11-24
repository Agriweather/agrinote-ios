//
//  fieldInfo.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/3.
//  Copyright © 2017年 agri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fieldInfo : NSObject

@property (strong, nonatomic) NSString *userID;

@property (strong, nonatomic) NSString *farmID;
@property (strong, nonatomic) NSString *farmName;
@property (strong, nonatomic) NSString *farmImg;
@property (strong, nonatomic) NSString *farmLandNum;
@property (strong, nonatomic) NSMutableArray *farmCrops;
@property (strong, nonatomic) NSString *farmAddress;
@property (strong, nonatomic) NSString *farmLatitude;
@property (strong, nonatomic) NSString *farmLongitude;
@property (strong, nonatomic) NSString *farmPlantDate; //開始耕作日期

@property (strong, nonatomic) NSString *sensorID;

@property (strong, nonatomic) NSString *cropID;
@property (strong, nonatomic) NSString *cropName;
@property (strong, nonatomic) NSString *cropItem;
@property (strong, nonatomic) NSString *cropVar;
@property (strong, nonatomic) NSString *cropImg;
@property (strong, nonatomic) NSData *cropIcon; //作物圖示
@property (strong, nonatomic) NSString *cropPlantDate;
@property (strong, nonatomic) NSString *cropWorkDate;
@property (strong, nonatomic) NSString *cropWorkItem;
@property (nonatomic) BOOL cropAlert;
@property (strong, nonatomic) NSString *cropPeriod;
@property (strong, nonatomic) NSString *cropNo; //作物個數
@property (strong, nonatomic) NSMutableArray *crops;

@property (strong, nonatomic) NSString *noteID;
@property (strong, nonatomic) NSString *noteDateTime;
@property (strong, nonatomic) NSString *noteImg;
@property (strong, nonatomic) NSString *noteItem;
@property (strong, nonatomic) NSString *noteRemark;
@property (strong, nonatomic) NSString *noteRecordDate;
@property (strong, nonatomic) NSString *noteUseQuantity;
@property (strong, nonatomic) NSString *noteUseUnit;
@property (strong, nonatomic) NSString *noteUseDilutionMultiple;
@property (strong, nonatomic) NSString *noteFarmMaterials;
@property (strong, nonatomic) NSString *noteFarmMaterialsFee;

@property (strong, nonatomic) NSString *workItemID; //農務工作主項目ID
@property (strong, nonatomic) NSString *workItemName; //農務工作主項目

//for database: farm
-(id)initWithFarmDB:(NSString *)theID andName:(NSString *)theName andLandNum:(NSString *)theLandNum andSensorID:(NSString *)theSensorID andPlantDate:(NSString *)thePlantDate andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude andAddress:(NSString *)theAddress andImg:(NSString *)theImg andUserID:(NSString *)theUserID;

//for database: crop
-(id)initWithCropDB:(NSString *)theID andPeriod:(NSString *)thePeriod andName:(NSString *)theName andItem:(NSString *)theItem andVar:(NSString *)theVar andPlantDate:(NSString *)thePlantDate andImg:(NSString *)theImg andFarmID:(NSString *)theFarmID;

//for database: note
-(id)initWithNoteDB:(NSString *)theID andItem:(NSString *)theItem andRemark:(NSString *)theRemark andImg:(NSString *)theImg andRecordDate:(NSString *)theRecordDate andUseQuantity:(NSString *)theUseQuantity andUseUnit:(NSString *)theUseUnit andUseDilutionMultiple:(NSString *)theUseDilutionMultiple andFarmMaterials:(NSString *)theFarmMaterials andFarmMaterialsFee:(NSString *)theFarmMaterialsFee andCropID:(NSString *)theCropID;

//for database: farm list
-(id)initWithFarmListDB:(NSString *)theID andName:(NSString *)theName andLandNum:(NSString *)theLandNum andSensorID:(NSString *)theSensorID andPlantDate:(NSString *)thePlantDate andLatitude:(NSString *)theLatitude andLongitude:(NSString *)theLongitude andAddress:(NSString *)theAddress andImg:(NSString *)theImg andCropNo:(NSString *)theCropNo andUserID:(NSString *)theUserID;

//for database: crop list
-(id)initWithCropListDB:(NSString *)theID andPeriod:(NSString *)thePeriod andName:(NSString *)theName andItem:(NSString *)theItem andVar:(NSString *)theVar andPlantDate:(NSString *)thePlantDate andImg:(NSString *)theImg andIcon:(NSData *)theIcon andLastWorkDate:(NSString *)theLastWorkDate andLastWorkItem:(NSString *)theLastWorkItem andFarmID:(NSString *)theFarmID;

//for database: work item list
-(id)initWithWorkItemListDB:(NSString *)theID andWorkItem:(NSString *)theWorkItem;
@end
