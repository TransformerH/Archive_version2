//
//  placeTextField.m
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/23/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "placeTextField.h"

@implementation placeTextField{
    UIToolbar *inputAccessoryView;
    
    NSArray *stateTrySource;
    NSArray *cityTrySource;
    NSInteger countryIndex;
    
    NSString *countryName;
    NSString *stateName;
    NSString *cityName;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    TFpickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 120)];
    TFpickerView.dataSource = self;
    TFpickerView.delegate = self;
    self.inputView = TFpickerView;
    
    stateTrySource = self.stateSource[0];
    cityTrySource = self.citySource[0];
    
    countryName = self.countrySource[0];
    stateName = self.stateSource[0][0];
    cityName = self.citySource[0][0];

}

- (void)setSelectRow:(NSInteger)index{
    if(index >= 0){
        [TFpickerView selectRow:index inComponent:0 animated:YES];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger rowN = 0;
    
    if(component == 0)
        rowN = self.countrySource.count;
    else if(component == 1)
        rowN = stateTrySource.count;
    else if(component == 2)
        rowN = cityTrySource.count;
    
    return rowN;
}

#pragma mark Picker Delegate Methods
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *selectString;
    if(component == 0)
        selectString = self.countrySource[row];
    else if(component == 1)
        selectString = stateTrySource[row];
    else if(component == 2)
        selectString = cityTrySource[row];
    
    return selectString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        stateTrySource = self.stateSource[row];
        [TFpickerView reloadComponent:1];
        [TFpickerView selectRow:0 inComponent:1 animated:YES];
        countryIndex = row;
        
        countryName = self.countrySource[row];
        stateName = stateTrySource[0];
    }
    
    if(component == 1){
        NSInteger cityNum = 0;
        for(int i = 0;i < countryIndex;i++){
            NSInteger state = [[self.stateSource objectAtIndex:i] count];
            if(state == 0){
                cityNum += 0;
            }else{
                cityNum += state;
            }
        }
        
        cityTrySource =  self.citySource[cityNum+row];
        [TFpickerView reloadComponent:2];
        [TFpickerView selectRow:0 inComponent:2 animated:YES];
        
        stateName = stateTrySource[row];
        cityName = cityTrySource[0];
    }
    
    if(component == 2)
        cityName = cityTrySource[row];
}

#pragma mark - inputAccessoryView with toolbar
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)done{
    
    NSLog(@"placeTextField-----------------%@   %@   %@",countryName,stateName,cityName);
    
    self.text = [[NSString alloc] initWithFormat:@"%@_%@_%@",countryName,stateName,cityName];
    
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
