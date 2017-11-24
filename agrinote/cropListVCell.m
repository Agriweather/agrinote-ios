//
//  cropListVCell.m
//  agrinote
//
//  Created by VimyHsieh on 2017/11/2.
//  Copyright © 2017年 agri. All rights reserved.
//

#import "cropListVCell.h"

@implementation cropCollectionView
@end

@implementation cropTableViewCell
@synthesize collectview;
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = self.collectview.contentSize;
    
    return intrinsicContentSize;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectview.dataSource = dataSourceDelegate;
    self.collectview.delegate = dataSourceDelegate;
    [self.collectview setContentOffset:self.collectview.contentOffset animated:NO];
    
    [self.collectview reloadData];
}
@end

@implementation cropListVCell
@synthesize CellCropView, CellAddBtnView;
@synthesize cropView, cropIcon, cropName;
@synthesize calanderView, calanderDate;
@synthesize lastWorkView, lastWorkDate, lastWorkItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    self.CellCropView.layer.masksToBounds = YES;
    self.CellCropView.layer.cornerRadius = 8;
    self.CellCropView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.CellCropView.layer.borderWidth = 1.0f;

    self.CellAddBtnView.layer.masksToBounds = YES;
    self.CellAddBtnView.layer.cornerRadius = 8;
    self.CellCropView.layer.borderColor = [UIColor grayColor].CGColor;
    self.CellCropView.layer.borderWidth = 1.0f;
    self.CellAddBtnView.layer.backgroundColor = [UIColor grayColor].CGColor;
    
    self.cropView.layer.cornerRadius = 30;
    
    self.calanderView.layer.cornerRadius = 6;

    self.lastWorkView.layer.cornerRadius = 6;
}

@end
