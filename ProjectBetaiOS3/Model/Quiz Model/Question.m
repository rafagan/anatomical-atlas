//
//  Question.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Question.h"

#define kIdQuestionKey @"IdQuestion"
#define kPublicDomainKey @"PublicDomain"
#define kFigureKey @"Figure"
#define kStatementKey @"Statement"
#define kQuizTestsKey @"QuizTests"
#define kCategoriesKey @"Categories"
#define kAuthorsKey @"AuthorsKey"

@implementation Question

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idQuestion = [coder decodeIntegerForKey:kIdQuestionKey];
        self.publicDomain = [coder decodeBoolForKey:kPublicDomainKey];
        self.figure = [coder decodeObjectForKey:kFigureKey];
        self.statement = [coder decodeObjectForKey:kStatementKey];
        self.quizTests = [coder decodeObjectForKey:kQuizTestsKey];
        self.categories = [coder decodeObjectForKey:kCategoriesKey];
        self.authors = [coder decodeObjectForKey:kAuthorsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger :_idQuestion forKey:kIdQuestionKey];
    [coder encodeBool:_publicDomain forKey:kPublicDomainKey];
    [coder encodeObject:_figure forKey:kFigureKey];
    [coder encodeObject:_statement forKey:kStatementKey];
    [coder encodeObject:_quizTests forKey:kQuizTestsKey];
    [coder encodeObject:_categories forKey:kCategoriesKey];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
             @"id: %ld, public domain: %d, statement: %@, quiz tests: %@, categories: %@, authors: %@",
             (long)_idQuestion, _publicDomain, _statement, _quizTests, _categories, _authors];
}

@end
