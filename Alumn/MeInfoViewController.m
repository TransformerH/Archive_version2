//
//  MeInfoViewController.m
//  MeInfoDemo
//
//  Created by 韩雪滢 on 8/31/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "MeInfoViewController.h"
#import "MeInfoViewModel.h"
#import "User.h"
#import "User+Extension.h"

@interface MeInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *enrollYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIButton *leftBottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBottomBtn;
@property (strong, nonatomic) IBOutlet UIView *allView;
//@property (nonatomic,strong) UILabel *cardLabel;

@property (strong,nonatomic) MeInfoViewModel *meInfoVM;

@end



@implementation MeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *barBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    barBackground.backgroundColor = [UIColor colorWithRed:111.0 / 225.0 green:214 / 225.0 blue:157.0 / 225.0 alpha:1.0];
    [self.view addSubview:barBackground];
    
    // Do any additional setup after loading the view.
    
    //---------------------------------------------   设置navigationBar透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    //----------------------------------------------  设置navigationBar透明
    
    [self.navigationController.navigationItem setTitle:@"人脉详情"];
    self.meInfoVM = [MeInfoViewModel getMeInfoVM];
    NSLog(@"MeViewInfoVMn %@ %@ %@ %@ %@ %@ :",self.schoolLabel.text, self.majorLabel.text,self.classLabel.text, self.enrollYearLabel.text, self.companyLabel.text,self.jobLabel.text);
    
    self.schoolLabel.text = self.meInfoVM.school;
    self.majorLabel.text = self.meInfoVM.major;
    self.classLabel.text = self.meInfoVM.classNum;
    self.enrollYearLabel.text = self.meInfoVM.enrollYear;
    self.companyLabel.text = self.meInfoVM.company;
    self.jobLabel.text = self.meInfoVM.job;
    

    
    
    [self initHeadView];
    
}


//--------------------------------------  init headView
- (void)initHeadView{
    //-----------------   edge of the view
    _firstView.layer.borderWidth = 0.8;
    _firstView.layer.borderColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
    
    _lastView.layer.borderColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
    _lastView.layer.borderWidth = 0.8;
    
    //-----------------  buttons at the bottom of the view
    
    UIImage *starImg = [UIImage imageNamed:@"star"];
    UIImageView *starImgView = [[UIImageView alloc] initWithImage:starImg];
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftBottomBtn.bounds.size.width / 2.0, _leftBottomBtn.bounds.size.height * 0.1, _leftBottomBtn.bounds.size.width / 2.0, _leftBottomBtn.bounds.size.height)];
    starLabel.text = @"TA的动态";
    starLabel.textColor = [UIColor whiteColor];
    starImgView.frame = CGRectMake(_leftBottomBtn.frame.size.height * 0.8, _leftBottomBtn.frame.size.height * 0.4,starImg.size.width * 0.5 , starImg.size.height * 0.5);
    
    [self.leftBottomBtn setTitle:@"TA的动态" forState:UIControlStateNormal];
    
//    [_leftBottomBtn addSubview:starLabel];
//    [_leftBottomBtn addSubview:starImgView];
    
    UIImage *cardImg = [UIImage imageNamed:@"mark"];
    UIImageView *cardImgView = [[UIImageView alloc] initWithImage:cardImg];
//    self.cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftBottomBtn.bounds.size.width / 2.0, _leftBottomBtn.bounds.size.height * 0.1, _leftBottomBtn.bounds.size.width / 2.0,  _leftBottomBtn.bounds.size.height)];
    
    //---------------------------------  判断该用户是否已经被收藏
    if(self.meInfoVM.followedOrNot){
        [self.rightBottomBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    }else{
       [self.rightBottomBtn setTitle:@"收藏名片" forState:UIControlStateNormal];
    }
    
    
//    self.cardLabel.textColor = [UIColor whiteColor];
    cardImgView.frame = CGRectMake(_leftBottomBtn.frame.size.height * 0.8, _leftBottomBtn.frame.size.height * 0.4,starImg.size.width * 0.5 , starImg.size.height * 0.5);
    
//    [_rightBottomBtn addSubview:cardImgView];
//    [_rightBottomBtn addSubview:self.cardLabel];
    
    //-----------------------------------   先加底图
    UIImage *maskImg = [self imageByApplyingAlpha:0.8 image:[UIImage imageNamed:@"meBG"]];
    UIImageView *maskImgView = [[UIImageView alloc] initWithImage:[self OriginImage:maskImg scaleToSize:CGRectMake(0, 0, self.view.frame.size.width, _headView.frame.size.height).size]];
   //---------------####################################   设置headImg
    UIImage *headImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.meInfoVM.user_icon]]];
    UIImageView *primerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _headView.frame.size.height)];
    primerImgView.contentMode = UIViewContentModeCenter;
    primerImgView.clipsToBounds = YES;
    primerImgView.image = [self OriginImage:headImg scaleToSize:CGSizeMake(_headView.bounds.size.width, _headView.bounds.size.width)];
   
    [_headView addSubview:primerImgView];
    [_headView addSubview:maskImgView];
    
//    //---------------------------------    再加 控件
//    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
//    [backBtn setTitle:@"<" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_headView addSubview:backBtn];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( _headView.bounds.size.width / 3.0,0, _headView.bounds.size.width/2.0, 60)];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"人脉详情";
//    titleLabel.textColor = [UIColor whiteColor];
//    [_headView addSubview:titleLabel];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_headView.bounds.size.width / 8.5, 72, 70, 70)];
    headImgView.image = headImg;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = headImgView.bounds.size.width / 2.0;
    headImgView.layer.borderWidth = 1.5;
    headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_headView addSubview:headImgView];
    
    //headImgView.bounds.origin.x + headImgView.bounds.size.width / 2.0  headImgView.bounds.origin.y - headImgView.bounds.size.height / 2.0
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImgView.frame.origin.x + headImgView.frame.size.width * 1.2, headImgView.frame.origin.y - 10 , _headView.bounds.size.width / 5.0, 30)];
    nameLabel.text = self.meInfoVM.name;
    nameLabel.textColor = [UIColor whiteColor];
    [_headView addSubview:nameLabel];
    
    UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImgView.frame.origin.x + headImgView.frame.size.width * 1.2 , nameLabel.frame.origin.y + nameLabel.frame.size.height, _headView.bounds.size.width / 2.8, 30)];
    jobLabel.text = self.meInfoVM.job;
    jobLabel.textColor = [UIColor whiteColor];
    jobLabel.font = [UIFont systemFontOfSize:14.0f];
    [_headView addSubview:jobLabel];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImgView.frame.origin.x + headImgView.frame.size.width * 1.2, jobLabel.frame.origin.y + jobLabel.frame.size.height, _headView.bounds.size.width / 5.0, 30)];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.font = [UIFont systemFontOfSize:13.0f];
    cityLabel.text = self.meInfoVM.city;
    [_headView addSubview:cityLabel];
   
    
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(_headView.bounds.size.width * (1 - 0.3),  (nameLabel.frame.origin.y + nameLabel.frame.size.height), _headView.bounds.size.width / 5.0, 27)];
    [messageButton setTitle:@"留言" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    messageButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    messageButton.layer.masksToBounds = YES;
    messageButton.layer.cornerRadius = 6.0;
    messageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    messageButton.layer.borderWidth = 1.2;
    [_headView addSubview:messageButton];
}

//改变图片的大小适应image View的大小
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image

{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    
    
    CGContextSetAlpha(ctx, alpha);
    
    
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    
    
    return newImage;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)followAction:(id)sender {
    
    NSString *followOrNot = [[NSString alloc] init];
    if(self.meInfoVM.followedOrNot){
        followOrNot = @"unfollow";
    }else {
        followOrNot = @"follow";
    }
    
    NSLog(@"点击收藏名片button ， 当前为 %@",followOrNot);
    
    NSDictionary *followDic = [[NSDictionary alloc]initWithObjectsAndKeys:[User getXrsf],@"_xsrf",followOrNot,@"target",self.meInfoVM.uid,@"uid", nil];
    
    [User collectTheCard:followDic SuccessBlock:^(NSDictionary *dict, BOOL success) {
        NSString *has_followed = [[[dict valueForKey:@"Data"]valueForKey:@"response"]valueForKey:@"has_followed"];
        
        if([has_followed isEqualToString:@"True"]){
            [self.rightBottomBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
        }else{
            [self.rightBottomBtn setTitle:@"收藏名片" forState:UIControlStateNormal];

        }
        
        NSLog(@"收藏／取消收藏 名片成功");
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"收藏／取消收藏 名片失败");
    }];

    
}

@end
