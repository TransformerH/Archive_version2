//
//  YearTextField.m
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/23/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "YearTextField.h"

@implementation YearTextField{
    UIToolbar *inputAccessoryView;
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    TFpickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 120)];
    TFpickerView.dataSource = self;
    TFpickerView.delegate = self;
    self.inputView = TFpickerView;
    
    //数据初始化
    self.firstYear = self.yearArray[0];
    self.firstYear = self.yearArray[0];
}

- (void)setSelectRow:(NSInteger)index{
    if(index >= 0){
        [TFpickerView selectRow:index inComponent:0 animated:YES];
    }
}

#pragma mark - UIPickerView dataSource, delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.yearArray[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.yearArray.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0)
        self.firstYear = self.yearArray[row];
    else if(component == 1)
        self.lastYear = self.yearArray[row];
}

#pragma mark - inputAccessoryView with toolbar
- (BOOL)canBecomeFirstResponder{
    return YES;
}

//- (void)done:(id)sender{
//
//    self.text = [[NSString alloc] initWithFormat:@"%@   %@",facultyString,majorString];
//
//    [self resignFirstResponder];
//    [super resignFirstResponder];
//}

- (void)done{
    if(self.firstYear.length>0 && self.lastYear.length>0)
        self.text = [[NSString alloc] initWithFormat:@"%@   %@",self.firstYear,self.lastYear];
    
    [self resignFirstResponder];
    [super resignFirstResponder];
    
}

- (UIView*)inputAccessoryView{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return nil;
    }else{
        if(!inputAccessoryView){
            inputAccessoryView = [[UIToolbar alloc] init];
            inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
            inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [inputAccessoryView sizeToFit];
            CGRect frame = inputAccessoryView.frame;
            frame.size.height = 30.0f;
            inputAccessoryView.frame = frame;
            
            //            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            UIBarButtonItem *flexbleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            NSArray *array = [NSArray arrayWithObjects:flexbleSpaceLeft, nil];
            [inputAccessoryView setItems:array];
        }
        
        return inputAccessoryView;
        
    }
}


@end
