//
//  farmListVCell.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/3.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "cropListVCell.h"

@interface farmListVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *farmland_Name;
@property (weak, nonatomic) IBOutlet UIImageView *farmland_Photo;
@property (weak, nonatomic) IBOutlet UILabel *farmland_LandNum;
@property (weak, nonatomic) IBOutlet UILabel *farmland_CropsNum;

@end
