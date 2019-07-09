//
//  Teacher.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Teacher : NSObject <NSCoding>

+ (RKMapping *)teacherMapping;

@property (nonatomic) NSInteger idTeacher;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *photo;
@property (nonatomic, strong) NSString *resume;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *scholarity;

@property (nonatomic, strong) NSArray *workingOrganizations;
@property (nonatomic, strong) NSArray *ownerOfOrganizations;
@property (nonatomic, strong) NSArray *ownerOfClasses;
@property (nonatomic, strong) NSArray *monitoratedClasses;
@property (nonatomic, strong) NSArray *myQuizTests;
@property (nonatomic, strong) NSArray *myQuestions;

@end
