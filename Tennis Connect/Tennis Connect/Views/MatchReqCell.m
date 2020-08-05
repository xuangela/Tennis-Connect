//
//  MatchReqCell.m
//  Tennis Connect
//
//  Created by Angela Xu on 7/22/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MatchReqCell.h"

@implementation MatchReqCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.confirmButton.alpha = 0;
    [self buttonSetup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)buttonSetup {
    
    MDCContainerScheme *containerScheme = [[MDCContainerScheme alloc] init];
    containerScheme.colorScheme.primaryColor = [[UIColor alloc] initWithRed:246.0/255.0 green:106.0/255.0 blue:172.0/255.0 alpha:1];
    
    [self.confirmButton applyTextThemeWithScheme:containerScheme];
    
    UIFont *font = [UIFont fontWithName:@"AppleSDGothicNeo-UltraLight " size:15];
    [self.confirmButton.titleLabel setFont:font];
    self.confirmButton.titleLabel.text = @"Confirm";
}

- (void) setMatch:(Match *)match {
    _match = match;
    
    PFUser *opponent;
     if ([match.receiver.objectId isEqualToString:[PFUser currentUser].objectId]) {
         opponent = match.sender;
         self.statusLabel.text = @"Incoming request";
         self.confirmButton.alpha = 1;
     } else {
         opponent = match.receiver;
         self.statusLabel.text = @"Outgoing request";
     }
    
    self.contactLabel.text = [opponent valueForKey:@"contact"];
    
    int exp = [[opponent valueForKey:@"rating"] intValue];
    NSString *rating =[NSString stringWithFormat: @"%d", exp];
    
    if (exp <= 500) {
        rating = [rating stringByAppendingString:@"   beginner"];
    } else if (exp <= 1000) {
        rating = [rating stringByAppendingString:@"   intermediate"];
    } else {
        rating = [rating stringByAppendingString:@"   experienced"];
    }
    
    self.expLabel.text = rating;
    
    self.nameLabel.text = [opponent valueForKey:@"name"];
    
    if ([opponent valueForKey:@"picture"]) {
        self.pfpView.file = [opponent valueForKey:@"picture"];
        [self.pfpView loadInBackground];
    }

    if (match.confirmed) {
        self.statusLabel.text = @"Upcoming match";
        self.confirmButton.alpha = 0;
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (IBAction)tapConfirm:(id)sender {
    self.statusLabel.text =@"Upcoming match";
    self.match.confirmed = YES;
    self.confirmButton.alpha = 0;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    PFQuery *query = [Match query];
    
    [query getObjectInBackgroundWithId:self.match.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        object[@"confirmed"] = @YES;
        [object saveInBackground];
        
    }];
}

@end
