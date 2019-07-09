//
//  QuizTestDTO.m
//  Unity-iPhone
//
//  Created by Pedro on 3/7/15.
//
//

#import "QuizTestDTO.h"


@implementation QuizTestDTO

static RKObjectMapping* mapping;

+ (RKMapping *)quizTestMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[QuizTestDTO class]];
    [mapping addAttributeMappingsFromArray:@[@"idQuizTest", @"difficultLevel", @"maxQuestions", @"title", @"categories"]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, difficult level: %ld, max questions: %ld, title: %@, categories: %@",
            (long)_idQuizTest, (long)_difficultLevel, (long)_maxQuestions, _title, _categories];
}


@end
