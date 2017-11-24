//
//  farmDetailVC.h
//  agrinote
//
//  Created by VimyHsieh on 2017/10/30.
//  Copyright © 2017年 agri. All rights reserved.

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define RGB(r, g, b)	 [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha : 1]

@interface farmDetailVC : UIViewController <UIScrollViewDelegate> {
    UIView *cardView;
    IBOutlet UIScrollView *scrollview;
    
    IBOutlet UITextField *farmName;
    IBOutlet UITextField *farmLandNum;
    IBOutlet UITextField *farmAddress;
    IBOutlet UITextField *farmPlantDate;
    IBOutlet UIImageView *farmPic;
}

@property (nonatomic) NSString *selectedFarmID;

@property (nonatomic, weak) IBOutlet UIView *farmBaseInfo;
@property (nonatomic, weak) IBOutlet UIView *farmImageInfo;
@property (nonatomic) IBOutlet MKMapView *farmMapInfo;
@end
