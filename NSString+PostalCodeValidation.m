//
//  NSString+PostalCodeValidation.m
//  QZValidatedTextfield
//
//  Created by Fernando Olivares on 3/11/13.
//  Copyright (c) 2013 Fernando Olivares. All rights reserved.
//

#import "NSString+PostalCodeValidation.h"

@implementation NSString (PostalCodeValidation)

- (BOOL)isUniquePostalCode;
{
    if([self rangeOfString:@"ZZ"].location != NSNotFound ||
       [self rangeOfString:@"1"].location != NSNotFound ||
       [self rangeOfString:@"2"].location != NSNotFound ||
       [self rangeOfString:@"9"].location != NSNotFound)
        return YES;
    
    return NO;
}

@end
