//
//  Resolution.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "QuizTest.h"

@interface Resolution : NSObject <NSCoding>

+ (RKMapping *)resolutionMapping;

@property (nonatomic) NSInteger idResolution;
@property (nonatomic) NSInteger totalCorrectAnswers;
@property (nonatomic) NSInteger totalWrongAnswers;

@property (nonatomic, strong) Student *owner;
@property (nonatomic, strong) QuizTest *relatedQuiz;

@end
