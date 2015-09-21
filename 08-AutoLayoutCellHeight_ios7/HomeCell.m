//
//  HomeCell.m
//  08-AutoLayoutCellHeight_ios7
//
//  Created by ccguo on 15/8/18.
//  Copyright (c) 2015年 ccguo. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(CGFloat)calulateHeightWithtTitle:(NSString*)title desrip:(NSString*)descrip
{
    //这里非常重要
    CGFloat preMaxWaith =[UIScreen mainScreen].bounds.size.width-108;
    [self.content setPreferredMaxLayoutWidth:preMaxWaith];
//    [self.titleLabel setText:title];
    //这也很重要
    [self.content layoutIfNeeded];
    [self.content setText:descrip];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //加1是关键
    return size.height+1.0f;
}

@end
