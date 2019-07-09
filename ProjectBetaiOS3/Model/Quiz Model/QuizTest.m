//
//  QuizTest.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "QuizTest.h"
#import "Resolution.h"
#import "RestKitDynamicMappings.h"
#import "TrueOrFalse.h"
#import "Teacher.h"

#define kIdQuizTestKey @"IdQuizTest"
#define kDifficultLevelKey @"DifficultLevel"
#define kMaxQuestionsKey @"MaxQuestions"
#define kTitleKey @"Title"
#define kQuestionsKey @"Questions"
#define kAuthorKey @"Author"
#define kResolutionsKey @"Resolutions"

static RKObjectMapping *mapping;

@implementation QuizTest

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idQuizTest = [coder decodeIntegerForKey:kIdQuizTestKey];
        self.difficultLevel = [coder decodeIntegerForKey:kDifficultLevelKey];
        self.maxQuestions = [coder decodeIntegerForKey:kMaxQuestionsKey];
        self.title = [coder decodeObjectForKey:kTitleKey];
        self.questions = [coder decodeObjectForKey:kQuestionsKey];
        self.author = [coder decodeObjectForKey:kAuthorKey];
        self.resolutions = [coder decodeObjectForKey:kResolutionsKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_idQuizTest forKey:kIdQuizTestKey];
    [coder encodeInteger:_difficultLevel forKey:kDifficultLevelKey];
    [coder encodeInteger:_maxQuestions forKey:kMaxQuestionsKey];
    [coder encodeObject:_title forKey:kTitleKey];
    [coder encodeObject:_questions forKey:kQuestionsKey];
    [coder encodeObject:_author forKey:kAuthorKey];
    [coder encodeObject:_resolutions forKey:kResolutionsKey];
}

+ (RKMapping *)quizTestMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[QuizTest class]];
    [mapping addAttributeMappingsFromArray:@[@"idQuizTest", @"difficultLevel", @"maxQuestions", @"title"]];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"questions" mapping:[RestKitDynamicMappings questionDynamicMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"author" mapping:[Teacher teacherMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"resolutions" mapping:[Resolution resolutionMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, difficult level: %ld, max questions: %ld, title: %@, questions: %@, author: %@, resolutions: %@",
            (long)_idQuizTest, (long)_difficultLevel, (long)_maxQuestions, _title, _questions, _author, _resolutions];
}

@end
