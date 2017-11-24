//
//  noteDetailVC.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/9.
//  Copyright © 2017年 agri. All rights reserved.

#import <QuartzCore/QuartzCore.h>

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface noteDetailVC : UIViewController <UINavigationControllerDelegate , UIImagePickerControllerDelegate> {
 
    IBOutlet UIScrollView *scrollview;
    
    IBOutlet UITextField *noteRecordDate; //記錄時間
    IBOutlet UIButton *noteWorkItem; //工作項目
    IBOutlet UITextView *noteRemark; //工作備註
    IBOutlet UITextField *noteUseQuantity; //使用次量
    IBOutlet UITextField *noteUseUnit; //使用單位
    IBOutlet UITextField *noteUseDilutionMultiple; //稀釋倍數
    IBOutlet UIButton *noteFarmMaterials; //使用資材種類
    IBOutlet UITextField *noteFarmMaterialsFee; //使用資材費用
    IBOutlet UIImageView *notePic; //日誌照片
    IBOutlet UIImageView *cropIcon; //作物小圖示
    
    NSString *selectedWorkingItemID; //農務工作主項目ID
    NSMutableArray *WorkingItemList; //農務工作主項目清單
    
    UIView *backgroundview;
    UIView *mainView;

    UICollectionView *selectionView;
}

@property (nonatomic) BOOL addEvent;
@property (nonatomic) NSString *selectedNoteID;
@property (nonatomic) NSString *selectedCropID;
@property (nonatomic) NSString *selectedCropName;

@property (nonatomic, weak) IBOutlet UIView *noteBaseInfo;
@property (nonatomic, weak) IBOutlet UIView *noteImageInfo;

@end

