//
//  RecommendListTCell.h
//  FangWenShan
//
//  Created by Leis on 2017/6/3.
//  Copyright © 2017年 Leis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Song;
@interface RecommendListTCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lTitle;

@property (strong, nonatomic) Song *song;
@end
