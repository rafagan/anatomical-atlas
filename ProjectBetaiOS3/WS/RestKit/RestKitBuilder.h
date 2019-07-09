//
//  RestKitBuilder.h
//  ProjectModel
//
//  Created by Rafagan Abreu on 26/11/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#ifndef ProjectModel_RestKitBuilder_h
#define ProjectModel_RestKitBuilder_h

#import <RestKit/RestKit.h>

@interface RestKitBuilder: NSObject
{
    RKObjectManager *objectManager;
}

@property (nonatomic,strong) AFHTTPClient* client;
@property (nonatomic,strong) NSURL* baseURL;

+ (void)sendRequestAtPath:(NSString*)path withQueryParameters:(NSDictionary*)params
        andCallForSuccess:(void (^)(RKObjectRequestOperation *, RKMappingResult *))successDelegate
            andForFailure:(void (^)(RKObjectRequestOperation *, NSError *))failDelegate;

@end

#endif
