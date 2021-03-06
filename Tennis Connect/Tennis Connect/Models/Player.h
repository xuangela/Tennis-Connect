//
//  Player.h
//  Tennis Connect
//
//  Created by Angela Xu on 7/17/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Court.h"
@import Parse;


NS_ASSUME_NONNULL_BEGIN

@interface Player : NSObject

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) long age;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFFileObject *pfp;

+ (NSMutableArray *)playersWithPFUserObjects: (NSArray<PFUser *> *)dictionaries;
+ (NSMutableArray<Player*> *)playersWithPFUserFromSet: (NSMutableSet<PFUser *> *)users;

- (id)initWithPFUser:(PFUser *)userPF;

@end

NS_ASSUME_NONNULL_END
