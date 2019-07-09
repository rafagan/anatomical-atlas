//
//  Student.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class Organization;

@interface Student : NSObject <NSCoding>

+ (RKMapping *)studentMapping;

@property (nonatomic) NSInteger idStudent;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) float generalKnowledge;
@property (nonatomic, strong) NSData *photo;
@property (nonatomic, strong) NSString *resume;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *scholarity;

@property (nonatomic, strong) NSArray *myClasses;
@property (nonatomic, strong) NSArray* myResolutions;
@property (nonatomic, strong) Organization* studentOrganization;

@end
