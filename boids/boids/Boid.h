//
//  Boid.h
//  boids
//
//  Created by Mike Lyman on 9/30/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Boid : NSObject {
    
    
}

@property (nonatomic, strong) NSArray *behaviors;

@property (nonatomic, assign) GLKVector3 positionVector;

@property (nonatomic, assign) GLKVector3 velocityVector;

@property (nonatomic, assign) GLKVector3 forwardVector;

@property (nonatomic, assign) GLKVector3 upVector;


- (void)updateWithTime:(NSTimeInterval)dt;



@end
