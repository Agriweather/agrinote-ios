//
//  farmListVC.h
//  agrinote
//
//  Created by VimyHsieh on 2017/10/25.
//  Copyright © 2017年 agri. All rights reserved.
//  REF: https://github.com/jonasman/JNExpandableTableView

#import <UIKit/UIKit.h>
#import "JNExpandableTableView/JNExpandableTableView.h"
#import "AMBCircularButton.h"
#import "fieldInfo.h"
#import "cropListVCell.h"

@interface farmListVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableData *webData;
    NSInteger connectionType;
    NSMutableArray *farmsList;
    NSMutableArray *cropsList;
    
    NSMutableArray *selectedFarm;
    fieldInfo *selectedCrop;
    NSInteger selectedCropIndex;
    NSString *selectedFarmID;
    NSString *selectedFarmName;
    NSString *selectedCropID;
    NSString *selectedCropName;
    
    AMBCircularButton *addFarmButton;
    
}

@property (strong, nonatomic) IBOutlet JNExpandableTableView *tableview;
@end
