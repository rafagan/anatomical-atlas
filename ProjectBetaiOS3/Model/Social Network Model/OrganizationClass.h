//
//  OrganizationClass.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Clazz.h"

@class Organization;

@interface OrganizationClass : Clazz

+ (RKObjectMapping *)organizationClassMapping;

@property (nonatomic, strong) Organization* creator;

@end
