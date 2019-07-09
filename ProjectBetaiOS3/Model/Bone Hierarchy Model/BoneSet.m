//
//  BoneSet.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoneSet.h"
#import "Bone.h"
#import "RestKitDynamicMappings.h"
#import "TrueOrFalse.h"

//Keys para coding
#define kIdBoneSetKey @"IdBoneSet"
#define kCategoryKey @"Category"
#define kDescriptKey @"Descript"
#define kSynonimousKey @"Synonimous"
#define kTotalBonesKey @"TotaBones"
#define kBoneChildrenKey @"BoneChildren"
#define kBoneSetChildrenKey @"BoneSetChildren"
#define kParentBoneSetKey @"ParentBoneSet"
#define kRelatedQuestionsKey @"RelatedQuestions"

static RKObjectMapping *mapping;

@implementation BoneSet

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idBoneSet = [coder decodeIntegerForKey:kIdBoneSetKey];
        self.category = [coder decodeObjectForKey:kCategoryKey];
        self.descript = [coder decodeObjectForKey:kDescriptKey];
        self.synonimous = [coder decodeObjectForKey:kSynonimousKey];
        self.totalBones = [coder decodeIntegerForKey:kTotalBonesKey];
        self.boneChildren = [coder decodeObjectForKey:kBoneChildrenKey];
        self.boneSetChildren = [coder decodeObjectForKey:kBoneSetChildrenKey];
        self.parentBoneSet = [coder decodeObjectForKey:kParentBoneSetKey];
        self.relatedQuestions = [coder decodeObjectForKey:kRelatedQuestionsKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_idBoneSet forKey:kIdBoneSetKey];
    [coder encodeObject:_category forKey:kCategoryKey];
    [coder encodeObject:_descript forKey:kDescriptKey];
    [coder encodeObject:_synonimous forKey:kSynonimousKey];
    [coder encodeInteger:_totalBones forKey:kTotalBonesKey];
    [coder encodeObject:_boneChildren forKey:kBoneChildrenKey];
    [coder encodeObject:_boneSetChildren forKey:kBoneSetChildrenKey];
    [coder encodeObject:_parentBoneSet forKey:kParentBoneSetKey];
    [coder encodeObject:_relatedQuestions forKey:kRelatedQuestionsKey];
}

+ (RKMapping *)boneSetMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[BoneSet class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idBoneSet", @"category", @"totalBones", @"synonimous"]];
    [mapping addAttributeMappingsFromDictionary:@{@"description" : @"descript"}];
    [mapping addRelationshipMappingWithSourceKeyPath:@"boneChildren" mapping:[Bone boneMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"parentBoneSet" mapping:mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"boneSetChildren" mapping:mapping];
    [mapping addRelationshipMappingWithSourceKeyPath:@"relatedQuestions" mapping:[TrueOrFalse trueOrFalseMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, category: %@, description: %@, synonimous: %@, bones: %ld, bone children: %@, bone set children: %@, parent bone set: %@, related questions: %@",
            (long)_idBoneSet, _category, _descript, _synonimous, (long)_totalBones, _boneChildren, _boneSetChildren, _parentBoneSet, _relatedQuestions];
}

@end