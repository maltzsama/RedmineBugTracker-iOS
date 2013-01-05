//
//  RBTIssue.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTIssue.h"

@implementation RBTIssue

- (void)sendIssue{
    
    [UIDevice currentDevice];
    
    NSMutableDictionary *customInfo = [NSMutableDictionary dictionaryWithObject:[[UIDevice currentDevice]systemVersion] forKey:@"SystemVersion"];
    [customInfo setObject:[[UIDevice currentDevice] description] forKey:@"local"];
    
    NSArray *objects = [NSArray arrayWithObjects:@"bugtrackertap4-ios", @"Objddddd2", customInfo, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"project_id", @"subject", @"custom_field_values", nil];
    
    NSDictionary *descDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSDictionary *issueDict = [NSDictionary dictionaryWithObject:descDict forKey:@"issue"];
    
    //NSLog(@"%@", issueDict);
    
    //NSLog(@"%d",[NSJSONSerialization isValidJSONObject:issueDict]);
    
    //NSDictionary *jsonDict = [NSDictionary dictionaryWithObject:questionDict forKey:@"question"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:issueDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
    NSString *jsonRequest = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURL *redmineURL = [NSURL URLWithString:@"192.168.20.18:3000"];
    NSString *redmineUser = @"testuser";
    NSString *redminePass = @"testuser";
    NSString *redmineProjectIdentifier = @"bugtrackertap4-ios";
    //NSLog(@"%@", [redmineURL scheme]);
    //NSLog(@"%@", [redmineURL host]);
    //NSLog(@"%@",[redmineURL relativePath]);
    
    
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%@@%@%@/projects/%@/1.json",[redmineURL scheme],redmineUser,redminePass,[redmineURL host],[redmineURL relativePath],redmineProjectIdentifier]];
    
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];

	[request setValue:@"text/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];

    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [NSMutableData data];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"deu merda %@", error);
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Nao deu merda");
    //[connection release];
    //do something with the json that comes back ... (the fun part)
}

- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount] > 1)
    {
        //[urlConnection release];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                                        message:@"Too many unsuccessul login attempts."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        // Answer the challenge
        NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:@"testuser" password:@"testuser"
                                                           persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}

@end
