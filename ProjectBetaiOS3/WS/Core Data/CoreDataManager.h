//
//  CoreDataHelper.h
//  Unity-iPhone
//
//  Created by Pedro on 3/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define CD_MANAGER [CoreDataManager getInstance]

@interface CoreDataManager : NSObject

@property (nonatomic, strong, getter = managedObjectContext) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, getter = managedObjectModel) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, getter = persistenceStoreCoordinator) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

+(CoreDataManager *)getInstance;

@end
