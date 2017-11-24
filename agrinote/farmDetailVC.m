//
//  farmDetailVC.m
//  agrinote
//
//  Created by VimyHsieh on 2017/10/30.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "farmDetailVC.h"
#import "FTPopOverMenu/FTPopOverMenu.h"
#import "fieldInfo.h"
#import "connectSQLite.h"

@interface farmDetailVC ()

@end

@implementation farmDetailVC
@synthesize farmBaseInfo, farmImageInfo;
@synthesize selectedFarmID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self adjustUIView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)adjustUIView
{
    float distance_eachView = 10.0;
    
    /* ==== 調整 farmBaseInfo === */
    self.farmBaseInfo.layer.masksToBounds = YES;
    self.farmBaseInfo.layer.cornerRadius = 10.0;
    self.farmBaseInfo.alpha = 0.7;
    
    /* ==== 調整 farmImageInfo === */
    self.farmImageInfo.frame = CGRectMake(self.farmImageInfo.frame.origin.x, self.farmBaseInfo.frame.origin.y+self.farmBaseInfo.frame.size.height+distance_eachView, self.farmImageInfo.frame.size.width, self.farmImageInfo.frame.size.height);
    
    self.farmImageInfo.layer.masksToBounds = YES;
    self.farmImageInfo.layer.cornerRadius = 10.0;
    self.farmImageInfo.alpha = 0.8;
    
    /* ==== 調整 farmMapInfo === */
    self.farmMapInfo.frame = CGRectMake(self.farmMapInfo.frame.origin.x, self.farmImageInfo.frame.origin.y+self.farmImageInfo.frame.size.height+distance_eachView, self.farmMapInfo.frame.size.width, self.farmMapInfo.frame.size.height);
    
    self.farmMapInfo.layer.masksToBounds = YES;
    self.farmMapInfo.layer.cornerRadius = 10.0;
    self.farmMapInfo.alpha = 0.8;
    
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
    /* 新增農田 */
    [self connectSQLite:1301];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(Boolean)connectSQLite:(NSInteger)transType {
    switch (transType) {
        case 1301: { //新增農田
            
            fieldInfo *data = [[fieldInfo alloc] initWithFarmDB:@"1" andName:farmName.text andLandNum:farmLandNum.text andSensorID:@"1" andPlantDate:farmPlantDate.text andLatitude:@"1" andLongitude:@"1" andAddress:farmAddress.text andImg:@"nil" andUserID:@"1"];
            
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:data forKey:@"dbData"];
            [connectSQL accessSQLite:1301 andParam:params];
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
                                   NSLog(@"case 0");
                                   
                                   break;
                               }
                               case 1:
                                   NSLog(@"case 1");
                                   
                                   break;
                               default:
                                   break;
                           }
                           
                       } dismissBlock:^{
                           
                           NSLog(@"user canceled. do nothing.");
                       }];
}

@end
