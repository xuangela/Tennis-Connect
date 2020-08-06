//
//  NewMsgViewController.m
//  Tennis Connect
//
//  Created by Angela Xu on 8/6/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "NewMsgViewController.h"
#import "Match.h"
#import "PossibleChatCell.h"
#import "Player.h"

@interface NewMsgViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray<Player*> *possibleChats;

@end

@implementation NewMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableSetUp];
    
    [self addMatchReqPlayers];
}

- (void)addMatchReqPlayers {
    PFQuery *query = [Match query];
    [query whereKey:@"confirmed" equalTo:@YES];
    [query whereKey:@"completed" equalTo:@NO];
    [query whereKey:@"sender" equalTo:[PFUser currentUser]];
    [query includeKey:@"receiver"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (Match* match in objects) {
                [self.possibleChatsPF addObject:match.receiver];
            }
        }
        
        PFQuery *query = [Match query];
        [query whereKey:@"confirmed" equalTo:@YES];
        [query whereKey:@"completed" equalTo:@NO];
        [query whereKey:@"receiver" equalTo:[PFUser currentUser]];
        [query includeKey:@"sender"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                for (Match* match in objects) {
                    [self.possibleChatsPF addObject:match.sender];
                }
            }
            
            self.possibleChats = [Player playersWithPFUserFromSet:self.possibleChatsPF];
            
            [self.tableview reloadData];
        }];
    }];
}

#pragma mark - Table Set Up

- (void)tableSetUp {
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PossibleChatCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"PossibleChatCell"];
    
    [cell setPlayer:self.possibleChats[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.possibleChats.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
