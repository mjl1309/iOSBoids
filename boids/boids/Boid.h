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
    GLKVector3 _worldUpVector;
    
}

@property (nonatomic, assign) float speed;

@property (nonatomic, strong) NSMutableArray *behaviors;

@property (nonatomic, assign) GLKVector3 positionVector;

@property (nonatomic, assign) GLKVector3 velocityVector;

@property (nonatomic, assign) GLKVector3 forwardVector;

@property (nonatomic, assign) GLKVector3 upVector;

@property (nonatomic, assign) GLKVector3 sideVector;

@property (nonatomic, assign) GLKMatrix4 modelViewMatrix;

@property (nonatomic, assign) float mass;


- (void)updateWithTime:(NSTimeInterval)dt
      worldFieldOfView:(float)worldFieldOfView
      worldAspectRatio:(float)worldAspectRation
        worldNearPlane:(float)worldnearPlane
         worldFarPlane:(float)worldFarPlane;

- (void)updateSteering:(NSTimeInterval)dt
            otherBoids:(NSMutableArray*)otherBoids;



@end
