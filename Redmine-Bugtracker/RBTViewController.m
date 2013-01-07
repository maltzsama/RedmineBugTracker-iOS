//
//  RBTViewController.m
//  Redmine-Bugtracker
//
//  Created by demetrius on 04/01/13.
//  Copyright (c) 2013 demetrius albuquerque. All rights reserved.
//

#import "RBTViewController.h"
#import "RKRedmine.h"
#import "RKValue.h"
#import "RBTIssue.h"

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

- (IBAction)buttonSimplePressed:(id)sender{

    
    NSArray *teste = [[NSArray alloc]init];
    NSLog(@"%@", [teste objectAtIndex:0]);
    
}

@end
