//
//  DSCompany.h
//  LocationReport
//
//  Created by Mark Deraeve on 01/04/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "DSBaseObject.h"

@interface DSCompany : DSBaseObject

@property (nonatomic, retain) NSNumber * comp_id;
@property (nonatomic, retain) NSString * name ;
@property (nonatomic, retain) NSString * pwd ;
@property (nonatomic, retain) NSString * code ;
@property (nonatomic, retain) NSDate * valid_date ;
@property (nonatomic, retain) NSDate * created ;
@property (nonatomic, retain) NSString * ftp_pwd ;
@property (nonatomic, retain) NSString * ftp_url ;
@property (nonatomic, retain) NSString * ftp_user ;

@end
