//
//  MultipleChoice.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "MultipleChoice.h"
#import "QuizTest.h"
#import "BoneSet.h"
#import "Teacher.h"

#define kCorrcetAnswerKey @"CorrectAnswer"
#define kAnswerAKey @"AnswerA"
#define kAnswerBKey @"AnswerB"
#define kAnswerCKey @"AnswerC"
#define kAnswerDKey @"AnswerD"
#define kAnswerEKey @"AnswerE"

static RKObjectMapping* mapping;

@implementation MultipleChoice

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.correctAnswer = [coder decodeObjectForKey:kCorrcetAnswerKey];
        self.answerA = [coder decodeObjectForKey:kAnswerAKey];
        self.answerB = [coder decodeObjectForKey:kAnswerBKey];
        self.answerC = [coder decodeObjectForKey:kAnswerCKey];
        self.answerD = [coder decodeObjectForKey:kAnswerDKey];
        self.answerE = [coder decodeObjectForKey:kAnswerEKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:_correctAnswer forKey:kCorrcetAnswerKey];
    [coder encodeObject:_answerA forKey:kAnswerAKey];
    [coder encodeObject:_answerB forKey:kAnswerBKey];
    [coder encodeObject:_answerC forKey:kAnswerCKey];
    [coder encodeObject:_answerD forKey:kAnswerDKey];
    [coder encodeObject:_answerE forKey:kAnswerEKey];
}

+ (RKObjectMapping *)multipleChoiceMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[MultipleChoice class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idQuestion", @"publicDomain", @"figure", @"correctAnswer", @"statement", @"answerA", @"answerB", @"answerC", @"answerD", @"answerE"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"quizTests" mapping:[QuizTest quizTestMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"categories" mapping:[BoneSet boneSetMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"authors" mapping:[Teacher teacherMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", [super description],
            [NSString stringWithFormat:
             @"correct answers: %@, answer A: %@, answer B: %@, answer C: %@, answer D: %@, answer E: %@", _correctAnswer, _answerA, _answerB, _answerC, _answerD, _answerE]];
}

@end