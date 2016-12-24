//
//  placeTextField.h
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/23/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface placeTextField : UITextField
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *TFpickerView;
}

@property (nonatomic,strong) NSArray *countrySource;
@property (nonatomic,strong) NSArray *stateSource;
@property (nonatomic,strong) NSArray *citySource;

- (void)done;

@end
