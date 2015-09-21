//
//  ViewController.m
//  08-AutoLayoutCellHeight_ios7
//
//  Created by ccguo on 15/8/18.
//  Copyright (c) 2015年 ccguo. All rights reserved.
//

#import "ViewController.h"
#import "HomeCell.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    WKWebView *webview;
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"如果你的table view超过了几十行",
                      @"你会发现自动布局约束的",
                      @"解决方式在第一次加载table view的时候会迅速地卡住主线程",
                      @"12244",
                      @"真实的行高值会被计算出来（通过tableView:heightForRowAtIndexPath:方法），估算的行高就会被替换掉",
                      @"因为，在第一次加载过程中，每一行都会调用tableView:heightForRowAtIndexPath:方法（为了计算滚动条的尺寸）iOS7中，你可以（也绝对应该）",@"使用table view的estimatedRowHeight属性。这样会为还不在屏幕范围内的cell提供一个临时估算的行高值。然后，当这些cell即将要滚入屏幕范围内的时候，真实的行高值会被计算出来（通过tableView:heightForRowAtIndexPath:方法），估算的行高就会被替换掉。",
                      @"一般来说，行高估算值不需要太精确——它只是被用来修正tableView中滚动条的大小的，当你在屏幕上滑动cell的时候，即便估算值不准确，tableView还是能很好地调节滚动条。",
                      @"）一个接近于“平均”行高的常量值即可。只有行高变化很极端的时候（比如相差一个数量级）",
                      @"非常不幸，你需要给行高做一些缓存（这是苹果的工程师们给出的改进建议）。大体的思路是，第一次计算时让自动布局引擎解析约束条件，然后将计算出的行高缓存起来，以后所有对该cell的高度的请求都返回缓存值。",
                      @"当然，关键还要确保任何会导致cell高度变化的情况发生时你都清除了缓存的行高——这通常发生在cell的内容变化时或其他重大事件发生时",
                      @"当你dequeue重用一个cell的时候，该类型cell的布局约束已经添加好了，可以直接使用。注意，由于固有内容尺寸的不同，具有相同布局约束的cell仍然可能具有不同的高度！不要混淆了布局（不同的约束）和由不同内容尺寸而计算出（通过相同的布局约束来计算）的不同视图frame这两个概念，它们根本是完全不同的两个东西", nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.content.text = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat preMaxWaith =[UIScreen mainScreen].bounds.size.width-108;
    [cell.content setPreferredMaxLayoutWidth:preMaxWaith];
    [cell.content layoutIfNeeded];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static HomeCell *cell = nil;
    static dispatch_once_t onceToken;
    //只会走一次
    dispatch_once(&onceToken, ^{
        cell = (HomeCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    });
    
    //calculate
    CGFloat height = [cell calulateHeightWithtTitle:[self.dataArray objectAtIndex:indexPath.row] desrip:[self.dataArray objectAtIndex:indexPath.row]];
    
    return height;
}







/*

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断indexPath对应cell的重用标示符，
    // 取决于特定的布局需求（可能只有一个，也或者有多个）
    NSString *reuseIdentifier = @"HomeCell";
    
    // 取出重用标示符对应的cell。
    // 注意，如果重用池(reuse pool)里面没有可用的cell，这个方法会初始化并返回一个全新的cell，
    // 因此不管怎样，此行代码过后，你会可以得到一个布局约束已经完全准备好，可以直接使用的cell。
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    // 用indexPath对应的数据内容来配置cell，例如：
    // cell.textLabel.text = someTextForThisCell;
    // ...
    cell.content.text = [self.dataArray objectAtIndex:indexPath.row];
    // 确保cell的布局约束被设置好了，因为它可能刚刚才被创建好。
    
    // 使用下面两行代码，前提是假设你已经在cell的updateConstraints方法中设置好了约束：
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // 如果你使用的是多行的UILabel，不要忘了，preferredMaxLayoutWidth需要设置正确。
    // 如果你没有在cell的-[layoutSubviews]方法中设置，就在这里设置。
    // 例如：
     cell.content.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)-30;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断indexPath对应cell的重用标示符，
    NSString *reuseIdentifier = @"HomeCell";
    
    // 从cell字典中取出重用标示符对应的cell。如果没有，就创建一个新的然后存储在字典里面。
    // 警告：不要调用table view的dequeueReusableCellWithIdentifier:方法，因为这会导致cell被创建了但是又未曾被tableView:cellForRowAtIndexPath:方法返回，会造成内存泄露！
    UITableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[YourTableViewCellClass alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    // 用indexPath对应的数据内容来配置cell，例如：
    // cell.textLabel.text = someTextForThisCell;
    // ...
    
    // 确保cell的布局约束被设置好了，因为它可能刚刚才被创建好。
    // 使用下面两行代码，前提是假设你已经在cell的updateConstraints方法中设置好了约束：
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // 将cell的宽度设置为和tableView的宽度一样宽。
    // 这点很重要。
    // 如果cell的高度取决于table view的宽度（例如，多行的UILabel通过单词换行等方式），
    // 那么这使得对于不同宽度的table view，我们都可以基于其宽度而得到cell的正确高度。
    // 但是，我们不需要在-[tableView:cellForRowAtIndexPath]方法中做相同的处理，
    // 因为，cell被用到table view中时，这是自动完成的。
    // 也要注意，一些情况下，cell的最终宽度可能不等于table view的宽度。
    // 例如当table view的右边显示了section index的时候，必须要减去这个宽度。
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    // 触发cell的布局过程，会基于布局约束计算所有视图的frame。
    // （注意，你必须要在cell的-[layoutSubviews]方法中给多行的UILabel设置好preferredMaxLayoutWidth值；
    // 或者在下面2行代码前手动设置！）
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // 得到cell的contentView需要的真实高度
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // 要为cell的分割线加上额外的1pt高度。因为分隔线是被加在cell底边和contentView底边之间的。
    height += 1.0f;
    
    return height;
}

// 注意：除非行高极端变化并且你已经明显的觉察到了滚动时滚动条的“跳跃”现象，你才需要实现此方法；否则，直接用tableView的estimatedRowHeight属性即可。
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 以必需的最小计算量，返回一个实际高度数量级之内的估算行高。
    // 例如：
    //
//    if ([self isTallCellAtIndexPath:indexPath]) {
//        return 350.0f;
//    } else {
//        return 40.0f;
//    }
    
    return 40.0f;
}*/

@end
