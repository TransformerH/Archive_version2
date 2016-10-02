//
//  PeopleViewController.m
//  PeopleListFinal
//
//  Created by 韩雪滢 on 9/2/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "PeopleViewController.h"
#import "PeopleViewCell.h"
#import "ChooseButton.h"
#import "PeopleVM.h"
#import "HighLevelSearchViewController.h"

#import "PeopleViewModel.h"
#import "User.h"
#import "User+Extension.h"

#import "MeInfoViewModel.h"
#import "MeInfoViewController.h"

#import "TextFieldSender.h"
#import "PersonalSettingVC.h"

#import "PeopleViewModel.h"

static NSString *CellTableIdentifier=@"CellTableIdentifier";
static BOOL isShow = NO;


@interface PeopleViewController ()

@property (copy,nonatomic) NSArray *content;
@property (copy,nonatomic) NSMutableArray *choose;
@property (copy,nonatomic) NSArray *result;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;



@property (strong,nonatomic) UIView *dview;

@property (strong,nonatomic) PeopleVM *peopleVM;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) MeInfoViewModel *meInfoVM;
@property (strong,nonatomic) TextFieldSender *sender;

@property (strong,nonatomic) UISearchController *searController;
@property (strong,nonatomic) UISearchBar *searchBar;

@property (copy,nonatomic) NSMutableArray *searchResult;


@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *barBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    barBackground.backgroundColor = [UIColor colorWithRed:111.0 / 225.0 green:214 / 225.0 blue:157.0 / 225.0 alpha:1.0];
    [self.view addSubview:barBackground];
    
    self.meInfoVM = [MeInfoViewModel getMeInfoVM];
    self.sender = [TextFieldSender getSender];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0];
    
    UIImage *rigthImg = [UIImage imageNamed:@"pickLogo"];
    UIImageView *rightImgView = [[UIImageView alloc] initWithImage:[self OriginImage:rigthImg scaleToSize:CGSizeMake(20, 20)]];
    rightImgView.bounds = CGRectMake(self.rightButton.bounds.origin.x - 10, self.rightButton.bounds.origin.y - 10, 20, 20);
    [self.rightButton addSubview:rightImgView];
   
    UIImage *leftImg = [UIImage imageNamed:@"searchLogo"];
    UIImageView *leftImgView = [[UIImageView alloc] initWithImage:[self OriginImage:leftImg scaleToSize:CGSizeMake(20, 20)]];
    leftImgView.bounds = CGRectMake(0, self.leftButton.frame.origin.y - 10, 20, 20);
    [self.leftButton addSubview:leftImgView];
    [self.leftButton addTarget:self action:@selector(showSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton addTarget:self action:@selector(showDown:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //----------------------------------------------------------  Net
   
        [User peopleListWithParameters:nil SuccessBlock:^(NSDictionary *dict, BOOL success) {
            NSLog(@"获取人脉列表成功");
            [PeopleViewModel peoleListSaveInPlist:[dict valueForKey:@"Data"]];
            self.content = [self.peopleVM getPeople];
            [self.tableView reloadData];
            
            for(int i = 0;i < self.content.count ; i++){
                NSLog(@"peopleList :%@",self.content[i]);
            }
            
        } AFNErrorBlock:^(NSError *error) {
            NSLog(@"获取人脉列表失败");
        }];
      
    //---------------------------------------------------------   tableView
    _tableView=(id)[self.view viewWithTag:1];
    
    _tableView.rowHeight=116;//表示图为单元预留合适的显示空间
    UINib *nib=[UINib nibWithNibName:@"PeopleViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    UIEdgeInsets contentInset=_tableView.contentInset;
    contentInset.top=20;
    [_tableView setContentInset:contentInset];

    
//---------------------------------------------------------   筛选view
    
    _choose =[NSMutableArray arrayWithArray:@[@"NO",@"NO",@"NO"]];
    
    //_naviView.frame.size.height
    _dview = [[UIView alloc] initWithFrame:CGRectMake(0,50, self.view.bounds.size.width, self.view.bounds.size.height- _navigationItem.accessibilityFrame.size.height)];
    [self setDownView];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//改变图片的大小适应image View的大小
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



// table的行数
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"table的行数 %ld",(long)self.content.count);
    
    return self.content.count;
}
//------------------------------------------------  字典转数组

- (NSArray*)dictionaryToArray:(NSDictionary*) dic{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:[dic valueForKey:@"city"]];
    [result addObject:[dic valueForKey:@"class"]];
    [result addObject:[dic valueForKey:@"job"]];
    [result addObject:[dic valueForKey:@"major"]];
    [result addObject:[dic valueForKey:@"name"]];
    return [NSArray arrayWithArray:result];
}

- (PeopleViewCell*)tableView:(UITableView*)tableView
       cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //注册tableCell，创建新的cell，重复利用
    PeopleViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier forIndexPath:indexPath];
    NSDictionary *rowData=[self.content[indexPath.row] valueForKey:@"_source"];
    cell.name=rowData[@"name"];
    cell.major=rowData[@"faculty"];
    cell.classNum = rowData[@"major"];
    cell.job = rowData[@"job"];
    cell.city= rowData[@"city"];
    cell.peopleUrl = rowData[@"icon_url"];
    
    NSLog(@"cell.name %@; cell.major %@; cell.classNum %@;",cell.name,cell.major,cell.classNum);
    
    return cell;
}



- (void)showDown:(id)sender{
    if(!isShow){
        [self.view addSubview:_dview];
        isShow = YES;
    }
    else{
        [_dview removeFromSuperview];
        isShow = NO;
    }
    
}


- (void)setDownView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height / 5)];
    view.backgroundColor = [UIColor whiteColor];
    
    // button groups
    ChooseButton *majorBtn = [[ChooseButton alloc] initWithFrame:CGRectMake(30, 40, 80, 30)];
    majorBtn.backgroundColor = [UIColor lightGrayColor];
    [majorBtn.layer setMasksToBounds:YES];
    [majorBtn.layer setCornerRadius:6.0];
    majorBtn.alpha = 0.5;
    [majorBtn setTitle:@"同院系" forState:UIControlStateNormal];
    majorBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [majorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [majorBtn addTapBlock:^(UIButton *button) {
        if(button.backgroundColor == [UIColor lightGrayColor]){
            [button setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0]];
            button.alpha = 1.0;
            
            _choose[0] = @"YES";
            
            NSLog(@"同院系");
            for(int i=0;i<_choose.count;i++)
            {
                NSLog(@"%@",_choose[i]);
            }
        }else{
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.alpha = 0.5;
            _choose[0] = @"NO";
            
            NSLog(@"同院系");
            for(int i=0;i<_choose.count;i++)
            {
                NSLog(@"%@",_choose[i]);
            }
            
        }
    }];
    
    ChooseButton *yearBtn = [[ChooseButton alloc] initWithFrame:CGRectMake(150, 40, 80, 30)];
    yearBtn.backgroundColor = [UIColor lightGrayColor];
    [yearBtn.layer setMasksToBounds:YES];
    [yearBtn.layer setCornerRadius:6.0];
    yearBtn.alpha = 0.5;
    [yearBtn setTitle:@"同年级" forState:UIControlStateNormal];
    yearBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [yearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [yearBtn addTapBlock:^(UIButton *button) {
        //self.choose[0] = @"YES";
        if(button.backgroundColor == [UIColor lightGrayColor]){
            [button setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0]];
            button.alpha = 1.0;
            
            _choose[1] = @"YES";
            
            NSLog(@"同年级");
            for(int i=0;i<_choose.count;i++)
            {
                NSLog(@"%@",_choose[i]);
            }
            
        }else{
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.alpha = 0.5;
            
            _choose[1] = @"NO";
            
            NSLog(@"同年级");
            for(int i=0;i<_choose.count;i++)
            {
                NSLog(@"%@",_choose[i]);
            }
            
        }
    }];
    
    
    ChooseButton *cityBtn = [[ChooseButton alloc] initWithFrame:CGRectMake(270, 40, 80, 30)];
    cityBtn.backgroundColor = [UIColor lightGrayColor];
    [cityBtn.layer setMasksToBounds:YES];
    [cityBtn.layer setCornerRadius:6.0];
    cityBtn.alpha = 0.5;
    [cityBtn setTitle:@"同城市" forState:UIControlStateNormal];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cityBtn addTapBlock:^(UIButton *button) {
        //self.choose[0] = @"YES";
        if(button.backgroundColor == [UIColor lightGrayColor]){
            [button setBackgroundColor:[UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0]];
            button.alpha = 1.0;
            
            _choose[2] = @"YES";
            
            NSLog(@"同城市");
            for(int i=0;i<_choose.count;i++)
            {
                NSLog(@"%@",_choose[i]);
            }
            
        }else{
            [button setBackgroundColor:[UIColor lightGrayColor]];
            button.alpha = 0.5;
            
            _choose[2] = @"NO";
            
            NSLog(@"同城市");
            for(int i=0;i<_choose.count;i++)
            {
                NSLog(@"%@",_choose[i]);
            }
            
        }
    }];
    
    
    ChooseButton *closeBtn = [[ChooseButton alloc] initWithFrame:CGRectMake(270, view.bounds.size.height - 45, 80, 30)];
    closeBtn.backgroundColor = [UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0];
    [closeBtn.layer setMasksToBounds:YES];
    [closeBtn.layer setCornerRadius:6.0];
    [closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [closeBtn addTapBlock:^(UIButton *button) {
        _result = [_peopleVM matchPeople:[NSArray arrayWithArray:_choose]];
        self.content = [NSArray arrayWithArray:_result];
        //#########################   NSLog 测试新的content
        for(int k = 0 ;k<self.content.count;k++){
            NSLog(@"新的content :%@",self.content[k]);
        }
        
        [self.tableView reloadData];
        
    }];
    
    
    UIButton *superBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, view.bounds.size.height - 45, 80, 30)];
    superBtn.backgroundColor = [UIColor whiteColor];
    [superBtn.layer setMasksToBounds:YES];
    [superBtn.layer setCornerRadius:6.0];
    superBtn.layer.borderWidth = 1.5;
    superBtn.layer.borderColor = [UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0].CGColor;
    [superBtn setTitle:@"高级筛选" forState:UIControlStateNormal];
    superBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [superBtn setTitleColor:[UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [superBtn addTarget:self action:@selector(superChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:majorBtn];
    [view addSubview:yearBtn];
    [view addSubview:cityBtn];
    [view addSubview:closeBtn];
    [view addSubview:superBtn];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = CGRectMake(0, 0, _dview.bounds.size.width, (_dview.bounds.size.height - view.bounds.size.height));
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, maskRect);
    
    [maskLayer setPath:path];
    CGPathRelease(path);
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0,view.bounds.size.height, _dview.bounds.size.width,_dview.bounds.size.height - view.bounds.size.height)];
    maskView.layer.mask = maskLayer;
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [_dview addSubview:maskView];
    [_dview addSubview:view];
    
}

- (void)superChoose:(id)sender{
    HighLevelSearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"highLevel"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickBtn:(UIButton*)btn{
    btn.backgroundColor = [UIColor colorWithRed:84 / 255.0 green:211 / 255.0 blue:139 / 255.0 alpha:1.0];
    if([btn.currentTitle isEqualToString:@"同院系"]){
        self.choose[0] = @"YES";
    }else if([btn.currentTitle isEqualToString:@"同年级"]){
        self.choose[1] = @"YES";
    }else if([btn.currentTitle isEqualToString:@"同城市"]){
        self.choose[2] = @"YES";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.content[indexPath.row];
    
    NSDictionary *personalRequest = [[NSDictionary alloc] initWithObjectsAndKeys:[User getXrsf],@"_xsrf",[dict valueForKey:@"_id"],@"uid", nil];
    
    [User getPersonalInfo:personalRequest SuccessBlock:^(NSDictionary *dict, BOOL success) {
        
        NSLog(@"获得的具体的人脉详情 %@",dict);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath1= [paths objectAtIndex:0];
        
        NSLog(@"%@",plistPath1);
        //得到完整的路径名
        NSString *fileName = [plistPath1 stringByAppendingPathComponent:@"personalDetailInfoSecond.plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm createFileAtPath:fileName contents:nil attributes:nil] ==YES) {
            
            [[dict valueForKey:@"Data"] writeToFile:fileName atomically:YES];
            NSLog(@"personalDetailInfoSecond.plist文件写入完成");
        }

        
        [self.meInfoVM setIfFollowed:[[[dict valueForKey:@"Data"] valueForKey:@"response"]valueForKey:@"has_followed"]];
        
        
        
        [self.meInfoVM setInfo:self.content[indexPath.row]];
        NSString *fileName2 = [plistPath1 stringByAppendingPathComponent:@"personalDetailInfoFirst.plist"];
        NSFileManager *fm2 = [NSFileManager defaultManager];
        if ([fm2 createFileAtPath:fileName2 contents:nil attributes:nil] ==YES) {
            
            [self.content[indexPath.row]  writeToFile:fileName2 atomically:YES];
            NSLog(@"personalDetailInfoFirst.plist文件写入完成");
        }

        
        MeInfoViewController *meInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"meInfo"];
        [self.navigationController pushViewController:meInfoVC animated:YES];
        
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"获得某个人脉详情失败，此处应加一个弹窗显示");
    }];
    
   
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.peopleVM = [[PeopleVM alloc] init];
    
    if([PeopleViewModel highSearchFromPlist] != nil ){
        self.content = [self.peopleVM reGetPeople];
    }else{
        self.content = [PeopleViewModel peopleArrayFromPlist];
    }
    
    [self.tableView reloadData];
}



- (void)showSearchBar:(id)sender{
    PersonalSettingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"uncertainSearch"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    MeInfoViewController *meVC = segue.destinationViewController;
}
*/

@end
