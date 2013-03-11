//
//  ViewController.m
//  QZValidatedTextfield
//
//  Created by Fernando Olivares on 3/11/13.
//  Copyright (c) 2013 Fernando Olivares. All rights reserved.
//

#import "ViewController.h"
#import "QZZipCodeValidatedTextfield.h"

@interface ViewController (){
    IBOutlet QZZipCodeValidatedTextfield *_zipCode;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(QZZipCodeValidatedTextfield *)textField;
{
    return YES;
}

@end
