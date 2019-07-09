//
//  Organization.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Teacher;
@class RKMapping;

@interface Organization : NSObject <NSCoding>

+ (RKMapping *)organizationMapping;

@property (nonatomic) NSInteger idOrganization;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *acronym;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) NSArray *teachers;
@property (nonatomic, strong) Teacher *owner;
@property (nonatomic, strong) NSArray *ownerOfClasses;
@property (nonatomic, strong) NSArray *students;

@end
