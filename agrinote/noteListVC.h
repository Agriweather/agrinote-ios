//
//  noteListVC.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/3.
//  Copyright © 2017年 agri. All rights reserved.
//  REF: https://github.com/WrightsCS/WCSTimeline
//  REF: https://www.cocoacontrols.com/controls/idscrollabletabbar

#import <UIKit/UIKit.h>
#import "IDScrollableTabBarDelegate.h"
#import "AMBCircularButton.h"

@interface noteListVC : UIViewController <IDScrollableTabBarDelegate> {
    NSMutableData *webData;
    NSInteger connectionType;
    AMBCircularButton *addNoteButton;
    
    NSMutableArray *notesList;
    NSMutableArray *cropsIDs;
    NSMutableArray *cropsNames;
    
    BOOL addEvent;
    NSString *selectedCropIDinScrollView;
    NSString *selectedCropNameinScrollView;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *timelineData;
@property (nonatomic, weak) IBOutlet UIView *cropslistView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentConrol;
@property (nonatomic) NSString *selectedFarmID;
@property (nonatomic) NSString *selectedFarmName;
@property (nonatomic) NSString *selectedCropID;
@property (nonatomic) NSString *selectedCropName;
@property (nonatomic) NSInteger selectedCropIndex;
@property (nonatomic, strong) NSMutableArray *selectedFarmCrops;
@property (nonatomic) NSString *selectedNoteID;
@end
