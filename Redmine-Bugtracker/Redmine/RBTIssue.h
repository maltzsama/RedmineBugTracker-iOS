//
//  RBTIssue.h
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBTIssue : NSObject{
    NSMutableData *receivedData;
}

- (void)sendIssue;

@end
