//
//  cropDetailVC.h
//  agrinote
//
//  Created by VimyHsieh on 2017/10/30.
//  Copyright © 2017年 agri. All rights reserved.

#import <UIKit/UIKit.h>

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface cropDetailVC : UIViewController {
    IBOutlet UIScrollView *scrollview;
    
    IBOutlet UITextField *cropName; //作物名稱
    IBOutlet UITextField *cropItem; //作物品項
    IBOutlet UITextField *cropVar; //作物品種
    IBOutlet UITextField *cropPeriod; //期作
    IBOutlet UITextField *cropPlantDate; //開始耕作日期
    IBOutlet UIImageView *cropPic;
}

@property (nonatomic) NSString *selectedFarmID;
@property (nonatomic) NSString *selectedCropID;

@property (nonatomic, weak) IBOutlet UIView *cropBaseInfo;
@property (nonatomic, weak) IBOutlet UIView *cropImageInfo;
@end
