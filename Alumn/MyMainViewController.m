//
//  MyMainViewController.m
//  FitTiger
//
//  Created by SherylHan.
//  Copyright © 2016年. All rights reserved.
//

#define HeadMenuViewHeight 45
// 获取RGB颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]


#import "MyMainViewController.h"
#import "TableViewController.h"
#import "JoinedCircleTableViewController.h"
#import "CardTableViewController.h"
#import "User.h"
#import "User+Extension.h"
#import "MeViewModel.h"
#import "AFNetManager.h"
#import   "UIImageView+WebCache.h"
#import "SettingViewController.h"
#import "LoginViewController.h"


@interface MyMainViewController ()<UIScrollViewDelegate,UITableViewDelegate>
{
    CGFloat _lastPosition;
}

@property (nonatomic,strong)MeViewModel *meVM;


//框架最下面的scrollView;
//最底层scrollerView
@property(nonatomic,strong)UIScrollView * bottomScrollView;
//左右滑动的scrollView
@property(nonatomic,strong)UIScrollView * contentScrollView;
//这个是模拟头部最上面那个滑动视图
@property(nonatomic,strong)UILabel * headScrollView;
//这个是中间那个菜单
@property(nonatomic,retain)UIScrollView * headMenuScrollView;
//模拟数据用的
@property(nonatomic,retain)NSArray * headMenuDateArray;
//这个数组放 tableView
@property(nonatomic,retain)NSMutableArray * contableTableViewArray;


//headScrollView当前被选中的按钮标记 默认为0
@property(nonatomic,assign)NSInteger currentSeletedHeadScrollViewSubButtonNumberTag;
//headScrollView当前被选中的按钮标记 默认为0
@property(nonatomic,assign)UIButton * currentSeletedButton;
@property(nonatomic,assign)CGFloat currentContScrollViewOffSizeWidth;
@property(nonatomic,assign)BOOL refusedHeadSrollViewAnimation;
@property(nonatomic,assign)UIView * contentViewLeftView;
@property(nonatomic,assign)UIView * contentViewRightView;
@property(nonatomic,assign)UIView * contentViewCurrentView;

//用户信息
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userJob;
@property (nonatomic,strong) NSString *userFaculty;
@property (nonatomic,strong) NSString *userYear;
@property (nonatomic,strong) NSString *userMajor;

@end

@implementation MyMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.meVM = [[MeViewModel alloc] init];
    
    

    
    [User MyAdminCirlceIntroduceWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
        NSLog(@"获得加入的圈子列表 : %@",dict);
        [self.meVM getMyAdminCircleList:[dict valueForKey:@"Data"]];
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"获得失败，加入的圈子");
    }];
    
    [User MyCreateCirlceIntroduceWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
        NSLog(@"获得创建的圈子列表: %@",dict);
        [self.meVM getMyCreateCircleList:[dict valueForKey:@"Data"]];
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"获得失败，创建的圈子");
    }];
    
    [User CardWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
        NSLog(@"获得收藏的Cards :%@",dict);
        [self.meVM getMyCardsList:[dict valueForKey:@"Data"]];
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"获得失败，收藏的Cards");
    }];
    
    
    
    [self initWithUserInterface];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    self.headMenuDateArray = @[@"收藏的名片",@"管理的圈子",@"创建的圈子"];
}
- (void)initWithUserInterface
{
    _contableTableViewArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.headScrollView];
    [self.bottomScrollView addSubview:self.headMenuScrollView];
    [self.bottomScrollView addSubview:self.contentScrollView];
    
    
    //setButton
    UIButton *setButton = [[UIButton alloc] init];
    setButton.frame = CGRectMake( 45, 35, 20, 20);
    [setButton setBackgroundImage:[self OriginImage:[UIImage imageNamed:@"changeInfoLogo"] scaleToSize:setButton.bounds.size] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(settingVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 45), 35, 20, 20)];
    [logoutButton setBackgroundImage:[self OriginImage:[UIImage imageNamed:@"logoutLogo"] scaleToSize:logoutButton.bounds.size] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    
}

- (void)logout:(id)sender{
    [User logoutWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        //  [self presentViewController:loginVC animated:YES completion:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:DocumentsPath];
        for(NSString *fileName in enumerator){
            [
            [NSFileManager defaultManager] removeItemAtPath:[DocumentsPath stringByAppendingPathComponent:fileName] error:nil];
        }
        
        NSLog(@"退出成功");
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"退出失败");
    }];
}

- (UIScrollView *)bottomScrollView
{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        _bottomScrollView.delegate = self;
        _bottomScrollView.backgroundColor = [UIColor whiteColor];
        [_bottomScrollView.layer setBorderWidth:1];
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.bounds.size.width , _bottomScrollView.bounds.size.height + self.headScrollView.frame.size.height);
        _bottomScrollView.alwaysBounceVertical = YES;
        _bottomScrollView.alwaysBounceHorizontal = NO;
    }
    return _bottomScrollView;
}
- (UILabel *)headScrollView
{
    if (!_headScrollView) {
        
        
        if([User getUserDic].count > 0){
            self.userName = [[User getUserDic] valueForKey:@"name"];
            self.userJob = [[User getUserDic] valueForKey:@"job"];
            self.userFaculty = [[User getUserDic] valueForKey:@"faculty"];
            self.userYear = [NSString stringWithFormat:@"%@",[[User getUserDic] valueForKey:@"admission_year"]];
            self.userMajor = [[User getUserDic] valueForKey:@"major"];
            
            NSLog(@"-------------------------------%@-%@-%@-%@-%@",self.userName,self.userJob,self.userFaculty,self.userYear,self.userMajor);
        }
        
        
        _headScrollView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 265)];
        
        // 最底下的图片
        UIImage *backImg = [UIImage imageNamed:@"meBG"];
        
        UIImageView *backImgView = [[UIImageView alloc]initWithImage:[self OriginImage:backImg scaleToSize:self.headScrollView.bounds.size]];
        
        backImgView.contentMode = UIViewContentModeScaleAspectFill;
        //头像图片＋📷
        
        UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake((_headScrollView.bounds.size.width / 2.0 - 55),( _headScrollView.bounds.size.height / 2.0 - 55), 110, 110)];
        
        
        UIImageView *userHead = [[UIImageView alloc] initWithFrame:CGRectMake(userImg.frame.origin.x, userImg.frame.origin.y, 100, 100)];
        UIImage *img2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[User getUserDic]valueForKey:@"icon_url"]]]];
        NSLog(@"用户头像检查:%@",[[User getUserDic] valueForKey:@"icon_url"]);
        [userHead setImage:[self OriginImage:img2 scaleToSize:userHead.bounds.size]];
        
        //[userHead sd_setImageWithURL:[NSURL URLWithString:[[User getUserDic] valueForKey:@"icon_url"]]];
        userHead.layer.masksToBounds = YES;
        userHead.layer.cornerRadius = userHead.bounds.size.width / 2.0;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImg.frame.origin.x+10, userImg.frame.origin.y+110, 80, 30)];
        nameLabel.text = self.userName;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:(CGFloat)16];
        
        UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+50, nameLabel.frame.origin.y, 80, 30)];
        jobLabel.text = self.userJob;
        jobLabel.textColor = [UIColor whiteColor];
        jobLabel.font = [UIFont systemFontOfSize:(CGFloat)12];
        
        UILabel *facultyLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x-40, nameLabel.frame.origin.y+20, 80, 30)];
        facultyLabel.text = self.userFaculty;
        facultyLabel.textColor = [UIColor whiteColor];
        facultyLabel.font = [UIFont systemFontOfSize:(CGFloat)12];
        
        UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(facultyLabel.frame.origin.x+70, facultyLabel.frame.origin.y, 50, 30)];
        yearLabel.text = [NSString stringWithFormat:@"%@",self.userYear];
        yearLabel.textColor = [UIColor whiteColor];
        yearLabel.font = [UIFont systemFontOfSize:(CGFloat)12];
        
        UILabel *majorLabel = [[UILabel alloc] initWithFrame:CGRectMake(yearLabel.frame.origin.x+40, facultyLabel.frame.origin.y, 80, 30)];
        majorLabel.text = @"软件工程";
        majorLabel.textColor = [UIColor whiteColor];
        majorLabel.font = [UIFont systemFontOfSize:(CGFloat)12];
        
        
        
        
        //        UIButton *chooseBtn = [[UIButton alloc] init];
        //        chooseBtn.frame = CGRectMake((userHead.frame.origin.x + userHead.frame.size.width / 2), (userHead.frame.origin.y + userHead.frame.size.height * 0.5), 60, 60);
        //        [chooseBtn setBackgroundImage:[self OriginImage:[UIImage imageNamed:@"photoImg"] scaleToSize:chooseBtn.frame.size] forState:UIControlStateNormal];
        
        //        //setButton
        //        UIButton *setButton = [[UIButton alloc] init];
        //        setButton.frame = CGRectMake((_headScrollView.bounds.size.width - 45), 35, 24, 24);
        //        [setButton setBackgroundImage:[self OriginImage:[UIImage imageNamed:@"setBtn"] scaleToSize:setButton.bounds.size] forState:UIControlStateNormal];
        //        [setButton addTarget:self action:@selector(settingVC:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [backImgView addSubview:userImg];
        [backImgView addSubview:userHead];
        
        [backImgView addSubview:nameLabel];
        [backImgView addSubview:jobLabel];
        [backImgView addSubview:facultyLabel];
        [backImgView addSubview:yearLabel];
        [backImgView addSubview:majorLabel];
        //        [backImgView addSubview:chooseBtn];
        //   [backImgView addSubview:setButton];
        
        
        [self.headScrollView addSubview:backImgView];
        
    }
    return _headScrollView;
}

//调用setting界面
- (void)settingVC:(id)sender{
    
    NSLog(@"跳转setting界面");
    
    SettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
    [self.navigationController pushViewController:settingVC animated:YES];
    // [self presentViewController:settingVC animated:YES completion:nil];
    
}


//改变图片的大小适应image View的大小
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (UIScrollView *)headMenuScrollView
{
    if (!_headMenuScrollView) {
        _headMenuScrollView = [self createHeadMenuScrollView];
    }
    return _headMenuScrollView;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headMenuScrollView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), self.bottomScrollView.bounds.size.height - self.headMenuScrollView.bounds.size.height)];
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        if (_headMenuDateArray.count < 3) {
            _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * _headMenuDateArray.count , _contentScrollView.bounds.size.height);
        }else{
            _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * 3 , _contentScrollView.bounds.size.height);
        }
    }
    
    return _contentScrollView;
}
- (void)setHeadMenuDateArray:(NSArray *)headMenuDateArray
{
    if (_headMenuDateArray) {
        _headMenuDateArray = nil;
    }
    [_headMenuScrollView removeFromSuperview];
    _headMenuDateArray = headMenuDateArray;
    
    if (_headMenuDateArray.count < 3) {
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * _headMenuDateArray.count , _contentScrollView.bounds.size.height);
    }else{
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * 3 , _contentScrollView.bounds.size.height);
    }
    self.headMenuScrollView = [self createHeadMenuScrollView];
    [self.bottomScrollView addSubview:_headMenuScrollView];
    [self setContentscrollViewContentTableView];
}

- (void)setCurrentSeletedHeadScrollViewSubButtonNumberTag:(NSInteger)currentSeletedHeadScrollViewSubButtonNumberTag
{
    _currentSeletedHeadScrollViewSubButtonNumberTag = currentSeletedHeadScrollViewSubButtonNumberTag;
    if (_headMenuScrollView && _headMenuDateArray.count) {
        UIView * view = [_headMenuScrollView viewWithTag:100];
        UIButton * button = (UIButton *)[_headMenuScrollView viewWithTag:1000 + currentSeletedHeadScrollViewSubButtonNumberTag];
        button.center = CGPointMake(button.frame.size.width * (CGFloat)(0.5 + currentSeletedHeadScrollViewSubButtonNumberTag), button.center.y);
        view.center = CGPointMake(view.frame.size.width * (CGFloat)(0.5 + currentSeletedHeadScrollViewSubButtonNumberTag), view.center.y);
        if (_currentSeletedButton) {
            _currentSeletedButton.selected = NO;
        }
        button.selected = YES;
        [self contentScrollViewPressAnimation];
        _currentSeletedButton = button;
        [self headMenuScrollViewPressAnimation];
        
    }
}
//创建headmenuScrollView
- (UIScrollView *)createHeadMenuScrollView
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headScrollView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), HeadMenuViewHeight)];
    if (_headMenuScrollView) {
        scrollView.frame = _headMenuScrollView.frame;
    }
    scrollView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    if (_headMenuDateArray && _headMenuDateArray.count > 0) {
        NSInteger arrayCount = _headMenuDateArray.count;
        
        CGFloat  buttonWidth = 0;
        if (arrayCount <= 4){
            buttonWidth = CGRectGetWidth([UIScreen mainScreen].bounds)/arrayCount;
        }
        else if (arrayCount > 4){
            buttonWidth = CGRectGetWidth([UIScreen mainScreen].bounds)/4.0;
        }
        scrollView.contentSize = CGSizeMake(buttonWidth * arrayCount , scrollView.frame.size.height);
        for (int i = 0 ; i < _headMenuDateArray.count ; i ++) {
            NSString * string = _headMenuDateArray[i];
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, scrollView.frame.size.height)];
            button.center = CGPointMake(buttonWidth * (CGFloat)(0.5 + i), scrollView.frame.size.height/2.0);
            [button setTitle:string forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [button setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor grayColor].CGColor];
            [button.layer setBorderWidth:0.2];
            [button.layer setMasksToBounds:YES];
            //            [button setTitleColor:RGB(24, 181, 44) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(processHeadMenuScrollViewButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1000 + i;
            [scrollView addSubview:button];
            
            if (i == _currentSeletedHeadScrollViewSubButtonNumberTag){
                button.selected = YES;
                _currentSeletedButton = button;
            }
        }
        
        //$$$$$$$$$$$$$$$$$$$$$$点击button下的选中标记
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, 3/ 667.0 * CGRectGetHeight([UIScreen mainScreen].bounds))];
        //######################$$$$$$$$$$$$$$$$$$$$$$修改被选中button的标志
        
        UIImage *markImg = [UIImage imageNamed:@"markImg"];
        UIImageView *backImgView = [[UIImageView alloc]initWithImage:[self OriginImage:markImg scaleToSize:view.bounds.size]];
        
        backImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        view.center = CGPointMake(buttonWidth * (CGFloat)(0.5 + _currentSeletedHeadScrollViewSubButtonNumberTag), scrollView.frame.size.height - view.frame.size.height/2.0);
        view.tag = 100;
        
        
        [view addSubview:backImgView];
        
        [scrollView addSubview:view];
    }else{
        // $$$$$$$$$$$$$$$$$$$$$$$$$$$$  加载提示符UIActivityIndicator＋Label
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center =  CGPointMake( 130/ 375.0 * CGRectGetWidth([UIScreen mainScreen].bounds) , scrollView.bounds.size.height/2.0);
        [scrollView addSubview:activityView];
        [activityView startAnimating];
        
        UILabel * label = [[UILabel alloc]initWithFrame:scrollView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = @"      正在加载数据";
        label.textColor = [UIColor colorWithRed:166 green:166 blue:166 alpha:1.0];
        [scrollView addSubview:label];
    }
    
    return scrollView;
}


#warning Mark替换代码修改区

//创建下面的tableView
- (void)setContentscrollViewContentTableView
{
    //$$$$$$$$$$$$$$$$$$$$$$$$ tableViewArray 初始化
    [self.contableTableViewArray removeAllObjects];
    
    for (int i = 0; i < self.headMenuDateArray.count; i ++) {
        
        switch (i) {
            case 0:
            {
                NSLog(@"contentTable0");
                
                CardTableViewController *cardTableVC = [[CardTableViewController alloc] init];
                cardTableVC.itemNum = [MeViewModel collectCardsFromPlist].count;
                cardTableVC.page = i+1;
                cardTableVC.view.frame = self.contentScrollView.bounds;
                cardTableVC.tableView.delegate = self;
                cardTableVC.tableView.tag = 100+i;
                [self addChildViewController:cardTableVC];
                
                [_bottomScrollView.panGestureRecognizer requireGestureRecognizerToFail:cardTableVC.tableView.panGestureRecognizer];
                [self.contableTableViewArray addObject:cardTableVC.view];
                
                break;
            }
                
            case 1:
            {
                NSLog(@"contentTable1");
                
                JoinedCircleTableViewController *joinedCircleVC = [[JoinedCircleTableViewController alloc]init];
                joinedCircleVC.itemNum = [MeViewModel adminCircleFromPlist].count;
                joinedCircleVC.page = i+1;
                joinedCircleVC.view.frame = self.contentScrollView.bounds;
                joinedCircleVC.tableView.delegate = self;
                joinedCircleVC.tableView.tag = 100 +  i;
                [self addChildViewController:joinedCircleVC];
                
                [_bottomScrollView.panGestureRecognizer requireGestureRecognizerToFail:joinedCircleVC.tableView.panGestureRecognizer];
                
                [self.contableTableViewArray addObject:joinedCircleVC.view];
                break;
            }
            case 2:
            {
                NSLog(@"contentTable 2");
                
                TableViewController *tableViewVC = [[TableViewController alloc]init];
                tableViewVC.itemNum = [MeViewModel createCircleFromPlist].count;
                tableViewVC.page = i+1;
                tableViewVC.view.frame = self.contentScrollView.bounds;
                tableViewVC.tableView.delegate = self;
                tableViewVC.tableView.tag = 100 + i;
                [self addChildViewController:tableViewVC];
                
                [_bottomScrollView.panGestureRecognizer requireGestureRecognizerToFail:tableViewVC.tableView.panGestureRecognizer];
                
                [self.contableTableViewArray addObject:tableViewVC.view];
                break;
            }
            default:
                break;
        }
        
    }
    
    [self contentScrollViewArrangementContent];
}




//按钮事件
- (void)processHeadMenuScrollViewButton:(UIButton *)button
{
    if (_currentSeletedButton && button == _currentSeletedButton) {
        return;
    }
    self.currentSeletedHeadScrollViewSubButtonNumberTag = button.tag - 1000;
}
#pragma mark -- contentScrollView方法部分

//contentScrollView内容整理和更换
- (void)contentScrollViewArrangementContent
{
    if (_headMenuDateArray.count  && _currentSeletedHeadScrollViewSubButtonNumberTag >= 0 && _currentSeletedHeadScrollViewSubButtonNumberTag <= _headMenuDateArray.count - 1 ) {
        NSInteger number = _headMenuDateArray.count >= 3 ? 3 : _headMenuDateArray.count;
        if (number >= 3) {
            NSInteger judge = 0;
            if (_currentSeletedHeadScrollViewSubButtonNumberTag - 1 <= 0) {
                judge = 0;
            }else if(_currentSeletedHeadScrollViewSubButtonNumberTag == _headMenuDateArray.count - 1){
                judge = _currentSeletedHeadScrollViewSubButtonNumberTag - 2;
            }else{
                judge = _currentSeletedHeadScrollViewSubButtonNumberTag - 1;
            }
            [_contentViewCurrentView removeFromSuperview];
            [_contentViewLeftView    removeFromSuperview];
            [_contentViewRightView   removeFromSuperview];
            _contentViewCurrentView = nil;
            _contentViewLeftView = nil;
            _contentViewRightView = nil;
            for (int i = 0; i < number; i ++) {
                
                UIView * view = _contableTableViewArray[i + judge];
                view.center = CGPointMake(_contentScrollView.frame.size.width * (i + 0.5) , _contentScrollView.frame.size.height/2.0);
                
                [_contentScrollView addSubview:view];
                
                if (i + judge == _currentSeletedHeadScrollViewSubButtonNumberTag) {
                    _contentScrollView.contentOffset = CGPointMake(_contentScrollView.frame.size.width * i, 0);
                    _currentContScrollViewOffSizeWidth = _contentScrollView.frame.size.width * i;
                    self.contentViewCurrentView = view;
                }else if (i + judge == _currentSeletedHeadScrollViewSubButtonNumberTag + 1){
                    self.contentViewRightView = view;
                }else if (i + judge == _currentSeletedHeadScrollViewSubButtonNumberTag - 1){
                    self.contentViewLeftView = view;
                }
                
            }
        }else{
            for (int i = 0; i < number; i ++) {
                
                UIView * view = _contableTableViewArray[i];
                view.center = CGPointMake(_contentScrollView.frame.size.width * (i + 0.5) , _contentScrollView.frame.size.height/2.0);
                
                [_contentScrollView addSubview:view];
                
                if (i  == _currentSeletedHeadScrollViewSubButtonNumberTag) {
                    self.contentViewCurrentView = view;
                    _contentScrollView.contentOffset = CGPointMake(_contentScrollView.frame.size.width * i, 0);
                    _currentContScrollViewOffSizeWidth = _contentScrollView.frame.size.width * i;
                    
                }
                
            }
        }
    }
}
#pragma mark -- menuScrollView动画
//按下headMenuScrollView动画
- (void)headMenuScrollViewPressAnimation
{
    CGFloat width = -1.0;
    if (_currentSeletedButton.center.x > _headMenuScrollView.frame.size.width/2.0 && _currentSeletedButton.center.x < _headMenuScrollView.contentSize.width - _headMenuScrollView.frame.size.width /2.0) {
        width = _currentSeletedButton.center.x  - _headMenuScrollView.frame.size.width/2.0;
    }else if (_currentSeletedButton.center.x <= _headMenuScrollView.frame.size.width/2.0){
        width = 0.0;
    }else if (_currentSeletedButton.center.x >= _headMenuScrollView.contentSize.width - _headMenuScrollView.frame.size.width /2.0){
        width = _headMenuScrollView.contentSize.width - _headMenuScrollView.frame.size.width;
    }
    if (width >= 0) {
        [_headMenuScrollView setContentOffset:CGPointMake(width, 0) animated:YES];
    }
}
//按下contentScrollView动画
- (void)contentScrollViewPressAnimation
{
    if (_currentSeletedHeadScrollViewSubButtonNumberTag == _currentSeletedButton.tag - 1000) {
        return;
    }
    NSInteger i = 0;
    if (_currentSeletedHeadScrollViewSubButtonNumberTag > _currentSeletedButton.tag - 1000) {
        i = 1;
    }else if (_currentSeletedHeadScrollViewSubButtonNumberTag < _currentSeletedButton.tag - 1000){
        i = -1;
    }
    if (_currentSeletedHeadScrollViewSubButtonNumberTag != _currentSeletedButton.tag - 1
        && _currentSeletedHeadScrollViewSubButtonNumberTag != _currentSeletedButton.tag + 1) {
        UIView * view = (UIView *)_contableTableViewArray[_currentSeletedHeadScrollViewSubButtonNumberTag];
        view.center = CGPointMake(_currentContScrollViewOffSizeWidth + (CGFloat)(i + 0.5) * _contentScrollView.frame.size.width  , _contentScrollView.frame.size.height/2.0);
        if (i == 1) {
            [_contentViewRightView removeFromSuperview];
        }else if (i == -1){
            [_contentViewLeftView removeFromSuperview];
        }
        [_contentScrollView addSubview:view];
        
    }
    _currentSeletedButton = (UIButton *)[_headMenuScrollView viewWithTag:_currentSeletedHeadScrollViewSubButtonNumberTag + 1000];
    _refusedHeadSrollViewAnimation = YES;
    
    [_contentScrollView setContentOffset:CGPointMake(_currentContScrollViewOffSizeWidth + i * _contentScrollView.frame.size.width , 0) animated:YES];
}
//左右滑动contenView的动画
- (void)contenViewRightLeftAnimation:(CGFloat)scrollViewContentOffsizeWidth
{
    UIView * view = [_headMenuScrollView viewWithTag:100];
    UIButton * nextButton = nil;
    if (scrollViewContentOffsizeWidth > _currentContScrollViewOffSizeWidth && _currentSeletedButton.tag-1000 < _headMenuDateArray.count - 1) {
        nextButton = (UIButton *)[_headMenuScrollView viewWithTag:_currentSeletedButton.tag + 1];
    }
    else if (scrollViewContentOffsizeWidth < _currentContScrollViewOffSizeWidth && _currentSeletedButton.tag > 1000){
        nextButton = (UIButton *)[_headMenuScrollView viewWithTag:_currentSeletedButton.tag - 1];
    }
    
    if (nextButton) {
        CGFloat offSizeWidth = _currentSeletedButton.center.x + (scrollViewContentOffsizeWidth - _currentContScrollViewOffSizeWidth)/_contentScrollView.frame.size.width * nextButton.frame.size.width;
        CGFloat contentOffSizeWidth = _currentSeletedButton.center.x + (scrollViewContentOffsizeWidth - _currentContScrollViewOffSizeWidth)/_contentScrollView.frame.size.width * nextButton.frame.size.width - _headMenuScrollView.frame.size.width/2.0;
        if (offSizeWidth > _headMenuScrollView.frame.size.width/2.0 ) {
            
            if (contentOffSizeWidth + _headMenuScrollView.frame.size.width > _headMenuScrollView.contentSize.width) {
                _headMenuScrollView.contentOffset = CGPointMake(_headMenuScrollView.contentSize.width - _headMenuScrollView.frame.size.width, 0);
            }else{
                _headMenuScrollView.contentOffset = CGPointMake(contentOffSizeWidth , 0);
            }
        }else{
            _headMenuScrollView.contentOffset = CGPointMake(contentOffSizeWidth + _headMenuScrollView.frame.size.width/2.0 - offSizeWidth, 0);
        }
        view.center = CGPointMake(offSizeWidth , view.center.y);
        
        CGFloat i = fabs((scrollViewContentOffsizeWidth - _currentContScrollViewOffSizeWidth)/_contentScrollView.frame.size.width);
        
        [_currentSeletedButton setTitleColor:RGB(100, 100, 100) forState:UIControlStateSelected];
        [nextButton setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
    }
    
}


#pragma mark -- scrollView协议


//$$$$$$$$$$$$$$$$$$$$$$$$$$开始拖拽时执行
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _contentScrollView) {
        _refusedHeadSrollViewAnimation = NO;
    }
}


//$$$$$$$$$$$$$$$$$$$$$$$$$$   减速停止时执行（后）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_bottomScrollView.contentOffset.y < -_bottomScrollView.contentInset.top) {
        _bottomScrollView.delegate = nil;
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [_bottomScrollView setContentOffset:CGPointMake(0,-_bottomScrollView.contentInset.top)];
        }completion:^(BOOL finished) {
            _bottomScrollView.delegate = self;
        }];
    }
}


//$$$$$$$$$$$$$$$$$$$$$$$$$$$    停止拖拽时执行（先）
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO && _bottomScrollView.contentOffset.y < -_bottomScrollView.contentInset.top) {
        _bottomScrollView.delegate = nil;
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [_bottomScrollView setContentOffset:CGPointMake(0,-_bottomScrollView.contentInset.top)];
        }completion:^(BOOL finished) {
            _bottomScrollView.delegate = self;
        }];
    }
}


//$$$$$$$$$$$$$$$$$$$$$$$$$$$  scrollerView完成切换
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _contentScrollView && scrollView.contentOffset.x != _currentContScrollViewOffSizeWidth) {
        
        //$$$$$$$$$$$$$$$$$$$$$$$$$  异步运行，dispatch_get_main_queue()  与UI相关，运行在主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //$$$$$$$$$$$$$$$$$$$$$$$$$$$$  lock,防止多个线程执行
            @synchronized(scrollView){
                if (_refusedHeadSrollViewAnimation == NO) {
                    [self contenViewRightLeftAnimation:scrollView.contentOffset.x];
                }
                if (scrollView.contentOffset.x >= _currentContScrollViewOffSizeWidth + _contentScrollView.frame.size.width || scrollView.contentOffset.x <= _currentContScrollViewOffSizeWidth - _contentScrollView.frame.size.width ) {
                    _currentSeletedButton.selected = NO;
                    [_currentSeletedButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
                    if (_refusedHeadSrollViewAnimation == NO) {
                        if (scrollView.contentOffset.x > _currentContScrollViewOffSizeWidth && _currentSeletedButton.tag-1000 < _headMenuDateArray.count - 1) {
                            _currentSeletedButton = (UIButton *)[_headMenuScrollView viewWithTag:_currentSeletedButton.tag + 1];
                        }
                        else if (scrollView.contentOffset.x < _currentContScrollViewOffSizeWidth && _currentSeletedButton.tag > 1000){
                            _currentSeletedButton = (UIButton *)[_headMenuScrollView viewWithTag:_currentSeletedButton.tag - 1];
                        }
                    }
                    if (_currentSeletedButton.tag - 1000 > 0 && _currentSeletedButton.tag - 1000 < _headMenuDateArray.count - 1) {
                        [_contentScrollView setContentOffset:CGPointMake(_contentScrollView.frame.size.width , 0)];
                        _currentContScrollViewOffSizeWidth = _contentScrollView.frame.size.width;
                    }else{
                        _currentContScrollViewOffSizeWidth = roundf((scrollView.contentOffset.x/_contentScrollView.frame.size.width)) * _contentScrollView.frame.size.width;
                    }
                    _currentSeletedButton.selected = YES;
                    [_currentSeletedButton setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
                    _currentSeletedHeadScrollViewSubButtonNumberTag = _currentSeletedButton.tag - 1000;
                    [self contentScrollViewArrangementContent];
                }
            }
        });
    }else if (scrollView == self.contentViewCurrentView) {
        //悬浮框
        if (_bottomScrollView.contentOffset.y < self.headScrollView.bounds.size.height || scrollView.contentOffset.y < 0) {
            scrollView.delegate = nil;
            _bottomScrollView.delegate = nil;
            CGPoint contentOffsetPoint = _bottomScrollView.contentOffset;
            contentOffsetPoint.y = contentOffsetPoint.y + (scrollView.contentOffset.y < 0 ? scrollView.contentOffset.y / 2.0: scrollView.contentOffset.y);
            scrollView.contentOffset = CGPointMake(0, 0);
            _bottomScrollView.contentOffset = contentOffsetPoint;
            scrollView.delegate = self;
            _bottomScrollView.delegate = self;
            
        }else if (_bottomScrollView.contentOffset.y > self.headScrollView.bounds.size.height){
            
            _bottomScrollView.delegate = nil;
            _bottomScrollView.contentOffset = CGPointMake(_bottomScrollView.contentOffset.x, self.headScrollView.bounds.size.height);
            _bottomScrollView.delegate = self;
            
        }else{
            CGFloat num = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height;
            
            if (num > 0) {
                
            }
            
        }
        
    }
    
}

//- (void)viewWillAppear:(BOOL)animated{
//
//    self.meVM = [[MeViewModel alloc] init];
//
//
//    [User MyAdminCirlceIntroduceWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
//        NSLog(@"获得加入的圈子列表 : %@",dict);
//        [self.meVM getMyAdminCircleList:[dict valueForKey:@"Data"]];
//    } AFNErrorBlock:^(NSError *error) {
//        NSLog(@"获得失败，加入的圈子");
//    }];
//
//    [User MyCreateCirlceIntroduceWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
//        NSLog(@"获得创建的圈子列表: %@",dict);
//        [self.meVM getMyCreateCircleList:[dict valueForKey:@"Data"]];
//    } AFNErrorBlock:^(NSError *error) {
//        NSLog(@"获得失败，创建的圈子");
//    }];
//
//    [User CardWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
//        NSLog(@"获得收藏的Cards :%@",dict);
//        [self.meVM getMyCardsList:[dict valueForKey:@"Data"]];
//    } AFNErrorBlock:^(NSError *error) {
//        NSLog(@"获得失败，收藏的Cards");
//    }];
//    
//}
//


@end

