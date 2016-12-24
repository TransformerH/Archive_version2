//
//  YearTextField.h
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/23/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearTextField : UITextField
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *TFpickerView;
}

@property (nonatomic,strong) NSArray *yearArray;
@property (nonatomic,strong) NSString *firstYear;
@property (nonatomic,strong) NSString *lastYear;

- (void)done;

@end
