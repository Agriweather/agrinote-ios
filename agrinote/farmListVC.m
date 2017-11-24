//
//  farmListVC.m
//  agrinote
//
//  Created by VimyHsieh on 2017/10/25.
//  Copyright © 2017年 agri. All rights reserved.

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "farmListVC.h"
#import "farmListVCell.h"
#import "farmDetailVC.h"
#import "cropListVCell.h"
#import "cropDetailVC.h"
#import "noteListVC.h"
#import "connectSQLite.h"

@interface farmListVC ()
@end

@implementation farmListVC
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableview.tableHeaderView = nil;
    self.tableview.tableFooterView = nil;
    
    [self setDefault];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    /* 詢問農田列表 */
    [self connectSQLite:1300];
}

- (void)setDefault {
    
    //init
    farmsList = [[NSMutableArray alloc] init];
    cropsList = [[NSMutableArray alloc] init];
    selectedFarm = [[NSMutableArray alloc] init];
    selectedFarmID = @"";
    selectedFarmName = @"";
    selectedCropID = @"";
    
    //add note button
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    addFarmButton = [[AMBCircularButton alloc] init];
    addFarmButton.frame = CGRectMake(mainScreenSize.width-70, mainScreenSize.height-70, 50, 50);
    [addFarmButton addTarget:self action:@selector(addFarm) forControlEvents:UIControlEventTouchUpInside];
    [addFarmButton setCircularImage:[UIImage imageNamed:@"add_black"] forState:UIControlStateNormal];
    addFarmButton.layer.masksToBounds = NO;
    addFarmButton.backgroundColor = [UIColor colorWithRed:52/255.0f green:198/255.0f blue:123/255.0f alpha:1.0f];
    addFarmButton.layer.cornerRadius = 10;
    addFarmButton.layer.shadowColor = [UIColor blackColor].CGColor;
    addFarmButton.layer.shadowOffset = CGSizeMake(5, 5);
    addFarmButton.layer.shadowOpacity = 0.8;
    addFarmButton.layer.shadowRadius = 0.0f;
    //addFarmButton.layer.masksToBounds = NO;
    
    [self.view addSubview:addFarmButton];
}

#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return JNExpandableTableViewNumberOfRowsInSection((JNExpandableTableView *)tableView,section,[farmsList count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * adjustedIndexPath = [self.tableview adjustedIndexPathFromTable:indexPath];

    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone]; //消除Separator line
    
    if ([self.tableview.expandedContentIndexPath isEqual:indexPath])
    {
 
        NSLog(@"expand");
        static NSString *CellIdentifier = @"expandedCell";
        
        cropTableViewCell *cropTVCell;
        cropTVCell = (cropTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cropTVCell == NULL) {
            [tableView registerNib:[UINib nibWithNibName:@"expandedCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cropTVCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        cropTVCell.collectview.dataSource = self;
        cropTVCell.collectview.delegate = self;
        [cropTVCell.collectview reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];

        return cropTVCell;

    } else {

        fieldInfo *info = [farmsList objectAtIndex:adjustedIndexPath.row];
        
        static NSString *CellIdentifier = @"Cell";
        
        farmListVCell *cell = (farmListVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.farmland_Name.text = info.farmName;
        cell.farmland_Photo.image = [UIImage imageNamed:info.farmImg];
        cell.farmland_LandNum.text = info.farmLandNum;
        cell.farmland_CropsNum.text = info.cropNo;

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(cropTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.tableview.expandedContentIndexPath isEqual:indexPath])
    {
        [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.tableview.expandedContentIndexPath])
    {
        return 160.0f;
    }
    else
        return 80.0f;
}

#pragma mark JNExpandableTableView DataSource
- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(JNExpandableTableView *)tableView willExpand:(NSIndexPath *)indexPath
{
    NSLog(@"index.row:%ld",indexPath.row);
    fieldInfo *info = [farmsList objectAtIndex:indexPath.row];
    selectedFarmID = info.farmID;
    selectedFarmName = info.farmName;
    NSLog(@"farmsList:%@",farmsList);
    NSLog(@"selectedFarmID:%@",selectedFarmID);
    
    /* 詢問農作物列表 */
    [self connectSQLite:1400];
    
}

- (void)tableView:(JNExpandableTableView *)tableView willCollapse:(NSIndexPath *)indexPath
{

}

#pragma mark - UICollectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [cropsList count]+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cropListVCell *cropCell = (cropListVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CropCell" forIndexPath:indexPath];
    
    cropCell.layer.masksToBounds = NO;
    cropCell.layer.borderColor = [UIColor clearColor].CGColor;
    cropCell.layer.borderWidth = 5.0f;
    cropCell.layer.contentsScale = [UIScreen mainScreen].scale;
    cropCell.layer.shadowOpacity = 0.8f;
    cropCell.layer.shadowRadius = 5.0f;
    cropCell.layer.shadowOffset = CGSizeZero;
    cropCell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cropCell.bounds].CGPath;
    cropCell.layer.shouldRasterize = YES;
    cropCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    if(indexPath.item < [cropsList count]) {
        cropCell.CellCropView.hidden = NO;
        cropCell.CellAddBtnView.hidden = YES;
        
        fieldInfo *info = [cropsList objectAtIndex:indexPath.item];
        cropCell.cropName.text = info.cropItem;
        cropCell.cropIcon.image = [UIImage imageWithData:info.cropIcon];

        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:strDate];
        
        if([info.cropPlantDate isEqualToString:@""]) {
            cropCell.calanderDate.text = @"";
        } else {
            NSDate *startDate = [dateFormatter dateFromString:info.cropPlantDate];
            
            components = [gregorianCalendar components:NSCalendarUnitDay
                                              fromDate:startDate
                                                toDate:currentDate
                                               options:0];
            
            NSString *diffDay1 = [NSString stringWithFormat: @"%ld", (long)[components day]];
            
            cropCell.calanderDate.text = diffDay1;
        }

        if([info.noteDateTime isEqualToString:@""]) {
            cropCell.lastWorkDate.text = @"";
        } else {
            NSDate *workDate = [dateFormatter dateFromString:info.noteDateTime];
            
            components = [gregorianCalendar components:NSCalendarUnitDay
                                              fromDate:workDate
                                                toDate:currentDate
                                               options:0];
            
            NSString *diffDay2 = [NSString stringWithFormat: @"%ld", (long)[components day]];
            
            cropCell.lastWorkDate.text = diffDay2;
        }
        
        cropCell.lastWorkItem.text = info.noteItem;

        if(info.cropAlert) {
            cropCell.CellCropView.layer.backgroundColor = [UIColor redColor].CGColor;
        } else {
            cropCell.CellCropView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        }
        
    } else {
        cropCell.CellCropView.hidden = YES;
        cropCell.CellAddBtnView.hidden = NO;

    }
    
    return cropCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedCropIndex = indexPath.row;
    selectedCrop = [cropsList objectAtIndex:indexPath.row];
    selectedCropID = selectedCrop.cropID;
    selectedCropName = selectedCrop.cropItem;
    
    [self performSegueWithIdentifier:@"segue-notelist" sender:self];
}

//定义每个Item 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(86, 95);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"segue-notelist"]) {
        noteListVC *crops = (noteListVC *)segue.destinationViewController;
        
        crops.selectedFarmID = selectedFarmID;
        crops.selectedCropID = selectedCropID;
        crops.selectedCropName = selectedCropName;
        crops.selectedCropIndex = selectedCropIndex;
        crops.selectedFarmCrops = cropsList;
        crops.selectedFarmName = selectedFarmName;

    } else if ([[segue identifier] isEqualToString:@"segue-farmdetail"]) {
        farmDetailVC *farmDetail = (farmDetailVC *)segue.destinationViewController;
        farmDetail.selectedFarmID = selectedFarmID;
        
    } else if ([[segue identifier] isEqualToString:@"segue-cropdetail"]) {
        cropDetailVC *cropDetail = (cropDetailVC *)segue.destinationViewController;

        cropDetail.selectedFarmID = selectedFarmID;
        cropDetail.selectedCropID = selectedCropID;
    }
}

#pragma mark - private function
-(Boolean)connectSQLite:(NSInteger)transType {
    
    switch (transType) {
        case 1300: { //查詢農田列表
            connectSQLite *connectSQL = [[connectSQLite alloc] init];

            NSMutableArray *list = [connectSQL accessSQLite:1300 andParam:nil];
            [farmsList removeAllObjects];

            fieldInfo *farm;
            if ([list count]) {
                for (int i=0; i<[list count]; i++) {
                    NSDictionary *entry = [list objectAtIndex:i];
                    
                    //farms list from db
                    farm = [[fieldInfo alloc] initWithFarmListDB:[entry objectForKey:@"farmID"] andName:[entry objectForKey:@"farmName"] andLandNum:[entry objectForKey:@"farmLandNum"] andSensorID:[entry objectForKey:@"sensorID"] andPlantDate:[entry objectForKey:@"farmStartDate"] andLatitude:[entry objectForKey:@"farmLatitude"] andLongitude:[entry objectForKey:@"farmLongitude"] andAddress:[entry objectForKey:@"farmAddr"] andImg:[entry objectForKey:@"farmPhoto"] andCropNo:[entry objectForKey:@"cropNo"] andUserID:[entry objectForKey:@"userID"]];
                    
                    [farmsList addObject:farm];
                }
            }
            
            [self.tableview reloadData];
            
            break;
        }
        case 1400: { //查詢農作物列表
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSLog(@"1400 selectedFarmID:%@",selectedFarmID);
            [params setObject:selectedFarmID forKey:@"dbData"];
            NSMutableArray *list = [connectSQL accessSQLite:1400 andParam:params];
            [cropsList removeAllObjects];
            
            fieldInfo *crop;
            if ([list count]) {
                for (int i=0; i<[list count]; i++) {
                    NSDictionary *entry = [list objectAtIndex:i];
                    
                    //crop list from db
                    crop = [[fieldInfo alloc] initWithCropListDB:[entry objectForKey:@"cropID"] andPeriod:[entry objectForKey:@"cropPeriod"] andName:[entry objectForKey:@"cropName"] andItem:[entry objectForKey:@"cropItem"] andVar:[entry objectForKey:@"cropVar"] andPlantDate:[entry objectForKey:@"cropPlantingDate"] andImg:[entry objectForKey:@"cropImg"] andIcon:[entry objectForKey:@"cropIcon"] andLastWorkDate:[entry objectForKey:@"noteDateTime"] andLastWorkItem:[entry objectForKey:@"noteItem"] andFarmID:selectedFarmID];
                    [cropsList addObject:crop];
                }
            }
            break;
        }
        default:
            break;
    }
    return YES;
}

- (IBAction)doAddCropAction:(id)sender {

     [self performSegueWithIdentifier:@"segue-cropdetail" sender:self];
}

-(void) addFarm {

    [self performSegueWithIdentifier:@"segue-farmdetail" sender:self];
}
@end
