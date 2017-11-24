//
//  cropDetailVC.m
//  agrinote
//
//  Created by VimyHsieh on 2017/10/30.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "cropDetailVC.h"
#import "FTPopOverMenu/FTPopOverMenu.h"
#import "fieldInfo.h"
#import "connectSQLite.h"

@interface cropDetailVC ()

@end

@implementation cropDetailVC
@synthesize cropBaseInfo, cropImageInfo;
@synthesize selectedFarmID;
@synthesize selectedCropID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustUIView];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)adjustUIView
{
    float distance_eachView = 10.0;
    
    /* ==== 調整 cropBaseInfo === */
    self.cropBaseInfo.layer.masksToBounds = YES;
    self.cropBaseInfo.layer.cornerRadius = 10.0;
    self.cropBaseInfo.alpha = 0.7;
    
    /* ==== 調整 cropImageInfo === */
    self.cropImageInfo.frame = CGRectMake(self.cropImageInfo.frame.origin.x, self.cropBaseInfo.frame.origin.y+self.cropBaseInfo.frame.size.height+distance_eachView, self.cropImageInfo.frame.size.width, self.cropImageInfo.frame.size.height);
    
    self.cropImageInfo.layer.masksToBounds = YES;
    self.cropImageInfo.layer.cornerRadius = 10.0;
    self.cropImageInfo.alpha = 0.8;
    
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
    /* 新增作物 */
    [self connectSQLite:1401];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(Boolean)connectSQLite:(NSInteger)transType {
    switch (transType) {
        case 1401: { //新增作物
            fieldInfo *data = [[fieldInfo alloc] initWithCropDB:@"1" andPeriod:cropPeriod.text andName:cropName.text andItem:cropItem.text andVar:cropVar.text andPlantDate:cropPlantDate.text andImg:@"nil" andFarmID:selectedFarmID];
            
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:data forKey:@"dbData"];
            [connectSQL accessSQLite:1401 andParam:params];
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
