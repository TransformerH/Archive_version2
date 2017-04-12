//
//  CardTableViewController.m
//  scrollViewDamo
//
//  Created by 韩雪滢 on 8/26/16.
//  Copyright © 2016 小腊. All rights reserved.
//

#import "CardTableViewController.h"
#import "MJRefresh.h"
#import "CardCell.h"
#import "MeViewModel.h"
#import "User.h"
#import "User+Extension.h"

#import "MeInfoViewModel.h"


@interface CardTableViewController ()

@property (nonatomic,strong)MeViewModel *meVM;
@property (strong,nonatomic)MeInfoViewModel *meInfoVM;

@end

@implementation CardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.meInfoVM = [MeInfoViewModel getMeInfoVM];
    
    
    UINib *nib = [UINib nibWithNibName:@"CardCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"card"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 116;
    
    self.tableView.userInteractionEnabled = YES;
    
    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  防止IOS自动释放self
    __typeof (self) __weak weakSelf = self;
    
    //   MJRefresh  上拉刷新数据
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        
       
                [weakSelf delayInSeconds:1.0 block:^{
                    if(weakSelf.itemNum < [MeViewModel collectCardsFromPlist].count){
                        if((weakSelf.itemNum + 4) < ([MeViewModel collectCardsFromPlist].count )){
                            weakSelf.itemNum += 4;
                        }else{
                            weakSelf.itemNum += ([MeViewModel collectCardsFromPlist].count - weakSelf.itemNum);
                            
                            NSLog(@"%@", [[NSString alloc] initWithFormat:@"现在的数字是%ld",(long)weakSelf.itemNum]);
                        }
                        [weakSelf.tableView.footer endRefreshing];
                        [weakSelf.tableView reloadData];
                    }
                }];
    }];
    
}
- (void)delayInSeconds:(CGFloat)delayInSeconds block:(dispatch_block_t) block
{
    //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  延迟时间，将block 中执行的操作加入到队列中
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),  dispatch_get_main_queue(), block);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _itemNum;
}

- (CardCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card" forIndexPath:indexPath];
    //    if(![[[MeViewModel collectCardsFromPlist][indexPath.row] valueForKey:@"source_uid"] isEqualToString:[[NSString alloc] initWithFormat: @"%d",-1]]){
    if([MeViewModel collectCardsFromPlist].count > 0){
        
        NSLog(@"******************************??????????????????????????????????  这是啥 %@",[MeViewModel collectCardsFromPlist][indexPath.row]);
        
        cell.name = [[MeViewModel collectCardsFromPlist][indexPath.row] valueForKey:@"name"];
        cell.major =[[[MeViewModel collectCardsFromPlist][indexPath.row] valueForKey:@"custom"] valueForKey:@"fa"];
        cell.classNum =[[[MeViewModel collectCardsFromPlist][indexPath.row] valueForKey:@"custom"] valueForKey:@"ma"];
        cell.job = [[[MeViewModel collectCardsFromPlist][indexPath.row] valueForKey:@"custom"] valueForKey:@"jo"];
        
        cell.imgUrl =[[MeViewModel collectCardsFromPlist][indexPath.row] valueForKey:@"icon_url"];
    }
    //    }else{
    //        cell.name = @"系统管理员";
    //        cell.major = @"软件学院";
    //        cell.classNum = @"软件工程专业";
    //        cell.job = @"student";
    //    }
    return cell;
}

@end
