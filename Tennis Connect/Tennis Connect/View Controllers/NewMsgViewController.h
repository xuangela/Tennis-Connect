//
//  NewMsgViewController.h
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface NewMsgViewController : UIViewController

@property (nonatomic, strong) NSMutableSet<PFUser *> *possibleChatsPF;

@end

NS_ASSUME_NONNULL_END
