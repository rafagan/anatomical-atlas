//
//  BonePart.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#ifndef ProjectModel_BonePart_h
#define ProjectModel_BonePart_h

#import <RestKit/RestKit.h>
@class Bone;

@interface BonePart : NSObject <NSCoding>

@property (nonatomic) NSInteger idBonePart;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *synonimous;

@property (nonatomic, strong) Bone *parentBone;

+ (RKMapping*)bonePartMapping;

@end

#endif
