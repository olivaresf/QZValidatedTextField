//
//  QZValidatedTextfield.h
//  QZValidatedTextfield
//
//  Created by Fernando Olivares on 3/11/13.
//  Copyright (c) 2013 Fernando Olivares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZZipCodeValidatedTextfield : UITextField

/** The two-letter country code for the country in the current device. See http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 for a list of ISO Country Codes. Note that not all countries with an ISO code have a postal code. In cases where there is no postal code, validation defaults to none.
 
    There are, however, some postal codes which do not have an ISO country code. The following are also valid 2-letter strings for this purpose:
 
    AB - British Antarctic Territory
 */
@property (nonatomic, copy) NSString *country;

@end