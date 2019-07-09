//
//  Question.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject <NSCoding>

@property (nonatomic) NSInteger idQuestion;
@property (nonatomic) BOOL publicDomain;
@property (nonatomic, strong) NSData* figure;
@property (nonatomic, strong) NSString *statement;

@property (nonatomic, strong) NSArray *quizTests;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *authors;

@end
