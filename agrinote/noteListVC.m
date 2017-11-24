//
//  noteListVC.m
//  agrinote
//
//  Created by VimyHsieh on 2017/11/3.
//  Copyright © 2017年 agri. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "IDScrollableTabBar.h"
#import "WCSTimelineCell.h"
#import "noteListVC.h"
#import "noteDetailVC.h"
#import "fieldInfo.h"
#import "connectSQLite.h"

@interface noteListVC ()

@end

@implementation noteListVC
@synthesize tableView;
@synthesize refreshControl;
@synthesize timelineData;
@synthesize cropslistView;
@synthesize selectedFarmID, selectedFarmName, selectedCropID, selectedCropName, selectedCropIndex, selectedFarmCrops, selectedNoteID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setDefault];
    
    //scroll bar - crops list
    [self prepareCropsList];
    
}

- (void)viewDidUnload {
    [self setCropslistView:nil];
    [self setSegmentConrol:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    /* 詢問作物日誌列表 */
    selectedCropIDinScrollView = self.selectedCropID;
    selectedCropNameinScrollView = self.selectedCropName;
    
    [self connectSQLite:1500];
}

-(void)scrollTabBarAction : (NSNumber *)selectedNumber sender:(id)sender{
    
    self.selectedCropIndex = [selectedNumber integerValue];
 
    /* 詢問作物日誌列表 */
    selectedCropIDinScrollView = [cropsIDs objectAtIndex:self.selectedCropIndex];
    selectedCropNameinScrollView = [cropsNames objectAtIndex:self.selectedCropIndex];
    [self connectSQLite:1500];
}

#pragma mark - Private Methods
- (void) prepareCropsList {
    
    NSMutableArray *cropsIcon = [[NSMutableArray alloc] init];

    for (int i=0; i<[self.selectedFarmCrops count]; i++) {
        fieldInfo *info = [selectedFarmCrops objectAtIndex:i];
        IDItem *item = [[IDItem alloc] initWithImage:[UIImage imageWithData:info.cropIcon] text:info.cropItem];
        [cropsIcon addObject:item];
        
        [cropsIDs addObject:info.cropID];
        [cropsNames addObject:info.cropItem];
    }
    
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    IDScrollableTabBar *scrollableTabBar = [[IDScrollableTabBar alloc] initWithFrame:CGRectMake(0, 30, mainScreenSize.width, 0) itemWidth:80 items:cropsIcon];
    
    scrollableTabBar.delegate = self;
    scrollableTabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;

    [scrollableTabBar setArchImage:[UIImage imageNamed:@"grayArch"] centerImage:[UIImage imageNamed:@"grayCenter"] backGroundImage:[UIImage imageNamed:@"grayBackground"]];
    [scrollableTabBar setSelectedItem:(int)self.selectedCropIndex animated:NO];
    
    //you can hide divider image and shadow images
    [scrollableTabBar setDividerImage:[UIImage imageNamed:@"grayDivider"]];
    [scrollableTabBar setShadowImageRight:[UIImage imageNamed:@"grayShadowRight"]];
    [scrollableTabBar setShadowImageLeft:[UIImage imageNamed:@"grayShadowLeft"]];
    
    UIFont *font = [UIFont fontWithName:@"Katy Berry" size:17];
    for (IDScrollableTabBarItem *item in [scrollableTabBar getItems]) {
        CGRect rect = item.label.frame;
        rect.origin.y -= 0.f;
        rect.size.height = 15.f;
        [item.label setFrame:rect];
        [item.label setFont:font];
        [item.label setTextColor:[UIColor whiteColor]];
    }
    [self.cropslistView addSubview:scrollableTabBar];
}

#pragma mark - UITableView Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timelineData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCSTimelineModel * model = self.timelineData[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"WCSTimelineCell";
    WCSTimelineCell * timelineCell = timelineCell = [[WCSTimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    timelineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    timelineCell.backgroundColor = ( indexPath.row % 2 == 0 ? [self hex:@"f2f1f1" alpha:1.f] : [self hex:@"ffffff" alpha:1.f] );
    
    WCSTimelineModel * model = self.timelineData[indexPath.row];
    if (indexPath.row == self.timelineData.count - 1 ) {
        model.isLast = true;
    }
    timelineCell.model = model;
    
    return timelineCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    fieldInfo *info = [notesList objectAtIndex:indexPath.row];
    selectedNoteID = info.noteID;
    addEvent = NO;
    [self performSegueWithIdentifier:@"segue-notedetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"segue-notedetail"]) {
        noteDetailVC *noteDetail = (noteDetailVC *)segue.destinationViewController;
        noteDetail.selectedCropID = selectedCropIDinScrollView;
        noteDetail.selectedCropName = selectedCropNameinScrollView;
        noteDetail.addEvent = addEvent;
        noteDetail.selectedNoteID = selectedNoteID;
    }
}
#pragma mark - private function
- (void)setDefault {
    
    //init
    notesList = [[NSMutableArray alloc] init];
    cropsIDs = [[NSMutableArray alloc] init];
    cropsNames = [[NSMutableArray alloc] init];
    selectedCropIDinScrollView = @"";
    selectedCropNameinScrollView = @"";
    addEvent = YES; //判斷新增或是編輯
    
    //add note button
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    addNoteButton = [[AMBCircularButton alloc] init];
    addNoteButton.frame = CGRectMake(mainScreenSize.width-70, mainScreenSize.height-70, 50, 50);
    [addNoteButton addTarget:self action:@selector(addNote) forControlEvents:UIControlEventTouchUpInside];
    [addNoteButton setCircularImage:[UIImage imageNamed:@"add_black"] forState:UIControlStateNormal];
    addNoteButton.backgroundColor = [UIColor colorWithRed:52/255.0f green:198/255.0f blue:123/255.0f alpha:1.0f];
    [self.view addSubview:addNoteButton];
}

-(Boolean)connectSQLite:(NSInteger)transType {
    
    switch (transType) {
        case 1500: { //查詢日誌列表
            connectSQLite *connectSQL = [[connectSQLite alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:selectedCropIDinScrollView forKey:@"dbData"];

            NSMutableArray *list = [connectSQL accessSQLite:1500 andParam:params];
            [notesList removeAllObjects];
            
            fieldInfo *note;
            self.timelineData = nil;
            self.timelineData = [NSMutableArray new];
            
            if ([list count]) {
                for (int i=0; i<[list count]; i++) {
                    NSDictionary *entry = [list objectAtIndex:i];
                    
                    //notes from db
                    note = [[fieldInfo alloc] initWithNoteDB:[entry objectForKey:@"noteID"] andItem:[entry objectForKey:@"noteWorkItem"] andRemark:[entry objectForKey:@"noteRemark"] andImg:[entry objectForKey:@"notePhoto"] andRecordDate:[entry objectForKey:@"noteRecordDate"] andUseQuantity:[entry objectForKey:@"noteUseQuantity"] andUseUnit:[entry objectForKey:@"noteUseUnit"] andUseDilutionMultiple:[entry objectForKey:@"noteUseDilutionMultiple"] andFarmMaterials:[entry objectForKey:@"noteFarmMaterials"] andFarmMaterialsFee:[entry objectForKey:@"noteFarmMaterialsFee"] andCropID:[entry objectForKey:@"cropID"]];

                    [notesList addObject:note];
                    
                    WCSTimelineModel * model = [WCSTimelineModel new];
                    model.icon = [UIImage imageNamed:@"event"];
                    model.time = note.noteRecordDate;
                    model.event = note.noteItem;
                    model.content = note.noteRemark;
                    model.pic.image = [UIImage imageNamed:note.noteImg];
                    
                    [self.timelineData addObject:model];
                }
            }
            
            self.title = selectedFarmName;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView reloadData];

            break;
        }
        default:
            break;
    }
    return YES;
}

- (UIColor*)hex:(NSString*)hex alpha:(float)alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void) addNote {
    addEvent = YES;
     [self performSegueWithIdentifier:@"segue-notedetail" sender:self];
}
@end
