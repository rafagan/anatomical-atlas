//
//  TrueOrFalse.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "TrueOrFalse.h"
#import "QuizTest.h"
#import "BoneSet.h"
#import "Teacher.h"

#define kCorrectAnswerKey @"CorrectAnswer"

static RKObjectMapping* mapping;

@implementation TrueOrFalse

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [coder decodeBoolForKey:kCorrectAnswerKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeBool:_correctAnswer forKey:kCorrectAnswerKey];
}

+ (RKObjectMapping *)trueOrFalseMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[TrueOrFalse class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idQuestion", @"publicDomain", @"correctAnswer", @"figure", @"statement"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"quizTests" mapping:[QuizTest quizTestMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"categories" mapping:[BoneSet boneSetMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"authors" mapping:[Teacher teacherMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", [super description],
            [NSString stringWithFormat:
             @"correct answers: %d", _correctAnswer]];
}

@end
