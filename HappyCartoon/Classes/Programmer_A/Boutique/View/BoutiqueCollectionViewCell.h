//
//  BoutiqueCollectionViewCell.h
//  Project_A
//
//  Created by 付正 on 15/5/29.
//  Copyright (c) 2015年 fuzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Boutique.h"
@interface BoutiqueCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) Boutique * boutique;

@end
