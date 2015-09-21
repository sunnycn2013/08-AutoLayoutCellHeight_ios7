//
//  HomeCell.h
//  08-AutoLayoutCellHeight_ios7
//
//  Created by ccguo on 15/8/18.
//  Copyright (c) 2015年 ccguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content;

-(CGFloat)calulateHeightWithtTitle:(NSString*)title desrip:(NSString*)descrip;
@end
