//
//  noteDetailVC.m
//  agrinote
//
//  Created by VimyHsieh on 2017/11/9.
//  Copyright © 2017年 agri. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "noteDetailVC.h"
#import "FTPopOverMenu/FTPopOverMenu.h"
#import "fieldInfo.h"
#import "connectSQLite.h"

@interface noteDetailVC ()

@end

#define kOFFSET_FOR_KEYBOARD 300.0

@implementation noteDetailVC
@synthesize noteBaseInfo, noteImageInfo;
@synthesize addEvent;
@synthesize selectedNoteID;
@synthesize selectedCropID, selectedCropName;

BOOL needtoSave;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDefault];
    
    [self adjustUIView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(!addEvent) {
        /* 詢問日誌 */
        [self connectSQLite:1502];
    }
    
    /* 查詢作物圖示 */
    [self connectSQLite:1601];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setDefault {

    //init
    selectedWorkingItemID = @"";
    
    WorkingItemList = [[NSMutableArray alloc] init];
}

- (void)adjustUIView
{
    float distance_eachView = 10.0;
    
    /* ==== 調整 noteBaseInfo === */
    self.noteBaseInfo.layer.masksToBounds = YES;
    self.noteBaseInfo.layer.cornerRadius = 10.0;
    self.noteBaseInfo.alpha = 0.7;
    
    /* ==== 調整 noteImageInfo === */
    self.noteImageInfo.frame = CGRectMake(self.noteImageInfo.frame.origin.x, self.noteBaseInfo.frame.origin.y+self.noteBaseInfo.frame.size.height+distance_eachView, self.noteImageInfo.frame.size.width, self.noteImageInfo.frame.size.height);
    
    self.noteImageInfo.layer.masksToBounds = YES;
    self.noteImageInfo.layer.cornerRadius = 10.0;
    self.noteImageInfo.alpha = 0.8;
    
    /* ==== 調整 scrollview === */
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    scrollview.frame = CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height);
    scrollview.scrollEnabled = YES;
    scrollview.contentSize=CGSizeMake(320,758);
    scrollview.contentInset=UIEdgeInsetsMake(0.0,0.0,44.0,0.0);
    scrollview.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
}

- (IBAction)SaveAction:(id)sender
{
    if(addEvent) {
        
        /* 新增日誌 */
        [self connectSQLite:1501];
    } else {
        
        /* 更新日誌 */
        [self connectSQLite:1503];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(Boolean)connectSQLite:(NSInteger)transType {
    switch (transType) {
        case 1501: { //新增日誌
            
            fieldInfo *data = [[fieldInfo alloc] initWithNoteDB:@"0" andItem:noteWorkItem.titleLabel.text andRemark:noteRemark.text andImg:@"nil" andRecordDate:noteRecordDate.text andUseQuantity:noteUseQuantity.text andUseUnit:noteUseUnit.text andUseDilutionMultiple:noteUseDilutionMultiple.text andFarmMaterials:noteFarmMaterials.titleLabel.text andFarmMaterialsFee:noteFarmMaterialsFee.text andCropID:selectedCropID];
            
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:data forKey:@"dbData"];
            [connectSQL accessSQLite:1501 andParam:params];
            break;
        }
        case 1502: { //查詢日誌
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            [params setObject:selectedNoteID forKey:@"dbData"];
            NSMutableArray *list = [connectSQL accessSQLite:1502 andParam:params];
            
            if ([list count]) {
                NSDictionary *entry = [list objectAtIndex:0];
                
                //notes from db
                fieldInfo *note = [[fieldInfo alloc] initWithNoteDB:[entry objectForKey:@"noteID"] andItem:[entry objectForKey:@"noteWorkItem"] andRemark:[entry objectForKey:@"noteRemark"] andImg:[entry objectForKey:@"notePhoto"] andRecordDate:[entry objectForKey:@"noteRecordDate"] andUseQuantity:[entry objectForKey:@"noteUseQuantity"] andUseUnit:[entry objectForKey:@"noteUseUnit"] andUseDilutionMultiple:[entry objectForKey:@"noteUseDilutionMultiple"] andFarmMaterials:[entry objectForKey:@"noteFarmMaterials"] andFarmMaterialsFee:[entry objectForKey:@"noteFarmMaterialsFee"] andCropID:[entry objectForKey:@"cropID"]];
                
                noteRecordDate.text = note.noteRecordDate; //記錄時間
                [noteWorkItem setTitle: note.noteItem forState: UIControlStateNormal]; //工作項目
                noteRemark.text = note.noteRemark; //工作備註
                noteUseQuantity.text = note.noteUseQuantity; //使用次/量
                noteUseUnit.text = note.noteUseUnit; //使用單位
                noteUseDilutionMultiple.text = note.noteUseDilutionMultiple; //稀釋倍數
                [noteFarmMaterials setTitle: note.noteFarmMaterials forState: UIControlStateNormal]; //使用資材
                noteFarmMaterialsFee.text = note.noteFarmMaterialsFee; //使用資材費用
                //照片 notePic
            }
            break;
        }
        case 1503: { //更新日誌
            fieldInfo *data = [[fieldInfo alloc] initWithNoteDB:selectedNoteID andItem:@"1" andRemark:noteRemark.text andImg:@"nil" andRecordDate:noteRecordDate.text andUseQuantity:noteUseQuantity.text andUseUnit:noteUseUnit.text andUseDilutionMultiple:noteUseDilutionMultiple.text andFarmMaterials:@"1"andFarmMaterialsFee:noteFarmMaterialsFee.text andCropID:selectedCropID];
            
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:data forKey:@"dbData"];
            [connectSQL accessSQLite:1503 andParam:params];
            break;
        }
        case 1601: { //查詢作物圖示
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:selectedCropName forKey:@"dbData"];
 
            NSMutableArray *list = [connectSQL accessSQLite:1601 andParam:params];

            NSData *icon = [list objectAtIndex:0];
            cropIcon.image = [UIImage imageWithData:icon];
            break;
        }
        case 1700: { //查詢農務工作主項目
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableArray *list = [connectSQL accessSQLite:1700 andParam:nil];
            
            [WorkingItemList removeAllObjects];

            if ([list count]) {
                
                for (int i=0; i<[list count]; i++) {
                    NSDictionary *entry = [list objectAtIndex:i];
                    fieldInfo *workItem = [[fieldInfo alloc] initWithWorkItemListDB:[entry objectForKey:@"workingItemID"] andWorkItem:[entry objectForKey:@"workingItemName"]];
                    [WorkingItemList addObject:workItem];
                }
            }

            break;
        }
        case 1701: { //查詢農務工作附項目
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:selectedWorkingItemID forKey:@"dbData"];
            NSMutableArray *list = [connectSQL accessSQLite:1700 andParam:params];
            if ([list count]) {
                
                for (int i=0; i<[list count]; i++) {
                    NSDictionary *entry = [list objectAtIndex:i];
                    NSLog(@"ID: %@, Name: %@", [entry objectForKey:@"workingItemID"], [entry objectForKey:@"workingItemName"]);
                }
            }
            
            break;
        }
        default:
            break;
    }
    return YES;
}

- (IBAction)selectPhotoWayAction:(id)sender
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuRowHeight = 50;
    configuration.menuWidth = 120;
    configuration.textColor = [UIColor whiteColor];
    configuration.textFont = [UIFont boldSystemFontOfSize:14];
    configuration.tintColor = [UIColor blackColor];
    configuration.borderColor = [UIColor darkGrayColor];
    configuration.borderWidth = 0.5;
    configuration.allowRoundedArrow = YES;
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:@[@"拍攝照片", @"選取相簿"]
                      imageArray:@[[UIImage imageNamed:@"camera"], [UIImage imageNamed:@"album"]]
                       doneBlock:^(NSInteger selectedIndex) {
                           
                           NSLog(@"done block. do something. selectedIndex : %ld", (long)selectedIndex);
                           
                           switch (selectedIndex) {
                               case 0: {
                                   break;
                               }
                               case 1:
                                   break;
                               default:
                                   break;
                           }
                           
                       } dismissBlock:^{
                           
                           NSLog(@"user canceled. do nothing.");
                       }];
}

@end
