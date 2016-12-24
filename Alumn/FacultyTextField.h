//
//  FacultyTextField.h
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/23/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacultyTextField : UITextField
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *TFpickerView;
}

@property (nonatomic,strong) NSDictionary *facultiesAndMajors;
@property (nonatomic,strong) NSArray *facultyArray;
@property (nonatomic,strong) NSArray *majorArray;
@property (nonatomic,strong) NSString *facultyString;
@property (nonatomic,strong) NSString *majorString;

- (void)done;

@end
