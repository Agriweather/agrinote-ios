//
//  cropListVCell.h
//  agrinote
//
//  Created by VimyHsieh on 2017/11/2.
//  Copyright © 2017年 agri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cropCollectionView : UICollectionView
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@interface cropTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet cropCollectionView *collectview;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end

@interface cropListVCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIView *CellCropView;
@property (nonatomic, strong) IBOutlet UIView *CellAddBtnView;

@property (nonatomic, strong) IBOutlet UIView *cropView;
@property (nonatomic, strong) IBOutlet UIImageView *cropIcon;
@property (nonatomic, strong) IBOutlet UILabel *cropName;
@property (nonatomic, strong) IBOutlet UIView *calanderView;
@property (nonatomic, strong) IBOutlet UILabel *calanderDate;
@property (nonatomic, strong) IBOutlet UIView *lastWorkView;
@property (nonatomic, strong) IBOutlet UILabel *lastWorkDate;
@property (nonatomic, strong) IBOutlet UILabel *lastWorkItem;

@end
