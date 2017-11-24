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
#import "noteCard.h"
#import "fieldInfo.h"
#import "connectSQLite.h"

@interface noteDetailVC ()

@end

#define kOFFSET_FOR_KEYBOARD 300.0

@implementation noteDetailVC
@synthesize container, datas;
@synthesize noteBaseInfo, noteImageInfo;
@synthesize showQACard;
@synthesize addEvent;
@synthesize selectedNoteID;
@synthesize selectedCropID, selectedCropName;

@synthesize firstLoad;
@synthesize firstQuestion;
@synthesize secondQuestion;
@synthesize thirdQuestion;
@synthesize imageView;
@synthesize usageData;
@synthesize unitData;

BOOL needtoSave;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDefault];
    
    [self adjustUIView];
    
    [self configWorkItemView];
    
    [self drawCard];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(showQACard) {
        NSLog(@"show card");
        [cardView setHidden:NO];
    } else {
        NSLog(@"dont show card");
        [cardView setHidden:YES];
        
    }
    
    if(!addEvent) {
        /* 詢問日誌 */
        [self connectSQLite:1502];
    }
    
    /* 查詢作物圖示 */
    [self connectSQLite:1601];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
     */
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /*
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
     */
}

- (void)setDefault {

    //init
    cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    cardView.backgroundColor = [UIColor clearColor];
    cardView.alpha = 1;
    cardView.hidden = YES;
    self.datas = [NSMutableArray array];
    firstLoad = TRUE;
    selectedWorkingItemID = @"";
    
    WorkingItemList = [[NSMutableArray alloc] init];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, (self.view.frame.size.width-20) * 0.7)];
    
    //wait touch event to close cardView
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [cardView addGestureRecognizer:singleFingerTap];
}

- (void)drawCard {
    self.container = [[YSLDraggableCardContainer alloc]init];
    self.container.frame = CGRectMake(10, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width - 20, self.view.frame.size.width - 20);
    self.container.backgroundColor = [UIColor clearColor];
    self.container.alpha = 1;
    self.container.dataSource = self;
    self.container.delegate = self;
    self.container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;
    [cardView addSubview:self.container];
    [self.view addSubview:cardView];
 
    [self prepareQA];
    
    [self.container reloadCardContainer];
    
}

- (void)prepareQA
{
    self.datas = [NSMutableArray array];
    self.buttonSubject = [NSMutableArray array];
    self.buttonSubject = [@[@"農務工作",@"蟲害防治",@"性狀紀錄"] mutableCopy];
    
    int numQA = 4;
    NSDictionary *dict;
    
    if(firstLoad){
        dict = @{@"button" : @[@"農務工作",@"蟲害防治",@"性狀分析"],
                 @"name" : @"農地名稱\n玉米\n本次的工作項目"};
        //        firstLoad = FALSE;
        [self.datas addObject:dict];
    }
    
    if(firstQuestion){
        NSLog(@"first question");
        
        [self.datas removeAllObjects];
        for (int i = 0; i < numQA; i++) {
            
            switch (i) {
                    
                case 0: {
                    dict = @{@"name" : @"拍攝照片",
                             @"button" : @[@"拍攝照片",@"選取照片",@"確認"]};
                    //                dict = @{@"button" : @[@"農務工作",@"蟲害防治",@"性狀分析"]};
                    break;
                }
                case 1: {
                    dict = @{@"name" : @"使用量",
                             @"button" : @[@"確認"]};
                    //                dict = @{@"button" : @[@"農務工作",@"蟲害防治",@"性狀分析"]};
                    break;
                }
                case 2:{
                    dict = @{@"name" : @"資材"};
                    //                dict = @{@"button" : @[@"農務工作",@"蟲害防治",@"性狀分析"]};
                    break;
                }
                case 3:{
                    dict = @{@"name" : @"農具"};
                    //                dict = @{@"button" : @[@"農務工作",@"蟲害防治",@"性狀分析"]};
                    break;
                }
                default:
                    break;
            }
            //            NSLog(@"self datas:%@",dict[@"name"]);
            [self.datas addObject:dict];
            
        }
    }
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

- (IBAction)WorkItemAction:(id)sender
{
    /* 查詢農務工作主項目 */
    [self connectSQLite:1700];
    
    //跳出一UIView
    [backgroundview setHidden:NO];
}

-(void) configWorkItemView {
    //main screen & navigation bar size
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    UIView *authorizationNevibar;
    UIImageView *accountView;
    UIImageView *pwdView;
    UIButton *btn_login;
    
    screenHeight = mainScreen.size.height;
    screenWidth = mainScreen.size.width;
    
    //Background View
    backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight)];
    backgroundview.backgroundColor = [UIColor darkGrayColor];
    backgroundview.alpha = 0.9; //0.8
    
    //Main View
    mainView = [[UIView alloc] initWithFrame: CGRectMake(25, 75, screenWidth-50, screenHeight-100)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    mainView.alpha = 1;
    [mainView layer].cornerRadius = 10;
    [mainView layer].shadowColor = [UIColor blackColor].CGColor;
    [mainView layer].shadowOffset = CGSizeMake(10, 10);
    [mainView layer].shadowOpacity = 0.8;
    
    //Nevigation Bar
    authorizationNevibar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, 44)];
    [authorizationNevibar setBackgroundColor:[UIColor lightGrayColor]];
    [mainView addSubview:authorizationNevibar];
    
    //選單
    /*
    selectionView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, mainView.frame.size.width, mainView.frame.size.height)];
    selectionView.backgroundColor = [UIColor yellowColor];
     [mainView addSubview:selectionView];
    */
    selectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, mainView.frame.size.width, mainView.frame.size.height)];
    [selectionView setDataSource:self];
    [selectionView setDelegate:self];
    [selectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    selectionView.backgroundColor = [UIColor yellowColor];
    [mainView addSubview:selectionView];
    
    //Nevigation Item:Title
    UILabel *viewTitle = [[UILabel alloc] initWithFrame: CGRectMake(40,3,180,40)];
    [viewTitle setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    [viewTitle setTextAlignment:NSTextAlignmentCenter]; //置中於UILabel
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setText:@"農務工作項目"];
    [viewTitle setCenter:authorizationNevibar.center]; //置中於Nevigation Bar
    [mainView addSubview:viewTitle];
    
    //Nevigation Item:Cancel
    UIButton *btn_dismiss = [[UIButton alloc] initWithFrame: CGRectMake(3,3,40,40)];
    UIImage *closeImg = [UIImage imageNamed:@"Actions-file-close-icon.png"];
    [btn_dismiss setBackgroundColor:[UIColor clearColor]];
    [btn_dismiss setImage:closeImg forState:UIControlStateNormal];
    [btn_dismiss addTarget:self action:@selector(pressCancel) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btn_dismiss];
    
    [backgroundview addSubview:mainView];
    [self.view addSubview:backgroundview];
    
    [backgroundview setHidden:YES];
}

-(void)pressCancel{
    [backgroundview setHidden:YES];
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
            /*
            NSString *res = [connectSQL accessSQLite:1502 andParam:params];
            NSDictionary *resdict = [res objectFromJSONString];
            NSMutableArray *list = [resdict objectForKey:@"data"];
            */
            
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
            
            //NSLog(@"[list count]: %ld", [list count]);
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
            //NSLog(@"[list count]: %ld", [list count]);
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

#pragma mark - UICollectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    /*
     NSLog(@"numberOfItemsInSection:%ld", [selectedFarm count]);
     return [selectedFarm count]+1;
     */
    
    //NSLog(@"numberOfItemsInSection cropsList:%ld", [cropsList count]);
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button
{
    /*
     if (button.tag == 0) {
     [self.container movePositionWithDirection:YSLDraggableDirectionUp isAutomatic:YES];
     }
     if (button.tag == 1) {
     __weak noteDetailVC *weakself = self;
     [self.container movePositionWithDirection:YSLDraggableDirectionDown isAutomatic:YES undoHandler:^{
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
     message:@"Do you want to reset?"
     preferredStyle:UIAlertControllerStyleAlert];
     
     [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
     [weakself.container movePositionWithDirection:YSLDraggableDirectionDown isAutomatic:YES];
     }]];
     
     [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
     [weakself.container movePositionWithDirection:YSLDraggableDirectionDefault isAutomatic:YES];
     }]];
     
     [self presentViewController:alertController animated:YES completion:nil];
     }];
     
     }
     if (button.tag == 2) {
     [self.container movePositionWithDirection:YSLDraggableDirectionLeft isAutomatic:YES];
     }
     if (button.tag == 3) {
     [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
     }
     
     */
    if(!firstQuestion && !secondQuestion && !thirdQuestion){
        if(button.tag == 0){
            NSLog(@"first load button 0");
            firstQuestion = TRUE;
            secondQuestion = FALSE;
            thirdQuestion = FALSE;
            
        }
        else if(button.tag == 1){
            firstQuestion = FALSE;
            secondQuestion = TRUE;
            thirdQuestion = FALSE;
        }
        else{
            firstQuestion = FALSE;
            secondQuestion = FALSE;
            thirdQuestion = TRUE;
        }
    }
    
    
    [self prepareQA];
    [self.container reloadCardContainer];
    
    [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
}

- (void)nextCard:(UIButton *)button
{
    [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@"確定放棄新增日誌?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [cardView setHidden:NO];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- YSLDraggableCardContainer DataSource
- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index
{
    
    
    //    [self prepareQA];
    NSDictionary *dict = self.datas[index];
    NSArray *buttonGroup = dict[@"button"];
    
    
    
    
    noteCard *view = [[noteCard alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    view.backgroundColor = [UIColor whiteColor];
    //    view.imageView.image = [UIImage imageNamed:dict[@"image"]];
    view.label.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    
    //    NSLog(@"array:%d",a.count);
    
    if(firstQuestion && index==1){
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [view addGestureRecognizer:tap];
        
        UILabel *usage = [[UILabel alloc] init];
        usage.backgroundColor = [UIColor clearColor];
        usage.frame = CGRectMake(view.frame.size.width * 0.1, view.frame.size.height * 0.7, 100, 20);
        usage.text = @"使用量：";
        [view addSubview:usage];
        
        UITextField *usageText = [[UITextField alloc]init];
        usageText.frame = CGRectMake(view.frame.size.width * 0.3, view.frame.size.height * 0.7, 100, 20);
        usageText.borderStyle = UITextBorderStyleLine;
        [usageText setKeyboardType:UIKeyboardTypeNumberPad];
        
        [usageText addTarget:self
                      action:@selector(getUsageData:)
            forControlEvents:UIControlEventEditingChanged
         ];
        [view addSubview:usageText];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.frame = CGRectMake(view.frame.size.width * 0.55, view.frame.size.height * 0.7, 100, 20);
        unitLabel.text = @"單位：";
        [view addSubview:unitLabel];
        
        UITextField *unitText = [[UITextField alloc]init];
        unitText.frame = CGRectMake(view.frame.size.width * 0.75, view.frame.size.height * 0.7, 100, 20);
        unitText.borderStyle = UITextBorderStyleLine;
        [unitText addTarget:self
                     action:@selector(getUnitData:)
           forControlEvents:UIControlEventEditingChanged
         ];
        [view addSubview:unitText];
        
        
    }
    
    for(int i=0; i<buttonGroup.count;i++){
        float offset = 0.2 * i + 0.1;
        CGRect buttonFrame = CGRectMake( view.frame.size.width * offset, view.frame.size.height * 0.8, 100, 20 );
        UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
        //        NSString *s = [@"%s",self.buttonSubject[i]];
        [button setTitle:buttonGroup[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(firstLoad && index == 0){
            firstLoad = FALSE;
            [button addTarget:self
                       action:@selector(buttonTap:)
             forControlEvents:UIControlEventTouchUpInside
             ];
        }
        else if(!firstLoad && firstQuestion && index==0 && i==0){
            [button addTarget:self
                       action:@selector(takePhoto:)
             forControlEvents:UIControlEventTouchUpInside
             ];
        }
        else if(!firstLoad && firstQuestion && index==0 && i==1){
            [button addTarget:self
                       action:@selector(selectPhoto:)
             forControlEvents:UIControlEventTouchUpInside
             ];
        }
        else if(!firstLoad && firstQuestion && index==0 && i==2 ){
            [button addTarget:self
                       action:@selector(nextCard:)
             forControlEvents:UIControlEventTouchUpInside
             ];
        }
        else if(!firstLoad && firstQuestion && index==1){
            [button addTarget:self
                       action:@selector(nextCard:)
             forControlEvents:UIControlEventTouchUpInside
             ];
        }
        
        
        button.tag = i;
        
        
        [view addSubview:button];
        
    }
    if (imageView.image && index==0){
        //        [self prepareQA];
        //        [self.container reloadCardContainer];
        
        [view addSubview:imageView];
    }
    
    
    //    [self setFirstPageButton:view];
    
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return self.datas.count;
}

#pragma mark -- YSLDraggableCardContainer Delegate
- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    noteCard *view = (noteCard *)draggableView;
    
    if (draggableDirection == YSLDraggableDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (draggableDirection == YSLDraggableDirectionLeft) {
        view.selectedView.backgroundColor = RGB(215, 104, 91);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        view.selectedView.backgroundColor = RGB(114, 209, 142);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.container reloadCardContainer];
    });
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
    NSLog(@"++ index : %ld",(long)index);
}

- (void)takePhoto:(UIButton *)button
{
    needtoSave = YES;
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
    
    
    
}
- (void)selectPhoto:(UIButton *)button
{
    NSLog(@"selectPhoto function");
    
    needtoSave = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.mediaTypes = mediaTypes;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //NSLog(@"enter didFinishPickingMediaWithInfo");
    NSLog(@"info:%@",info);
    
    //取得使用的檔案格式
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //取得照片
        self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //獲取照片資訊
        [self getExif:info];
        
        
        //儲存照片
        if (needtoSave) {
            //UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            [self saveImage];
        }
    }
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        //取得影片位置
        //videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //取得影片的位置
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //儲存影片
        if (needtoSave) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    //以動畫方式返回先前畫面
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    /*
     UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     self.imageView.image = chosenImage;
     
     //儲存影像
     UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
     
     [picker dismissViewControllerAnimated:YES completion:NULL];
     */
}

//自行建立判斷儲存成功與否的函式
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Title"
                                 message:@"Message"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //以error參數判斷是否成功儲存影像
    if (error) {
        
        UIAlertAction* failed = [UIAlertAction
                                 actionWithTitle:@"錯誤"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here
                                 }];
        [alert addAction:failed];
        
        //顯示警告訊息
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        /*
         UIAlertAction* success = [UIAlertAction
         actionWithTitle:@"成功"
         style:UIAlertActionStyleDefault
         handler:^(UIAlertAction * action) {
         //Handle your yes please button action here
         }];
         [alert addAction:success];
         */
    }
    
    //顯示警告訊息
    //[self presentViewController:alert animated:YES completion:nil];
}


//自行建立判斷儲存成功與否的函式
- (void)video:(NSData *)video didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    //以error參數判斷是否成功儲存影像
    if (error) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Title"
                                     message:@"Message"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* failed = [UIAlertAction
                                 actionWithTitle:@"錯誤"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here
                                 }];
        [alert addAction:failed];
        
        //顯示警告訊息
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//實現手勢的方法，進入相簿
-(void)selectImage:(UIButton*)sender
{   //新建ImagePickController
    UIImagePickerController *myPicker = [[UIImagePickerController alloc]init];
    
    //創建源類型
    UIImagePickerControllerSourceType mySourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    myPicker.sourceType = mySourceType;
    
    //設置代理
    myPicker.delegate = self;
    
    //設置可编辑
    myPicker.allowsEditing = YES;
    
    //通過模態的方式推出系统相簿
    [self presentViewController:myPicker animated:YES completion:^{
        NSLog(@"進入相簿");
    }];
    
}

#pragma mark - 儲存照片
- (void)saveImage {
    
#if 0
    // 獲取當前App對photos的訪問權限
    PHAuthorizationStatus OldStatus = [PHPhotoLibrary authorizationStatus];
    
    // 检查访问权限 当前 App 对相册的检查权限
    /**
     * PHAuthorizationStatus
     * PHAuthorizationStatusNotDetermined = 0, 用户还未决定
     * PHAuthorizationStatusRestricted,        系统限制，不允许访问相册 比如家长模式
     * PHAuthorizationStatusDenied,            用户不允许访问
     * PHAuthorizationStatusAuthorized         用户可以访问
     * 如果之前已经选择过，会直接执行 block，并且把以前的状态传给你
     * 如果之前没有选择过，会弹框，在用户选择后调用 block 并且把用户的选择告诉你
     * 注意：该方法的 block 在子线程中运行 因此，弹框什么的需要回到主线程执行
     */
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                //            [self cSaveToCameraRoll];
                //            [self photoSaveToCameraRoll];
                //            [self fetchCameraRoll];
                //            [self createCustomAssetCollection];
                //            [self createdAsset];
                //            [self saveImageToCustomAlbum2];
                [self saveImageToCustomAlbum];
            } else if (OldStatus != PHAuthorizationStatusNotDetermined && status == PHAuthorizationStatusDenied) {
                // 用户上一次选择了不允许访问 且 这次又点击了保存 这里可以适当提醒用户允许访问相册
            }
        });
    }];
#else
    
    [self saveImageToCustomAlbum];
#endif
    
}

#pragma mark - 使用 photo 框架创建自定义名称的相册 并获取自定义到自定义相册
#pragma mark -
- (PHAssetCollection *)createCustomAssetCollection
{
    // 获取 app 名称
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    
    NSError *error = nil;
    
    // 查找 app 中是否有该相册 如果已经有了 就不再创建
    /**
     *     参数一 枚举：
     *     PHAssetCollectionTypeAlbum      = 1, 用户自定义相册
     *     PHAssetCollectionTypeSmartAlbum = 2, 系统相册
     *     PHAssetCollectionTypeMoment     = 3, 按时间排序的相册
     *
     *     参数二 枚举：PHAssetCollectionSubtype
     *     参数二的枚举有非常多，但是可以根据识别单词来找出我们想要的。
     *     比如：PHAssetCollectionTypeSmartAlbum 系统相册 PHAssetCollectionSubtypeSmartAlbumUserLibrary 用户相册 就能获取到相机胶卷
     *     PHAssetCollectionSubtypeAlbumRegular 常规相册
     */
    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeAlbum)
                                                                                          subtype:(PHAssetCollectionSubtypeSmartAlbumUserLibrary)
                                                                                          options:nil];
    
    
    for (PHAssetCollection *collection in result) {
        if ([collection.localizedTitle isEqualToString:title]) { // 說明 app 中存在該相簿
            return collection;
        }
    }
    
    /** 来到这里说明相册不存在 需要创建相册 **/
    __block NSString *createdCustomAssetCollectionIdentifier = nil;
    // 创建和 app 名称一样的 相册
    /**
     * 注意：这个方法只是告诉 photos 我要创建一个相册，并没有真的创建
     *      必须等到 performChangesAndWait block 执行完毕后才会
     *      真的创建相册。
     */
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
        /**
         * collectionChangeRequest 即使我们告诉 photos 要创建相册，但是此时还没有
         * 创建相册，因此现在我们并不能拿到所创建的相册，我们的需求是：将图片保存到
         * 自定义的相册中，因此我们需要拿到自己创建的相册，从头文件可以看出，collectionChangeRequest
         * 中有一个占位相册，placeholderForCreatedAssetCollection ，这个占位相册
         * 虽然不是我们所创建的，但是其 identifier 和我们所创建的自定义相册的 identifier
         * 是相同的。所以想要拿到我们自定义的相册，必须保存这个 identifier，等 photos app
         * 创建完成后通过 identifier 来拿到我们自定义的相册
         */
        createdCustomAssetCollectionIdentifier = collectionChangeRequest.placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 這裡 block 结束了，因此相簿也創建完畢了
    if (error) {
        NSLog(@"創建相簿失敗");
    }
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCustomAssetCollectionIdentifier] options:nil].firstObject;
}

#pragma mark - 將圖片存到自定義相簿中
#pragma mark -
- (void)saveImageToCustomAlbum
{
    // 將圖片保存到相機膠卷
    NSError *error = nil;
    __block PHObjectPlaceholder *placeholder = nil;
    
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        placeholder = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset;
    } error:&error];
    if (error) {
        NSLog(@"保存失敗");
    }
    
    // 獲取自定義相簿
    PHAssetCollection *createdCollection = [self createCustomAssetCollection];
    
    // 將圖片存到自定義相簿中
    /**
     * 必须通过中间类，PHAssetCollectionChangeRequest 来完成
     * 步骤：1.首先根据相册获取 PHAssetCollectionChangeRequest 对象
     *      2.然后根据 PHAssetCollectionChangeRequest 来添加图片
     * 这一步的实现有两个思路：1.通过上面的占位 asset 的标识来获取 相机胶卷中的 asset
     *                       然后，将 asset 添加到 request 中
     *                     2.直接将 占位 asset 添加到 request 中去也是可行的
     */
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        // [request addAssets:@[placeholder]]; 下面的方法可以将最新保存的图片设置为封面
        [request insertAssets:@[placeholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
    if (error) {
        NSLog(@"保存失敗");
    } else {
        NSLog(@"保存成功");
    }
    
    
}

- (void)getExif: (NSDictionary *)info {
    
    NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSDictionary *exifMetadata = [metadata objectForKey:(id)kCGImagePropertyExifDictionary];
    //NSDictionary *tiffMetadata = [metadata objectForKey:(id)kCGImagePropertyTiffDictionary];
    
    NSLog(@"exifMetadata: %@",exifMetadata);
    NSLog(@"date_time: %@",[exifMetadata objectForKey:(id)kCGImagePropertyExifDateTimeDigitized]);
    NSLog(@"gps: %@",[metadata objectForKey:(id)kCGImagePropertyGPSDictionary]);
    [self.container reloadCardContainer];
    
}

-(void)dismissKeyboard:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(void) getUsageData:(UITextField *)theTextField {
    NSLog(@"Get usage data");
    usageData = theTextField.text;
    NSLog(@"the content is %@",usageData);
}

-(void) getUnitData:(UITextField *)theTextField {
    unitData = theTextField.text;
    NSLog(@"the content is %@",unitData);
}
@end
