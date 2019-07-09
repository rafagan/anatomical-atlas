//
//  QuizTest.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKitBuilder.h"

@class Teacher;

@interface QuizTest : NSObject <NSCoding>

+ (RKMapping *)quizTestMapping;

@property (nonatomic) NSInteger idQuizTest;
@property (nonatomic) NSInteger difficultLevel;
@property (nonatomic) NSInteger maxQuestions;
@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) Teacher *author;
@property (nonatomic, strong) NSArray* resolutions;

@end