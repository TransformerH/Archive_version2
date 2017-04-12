//
//  CommentTableViewController.m
//  scrollViewDamo
//
//  Created by 韩雪滢 on 9/11/16.
//  Copyright © 2016 小腊. All rights reserved.
//

#import "CommentTableViewController.h"
#import "MessageViewModel.h"
#import "CommentTableViewCell.h"
#import "User.h"
#import "User+Extension.h"

@interface CommentTableViewController ()

@property (nonatomic,strong)NSArray *commentArray;

@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [User reciveCommentWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
        NSLog(@"检测评论列表是否存入");
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"获取评论失败");
    }];

    
    NSLog(@"评论列表界面CommmentList");
    
    UINib *nib = [UINib nibWithNibName:@"CommentTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"commentCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.rowHeight = 90;
    
    //    if(!([MessageViewModel commentListFromPlist] == nil)){
    //    self.commentArray = [MessageViewModel commentListFromPlist];
    //    }else{
    //        self.commentArray = nil;
    //    }
    
   // NSLog(@"评论列表count  %lu",(long)[MessageViewModel commentListFromPlist].count);
    
    
    self.commentArray = [MessageViewModel commentListFromPlist];
    NSLog(@"评论列表count  %lu",(long)[MessageViewModel commentListFromPlist].count);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.commentArray = [MessageViewModel commentListFromPlist];
    return self.commentArray.count;
}


- (CommentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.commentArray = [MessageViewModel commentListFromPlist];
    
    NSLog(@"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%评论列表的第一个  %@",self.commentArray[0]);
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    NSLog(@"评论的cell");
    if(self.commentArray.count > 0){
        cell.name = [[self.commentArray[indexPath.row] valueForKey:@"creator"]valueForKey:@"name"];
        cell.comment = [[self.commentArray[indexPath.row]valueForKey:@"feed"] valueForKey:@"content"];
        cell.updateTime = [self.commentArray[indexPath.row] valueForKey:@"create_time"];
        cell.imgUrl = [[self.commentArray[indexPath.row] valueForKey:@"creator"]valueForKey:@"icon_url"];
    }
    
    return cell;
}


@end
