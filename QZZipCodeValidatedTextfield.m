//
//  QZValidatedTextfield.m
//  QZValidatedTextfield
//
//  Created by Fernando Olivares on 3/11/13.
//  Copyright (c) 2013 Fernando Olivares. All rights reserved.
//

#import "QZZipCodeValidatedTextfield.h"
#import "NSString+PostalCodeValidation.h"

@interface QZZipCodeValidatedTextfield () <UITextFieldDelegate> {
    id <UITextFieldDelegate> __unsafe_unretained _externalDelegate;
    NSDictionary *_countryCodes;
}

@end

@implementation QZZipCodeValidatedTextfield

@synthesize country = _country;

- (id)initWithFrame:(CGRect)frame
{
    //Check if we could initialize ourselves.
    if (self != [super initWithFrame:frame])
        return nil;
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    //Check if we could initialize ourselves.
    if(self != [super initWithCoder:aDecoder])
        return nil;
    
    [self commonInit];
    
    return self;
}

- (void)awakeFromNib;
{
    //Always call your parents.
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit;
{
    //Set ourselves as delegate.
    self.delegate = self;
    
    //Now, parse the country codes into a dictionary.
    NSMutableDictionary *countryCodes = [NSMutableDictionary dictionary];
    NSBundle *QZBundle = [NSBundle bundleForClass:[self class]];
    NSString *countryCodesList = [QZBundle pathForResource:@"CountryCodes"
                                                    ofType:@"txt"];
    
    //Attempt to read the file.
    NSError *readingError;
    NSString *countryCodesString = [NSString stringWithContentsOfFile:countryCodesList
                                                             encoding:NSUTF8StringEncoding
                                                                error:&readingError];
    
    if(readingError){
        NSLog(@"Could not load country codes.");
        return;
    }
    
    //Now, separate that into an array of smaller strings.
    NSArray *countryCodePairs = [countryCodesString componentsSeparatedByString:@"."];
    
    //This array contains a country code paired with its postal code or postal code form.
    for(NSString *countryCodePair in countryCodePairs){
        NSArray *countryCodePairSeparated = [countryCodePair componentsSeparatedByString:@"\t"];
        
        //Check the length. If it is less than 2, there was an error.
        if(countryCodePairSeparated.count < 2)
            continue;
        
        //Now, set the first part of the array as the key and the second part as the zip code object.
        NSString *countryISOCode = [[countryCodePairSeparated objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *countryPostalCode = [countryCodePairSeparated objectAtIndex:1];
        if(!countryISOCode || !countryPostalCode)
            continue;
        
        [countryCodes setObject:countryPostalCode
                         forKey:countryISOCode];
    }
    
    //Finally, set the country codes from this mutable dictionary.
    _countryCodes = [NSDictionary dictionaryWithDictionary:countryCodes];
    
    //Set our country if the user hasn't already set it.
    if(!self.country)
        self.country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    self.country = @"Hello";
}

#pragma mark Setter
- (void)setDelegate:(id <UITextFieldDelegate>)delegate;
{
    //If we're trying to set ourselves as delegate, go ahead and set us.
    if([delegate isEqual:self]){
        
        //Don't set us again if we're already set.
        if(self.delegate)
            return;
        
        //Set us as the delegate that receives UITextFieldDelegate methods.
        super.delegate = self;
        
        return;
    }
    
    //Someone's trying to set an external delegate. Save it.
    _externalDelegate = delegate;
}

- (id <UITextFieldDelegate>)delegate;
{
    return _externalDelegate;
}

- (void)setCountry:(NSString *)country;
{
    //We couldn't find a valid country for this.
    if(![_countryCodes objectForKey:country] || country.length > 2){
        
        //Default to no validation.
        _country = [NSString stringWithFormat:@"\"%@\" is an invalid country code. Validation disabled.", country];
        return;
    }
    
    _country = [country copy];
    
    //Check if it's a unique postal code.
    NSString *currentPostalCodeFormat = [_countryCodes objectForKey:self.country];
    if([currentPostalCodeFormat isUniquePostalCode]){
        self.text = currentPostalCodeFormat;
        self.enabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
#pragma mark Managing Editing
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    return [_externalDelegate textFieldShouldBeginEditing:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
}

#pragma mark Editing Text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    //This is the interesting part. Let's begin.
    //First, check against which country locale we're matching.
    NSString *postalCodeForCurrentCountry = [_countryCodes objectForKey:self.country];
    if(!postalCodeForCurrentCountry){
        
        //If we don't know the country locale, we don't validate.
        return YES;
    }
    
    //If the postal code returned is "-" then it is a special case. It may have multiple validation types.
    if([postalCodeForCurrentCountry isEqualToString:@"-"]){
        NSLog(@"Special case");
    }
    
    //Some countries only have one postal code (literally).
    if([postalCodeForCurrentCountry isUniquePostalCode]){
        
        //We make sure the textfield's current text is the selected postal code.
        textField.text = postalCodeForCurrentCountry;
        
        //Then we don't want to modify it.
        return NO;
    }
    
    //Finally, if it's not a special case or a unique postal code, parse it.
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return YES;
}

@end
