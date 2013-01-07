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
    NSData *jsonData;
    NSString *jsonRequest;
}
@property NSString * crash;
@property NSDictionary *stackTrace;
@property NSString *projectId;
@property NSString *traker;
@property NSString *status;
@property NSString *subjectInfo;
@property NSString *server;


/**
 Send Issue to Redmine;
 */
- (void)sendIssuetoRedmine;

@end
