//
//  BonePart.m
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BonePart.h"
#import "Bone.h"

#define kIdBonePartKey @"IdBonePart"
#define kDescriptKey @"Descript"
#define kNameKey @"Name"
#define kSynonymousKey @"Synonymous"
#define kParentBoneKey @"ParentBone"

static RKObjectMapping *mapping;

@implementation BonePart

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.idBonePart = [coder decodeIntegerForKey:kIdBonePartKey];
        self.descript = [coder decodeObjectForKey:kDescriptKey];
        self.name = [coder decodeObjectForKey:kNameKey];
        self.synonimous = [coder decodeObjectForKey:kSynonymousKey];
        self.parentBone = [coder decodeObjectForKey:kParentBoneKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeInteger:_idBonePart forKey:kIdBonePartKey];
    [coder encodeObject:_descript forKey:kDescriptKey];
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeObject:_synonimous forKey:kSynonymousKey];
    [coder encodeObject:_parentBone forKey:kParentBoneKey];
}

+ (RKMapping *)bonePartMapping
{
    if(mapping) return mapping;
    
    mapping = [RKObjectMapping mappingForClass:[BonePart class]];
    
    [mapping addAttributeMappingsFromArray:@[@"idBonePart", @"name", @"synonimous"]];
    [mapping addAttributeMappingsFromDictionary:@{@"description": @"descript"}];
    [mapping addRelationshipMappingWithSourceKeyPath:@"parentBone" mapping:[Bone boneMapping]];
    
    return mapping;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"id: %ld, name: %@, description: %@, synonimous: %@, parent bone: %@",
            (long)_idBonePart, _name, _descript, _synonimous, _parentBone];
}

@end