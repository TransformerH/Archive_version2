//
//  RegisterThreeVC.m
//  RegisterDemoTwo
//
//  Created by 韩雪滢 on 8/29/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "RegisterThreeVC.h"
//#import "ReactiveCocoa/ReactiveCocoa.h"
#import "RegisterViewModel.h"
#import "RegisterFourVC.h"
#import "RegisterFiveVC.h"
#import "EnrollYearTextField.h"
#import "TextSender.h"
#import "FacultyAndMajorText.h"
#import "RegisterTwoVC.h"

#import "User.h"
#import "User+Extension.h"

#define facultyIs 0
#define majorIs 1
#define enrollYear 2


@interface RegisterThreeVC()
//@property (strong,nonatomic) RegisterVM *vm;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIPickerView *majorPicker;

@property (strong,nonatomic) UITextView *facultyText;
@property (strong,nonatomic) UITextView *majorText;
@property (strong,nonatomic) UITextView *enrollYearText;

@property (strong,nonatomic) UIButton *inSchoolBtn;
@property (strong,nonatomic) UIButton *inJobBtn;

@property (strong,nonatomic) RegisterViewModel *registerVM;
@property (strong,nonatomic) TextSender *sender;
@property (strong,nonatomic) RegisterTwoVC *registerTwoVC;

@property (strong,nonatomic) User *user;

@property (nonatomic,strong) NSArray *facultyArray;
@property (nonatomic,strong) NSArray *majorArray;
@property (nonatomic,strong) NSArray *yearArray;
@property (nonatomic,strong) NSDictionary *facultiesAndMajors;


@end

@implementation RegisterThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"majorList" ofType:@"plist"];
    self.facultiesAndMajors = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.facultyArray = [[NSArray alloc] initWithArray:[self.facultiesAndMajors allKeys]];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for(int i = 1905;i < 2017;i++){
        [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.yearArray = [[NSArray alloc] initWithArray:tempArray];
    
    
    self.majorArray = @[@""];

    
    self.registerTwoVC = [[RegisterTwoVC alloc] init];
    
    isViewWillLoad = YES;
    
    //-------------------------------------------- 设置User
    self.user = [User getUser];
    
    self.registerVM = [RegisterViewModel getRegisterVM];
    self.sender = [TextSender getSender];
    //-------------------------------------------- 设置 faculty 数据
    //    [self.sender SetIsFaculty:YES];
    
    
    //---------------------------------------------   设置navigationBar透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    //----------------------------------------------  设置navigationBar透明
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[self OriginImage:[UIImage imageNamed:@"bgImage"] scaleToSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)]];
    
    
    self.facultyText = [[UITextView alloc] initWithFrame:CGRectMake(0,8,self.inputView.frame.size.width / 2.2, 40)];
    self.facultyText.backgroundColor = [UIColor whiteColor];
    self.facultyText.alpha = 0.8;
    self.facultyText.layer.masksToBounds = YES;
    self.facultyText.layer.cornerRadius = 6.0;
    self.facultyText.text = @"请选择您的院系";
    self.facultyText.editable = NO;
    
    
    self.majorText = [[UITextView alloc] initWithFrame:CGRectMake((self.inputView.frame.size.width - self.inputView.frame.size.width / 2.2),8,self.inputView.frame.size.width / 2.2, 40)];
    self.majorText.backgroundColor = [UIColor whiteColor];
    self.majorText.alpha = 0.8;
    self.majorText.layer.masksToBounds = YES;
    self.majorText.layer.cornerRadius = 6.0;
    self.majorText.text = @"请选择您的专业";
    self.majorText.editable = NO;
    
    
    self.enrollYearText = [[UITextView alloc] initWithFrame:CGRectMake(0, 54,self.inputView.frame.size.width, 40)];
    self.enrollYearText.backgroundColor = [UIColor whiteColor];
    self.enrollYearText.alpha = 0.8;
    self.enrollYearText.text = @"请输入您的入学年份";
    self.enrollYearText.layer.masksToBounds = YES;
    self.enrollYearText.layer.cornerRadius = 6.0;
    self.enrollYearText.editable = NO;
    
    
    self.inSchoolBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, self.inputView.frame.size.width, 40)];
    self.inSchoolBtn.backgroundColor = [UIColor colorWithRed:89/255.0 green:209/255.0 blue:141/255.0 alpha:1.0];
    [self.inSchoolBtn setTitle:@"我是在校生" forState:UIControlStateNormal];
    self.inSchoolBtn.layer.masksToBounds = YES;
    self.inSchoolBtn.layer.cornerRadius = 6.0;
    [self.inSchoolBtn addTarget:self action:@selector(inSchoolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.inJobBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 186, self.inputView.frame.size.width, 40)];
    self.inJobBtn.backgroundColor = [UIColor colorWithRed:89/255.0 green:209/255.0 blue:141/255.0 alpha:1.0];
    [self.inJobBtn setTitle:@"我已工作" forState:UIControlStateNormal];
    self.inJobBtn.layer.masksToBounds = YES;
    self.inJobBtn.layer.cornerRadius = 6.0;
    [self.inJobBtn addTarget:self action:@selector(inJobBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.inputView addSubview:self.facultyText];
    [self.inputView addSubview:self.majorText];
    [self.inputView addSubview:self.enrollYearText];
    [self.inputView addSubview:self.inSchoolBtn];
    [self.inputView addSubview:self.inJobBtn];
    
}


- (void)inSchoolBtnClick:(id)sender{
    self.registerVM.user.company = @"The SEU";
    self.registerVM.user.job = @"student";
    self.registerVM.user.country = @"中国";
    self.registerVM.user.state = @"江苏";
    self.registerVM.user.city = @"南京";
    
    self.registerVM.user.faculty = self.facultyText.text;
    self.registerVM.user.major = self.majorText.text;
    self.registerVM.user.admission_year = [self.enrollYearText.text integerValue];
    
    RegisterFiveVC *registerFive = [self.storyboard instantiateViewControllerWithIdentifier:@"registerFive"];
    [self.navigationController pushViewController:registerFive animated:YES];
}

- (void)inJobBtnClick:(id)sender{
    NSLog(@"有没有执行？？？");
    
    self.registerVM.user.faculty = self.facultyText.text;
    self.registerVM.user.major = self.majorText.text;
    self.registerVM.user.admission_year = [self.enrollYearText.text integerValue];
    
    RegisterFourVC *registerFour = [self.storyboard instantiateViewControllerWithIdentifier:@"registerFour"];
    [self.navigationController pushViewController:registerFour animated:YES];
}

- (IBAction)choose:(id)sender {
    
    NSInteger facultyRow = [self.majorPicker selectedRowInComponent:facultyIs];
    NSInteger majorRow = [self.majorPicker selectedRowInComponent:majorIs];
    NSInteger yearRow = [self.majorPicker selectedRowInComponent:enrollYear];
    
    NSString *selectFaculty = self.facultyArray[facultyRow];
    NSString *selectMajor = self.majorArray[majorRow];
    NSString *selectYear = self.yearArray[yearRow];
    
    self.facultyText.text = selectFaculty;
    self.majorText.text = selectMajor;
    self.enrollYearText.text = selectYear;
    
    self.majorArray = @[@""];
}

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

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger count=0;
    
    switch(component){
        case facultyIs:
            count = self.facultyArray.count;
            break;
        case majorIs:
            count = self.majorArray.count;
            break;
        case enrollYear:
            count = self.yearArray.count;
            break;
    }
    
    return count;
}

#pragma mark Picker Delegate Methods

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *rowString = @"";
    
    switch(component){
        case facultyIs:
            rowString = self.facultyArray[row];;
            break;
        case majorIs:
            rowString = self.majorArray[row];
            break;
        case enrollYear:
            rowString = self.yearArray[row];
    }
   
    return rowString;
   
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == facultyIs){
        self.majorArray = [[NSArray alloc] initWithArray:[self.facultiesAndMajors valueForKey:self.facultyArray[row]]];
        [self.majorPicker reloadComponent:majorIs];
        [self.majorPicker selectRow:0 inComponent:majorIs animated:YES];
    }
}



@end
