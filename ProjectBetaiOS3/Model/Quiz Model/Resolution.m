//
//  Resolution.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Resolution.h"
#import <RestKit/RestKit.h>

#define kIdResolutionKey @"IdResolution"
#define kTotalCorrectAnswersKey @"TotalCorrectAnswers"
#define kTotalWrongAnswersKey @"TotalWrongAnswers"
#define kOwnerKey @"Ownwe"
#define kRelatedQuizKey @"RelatedQuiz"

static RKObjectMapping* mapping;

@implementation Resolution

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idResolution = [coder decodeIntegerForKey:kIdResolutionKey];
        self.totalCorrectAnswers = [coder decodeIntegerForKey:kTotalCorrectAnswersKey];
        self.totalWrongAnswers = [coder decodeIntegerForKey:kTotalWrongAnswersKey];
        self.owner = [coder decodeObjectForKey:kOwnerKey];
        self.relatedQuiz = [coder decodeObjectForKey:kRelatedQuizKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_idResolution forKey:kIdResolutionKey];
    [coder encodeObject:_totalCorrectAnswers forKey:kTotalCorrectAnswersKey];
    [coder encodeObject:_totalWrongAnswers forKey:kTotalWrongAnswersKey];
    [coder encodeObject:_owner forKey:kOwnerKey];
    [coder encodeObject:_relatedQuiz forKey:kRelatedQuizKey];
}

+ (RKMapping *)resolutionMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[Resolution class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idResolution", @"totalCorrectAnswers", @"totalWrongAnswers"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"owner" mapping:[Student studentMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"relatedQuiz" mapping:[QuizTest quizTestMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, total correct answers: %ld, total wrong answers: %ld, owner: %@, related quiz: %@",
            (long)_idResolution, (long)_totalCorrectAnswers, (long)_totalWrongAnswers, _owner, _relatedQuiz];
}

@end
