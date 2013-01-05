//
//  RBTViewController.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTViewController.h"
#import "RBTIssue.h"
#import "RKRedmine.h"
#import "RKValue.h"


@interface RBTViewController ()

@end

@implementation RBTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
   	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender{
    RKRedmine *myRedmine = [[RKRedmine alloc] init];
    myRedmine.serverAddress = @"http://192.168.20.18:3000";
    myRedmine.username = @"testuser";
    myRedmine.password = @"testuser";
    [myRedmine login];
    
    NSArray *projects = [myRedmine projects];
    for (RKProject *project in projects) {
        NSLog(@"=> %@", project.name);
        NSLog(@"%@", project.identifier);
    }
    RKProject *myProject = [myRedmine projectForIdentifier:@"bugtrackertap4-ios"];
    
    RKIssue *myNewIssue = [[RKIssue alloc] init];
    myNewIssue.subject = @"My issue's subject";
    myNewIssue.issueDescription = @"This is how I describe an issue";
    RKIssueOptions *newIssueOptions = [myProject newIssueOptions];
    
    myNewIssue.tracker = [[newIssueOptions trackers]objectAtIndex:0];
    myNewIssue.status = [[newIssueOptions statuses]objectAtIndex:0];
    myNewIssue.priority = [[newIssueOptions priorities]objectAtIndex:3];
    myNewIssue.author = [RKValue valueWithName:@"testuser"];
    
    NSLog(@"%@", myNewIssue);
    
    [myProject postNewIssue:myNewIssue];
    
}


- (IBAction)buttonSimplePressed:(id)sender{
    RBTIssue *myIssue = [[RBTIssue alloc]init];

    [myIssue sendIssue];
}

@end
