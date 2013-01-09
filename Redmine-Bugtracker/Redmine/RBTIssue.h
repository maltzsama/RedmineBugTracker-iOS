/**
  RBTIssue.h
  Redmine-Bugtracker
  @author demetrius albuquerque<demetrius.albuquerque@yahoo.com.br>
  @date 04/01/13.
*/

#import <Foundation/Foundation.h>

@interface RBTIssue : NSObject{
    NSMutableData *receivedData;
    NSData *jsonData;
    NSString *jsonRequest;
}
/** Crash information get from CKCrashReporter*/
@property NSDictionary * crash;
/** Redmine Project identification - This is a string */
@property NSString *projectId;
/** Priority information of bug. */
@property NSString *priority;
/** Status of bug. */
@property NSString *status;
/** Subject of bug. */
@property NSString *subjectInfo;
/** Server address of redmine. */
@property NSString *server;
/** User name. */
@property NSString *userName;
/** Passwd of user. */
@property NSString *passwd;
//** Set connection timeout*/
@property NSInteger timeout;

/** sending information of about issue to redmine. */
- (void)sendIssuetoRedmine;

@end
