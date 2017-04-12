//
//  CommentsDetailVC.m
//  Alumni
//
//  Created by 韩雪滢 on 4/10/17.
//
//

#import "CommentsDetailVC.h"
#import "MessageViewController.h"
#import "User.h"
#import "User+Extension.h"
#import "StaticData.h"
#import "Circle.h"
#import "Circle+Extension.h"


@interface CommentsDetailVC ()
@property (weak, nonatomic) IBOutlet UITextView *feedContent;
@property (strong,nonatomic) NSMutableDictionary *commentDic;

@property (weak, nonatomic) IBOutlet UITextView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *comName;
@property (weak, nonatomic) IBOutlet UILabel *comTime;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLC;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UITextView *nCommentView;


@property (strong,nonatomic) NSMutableArray *comments;
@property (strong,nonatomic) NSString *feed_id;
@property (strong,nonatomic) NSString *ifLiked;

@end

@implementation CommentsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView
    self.comments = [[NSMutableArray alloc] init];
    
    
    //从plist中获得commentContent
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath1= [paths objectAtIndex:0];
    NSLog(@"%@",plistPath1);
    NSString *fileName = [plistPath1 stringByAppendingPathComponent:@"currentComment.plist"];
    self.commentDic = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    NSDictionary *userDic = [[NSDictionary alloc]initWithDictionary:[User getUserDic]];
    
    
    self.feed_id = [[self.commentDic valueForKey:@"feed"] valueForKey:@"id"];
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %@",self.commentDic);
    
    self.feedContent.text = [[self.commentDic valueForKey:@"feed"] valueForKey:@"content"];
    self.comName.text = [[[self.commentDic valueForKey:@"creator"] valueForKey:@"name"] substringFromIndex:11];
    self.comTime.text = [self.commentDic valueForKey:@"create_time"];
   
    self.commentView.text = [self.commentDic valueForKey:@"content"];
    
    self.userNameLabel.text = [userDic valueForKey:@"name"];
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>用户信息%@",userDic);
    
    UIImage *userimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[User getUserDic]valueForKey:@"icon_url"]]]];;
    [self.userImgView setImage:userimg];
    
  
    NSDictionary *feedDetails = [[NSDictionary alloc] initWithObjectsAndKeys:self.feed_id,@"feed_id",[User getXrsf],@"_xsrf", nil];
    
    NSLog(@"+++++++++++++++++++++++++++++++++++++++++++++ 发送：%@",feedDetails);
    
   //---------------  设置likebutton 初始状态
    
    [User feedDetailsWithParameters:feedDetails SuccessBlock:^(NSDictionary *dict, BOOL success) {
         NSLog(@"++++++++++++++++++++++++++++++++++++++++++  获得动态详情成功 ：%@", dict);
        self.ifLiked = [[[dict valueForKey:@"Data"] valueForKey:@"response"] valueForKey:@"liked"];
        
    } AFNErrorBlock:^(NSError *error) {
         NSLog(@"++++++++++++++++++++++++++++++++++++++++++  获得动态详情失败 ：%@",error);
    }];
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    if([self.ifLiked isEqualToString:@"False"]){
        [self.followBtn setImage:[UIImage imageNamed:@"message_like"] forState:UIControlStateNormal];
    }else{
       [self.followBtn setImage:[UIImage imageNamed:@"message_liked"] forState:UIControlStateNormal];
       
    }
    
}


- (void)fingerTapped:(UITapGestureRecognizer*)gestureRecognizer{
    [self.view endEditing:YES];
}

- (IBAction)returnToH:(id)sender {
    MessageViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FiveTab"];
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)keyboardAppear:(NSNotification *)aNotification
{
    NSDictionary * userInfo = aNotification.userInfo;
    CGRect frameOfKeyboard = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.view.frame;
    
    CGRect vFrame = self.bottomView.frame;
    
    CGFloat height = frame.size.height - frameOfKeyboard.origin.y;//加64是因为存在navigation导致view本身就整体下移了64个单位
    self.bottomView.frame = CGRectMake(vFrame.origin.x, height+85, vFrame.size.width, vFrame.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)follow:(id)sender {
    if([self.ifLiked isEqualToString:@"False"]){
        [self.followBtn setImage:[UIImage imageNamed:@"message_liked"] forState:UIControlStateNormal];
        
          self.ifLiked = @"True";
        
        NSDictionary *userInfo =[[NSDictionary alloc] initWithObjectsAndKeys:@"POST",@"method",self.feed_id,@"feed_id",[User getXrsf],@"_xsrf",nil];
        [Circle greatWithParameters:userInfo];
        
    }else{
        [self.followBtn setImage:[UIImage imageNamed:@"message_like"] forState:UIControlStateNormal];
         self.ifLiked = @"False";
        
        NSDictionary *userInfo =[[NSDictionary alloc] initWithObjectsAndKeys:@"DELETE",@"method",self.feed_id,@"feed_id",[User getXrsf],@"_xsrf",nil];
        [Circle greatWithParameters:userInfo];
    }
}

- (IBAction)sendComment:(id)sender {
    
    NSString *cucomment = self.commentTF.text;
    
    if(![cucomment isEqualToString:@""]){
        
        [self.comments addObject:cucomment];
        
        NSDictionary *userInfo =[[NSDictionary alloc] initWithObjectsAndKeys:self.feed_id,@"feed_id",self.commentTF.text,@"content", nil];
        NSDictionary *postdic = [[NSDictionary alloc] initWithObjectsAndKeys: [self dictionaryToJson:userInfo],@"info_json",[User getXrsf],@"_xsrf", nil];
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>> 发送的CommentDic  %@",postdic);
        
        [Circle pubcommentWithParameters:postdic];
        
        NSString *changeCo = @"";
        
        for(int i=0;i<self.comments.count;i++){
            changeCo = [NSString stringWithFormat:@"%@\n%@: %@",changeCo,[[User getUserDic]valueForKey:@"name"],self.comments[i]];
        }
        
        self.nCommentView.text = changeCo;
        
        
    }
}


- (NSString *)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


@end
