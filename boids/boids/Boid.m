//
//  Boid.m
//  boids
//
//  Created by Mike Lyman on 9/30/13.
//  Copyright (c) 2013 Mike Lyman. All rights reserved.
//

#import "Boid.h"
#import "boidsViewController.h"
#import "GameConstants.h"
#import "SteeringBehaviorAlignment.h"
#import "SteeringBehaviorCohesion.h"
#import "SteeringBehaviorSeparation.h"


@implementation Boid

- (id)init {
    self = [super init];
    if (self) {
        
//        self.positionVector = GLKVector3Make( 0,
//                                             0,
//                                             -10 );

        self.positionVector = GLKVector3Make( ((float)arc4random() / ARC4RANDOM_MAX * 10) - 2.5,
                                             ((float)arc4random() / ARC4RANDOM_MAX * 10) - 2.5,
                                             -(((float)arc4random() / ARC4RANDOM_MAX * 10) + 5) );

//        self.velocityVector = GLKVector3Make( 2,
//                                             2,
//                                             0);

        
        self.velocityVector = GLKVector3Make( ((float)arc4random() / ARC4RANDOM_MAX * 10) - 1,
                                             ((float)arc4random() / ARC4RANDOM_MAX * 10) - 1,
                                             ((float)arc4random() / ARC4RANDOM_MAX * 10) - 1 );

        
//        self.positionVector = GLKVector3Make( 0, 0, -10 );
//        
//        self.velocityVector = GLKVector3Make( 0, 0, -1.0 );
// ((float)arc4random() / ARC4RANDOM_MAX * 2) - 1
        
        self.upVector = GLKVector3Make( 0.0f, 1.0f, 0.0f);
        self.forwardVector = GLKVector3Normalize( self.positionVector );
        self.sideVector = GLKVector3Make( 0.0f, 0.0f, 0.0f);
        self.speed = 2.0f;
        self.mass = 1.0f;
        
        _worldUpVector = GLKVector3Make( 0.0f, 1.0f, 0.0f );
        
//        SEL mySelector = @selector(alignment::);
        float awarenessRadius = 7.0f;
        float viewConeAngle = 45.0f;
        self.behaviors = [[NSMutableArray alloc] init];
        [self.behaviors addObject:[[SteeringBehaviorSeparation alloc] initWithOwner:self
                                                                            weight:0.5f
                                                                    awarenessRadius:awarenessRadius
                                                                      viewConeAngle:viewConeAngle]];
        
        [self.behaviors addObject:[[SteeringBehaviorAlignment alloc] initWithOwner:self
                                                                            weight:0.5f
                                                                    awarenessRadius:awarenessRadius
                                                                     viewConeAngle:20.0]];
        
        [self.behaviors addObject:[[SteeringBehaviorCohesion alloc] initWithOwner:self
                                                                           weight:1.0f
                                                                   awarenessRadius:awarenessRadius
                                                                    viewConeAngle:viewConeAngle]];
        for (SteeringBehavior *behavior in self.behaviors) {
            // some setup code
        }
        

    }
    return self;
}

- (void)updateWithTime:(NSTimeInterval)dt
      worldFieldOfView:(float)worldFieldOfView
      worldAspectRatio:(float)worldAspectRatio
        worldNearPlane:(float)worldNearPlane
         worldFarPlane:(float)worldFarPlane
{
    
//    temporary!
    float xBound = fabsf( worldAspectRatio * self.positionVector.z ) / 2; // not / 2
    float yBound = fabsf( tanf( GLKMathDegreesToRadians( worldFieldOfView / 2 ) ) * self.positionVector.z ) + kSizeOfBoid; // also not / 2
    float zNearBound = -( worldNearPlane + kSizeOfBoid );
    float zFarBound = -( worldFarPlane - kSizeOfBoid );
    GLKVector3 worldSize = GLKVector3Make(xBound, yBound, 100.0f);
    
//    self.velocityVector = GLKVector3Normalize( self.velocityVector );
//    self.velocityVector = GLKVector3MultiplyScalar( self.velocityVector, self.speed );
    
    GLKVector3 displacementVector = GLKVector3MultiplyScalar(self.velocityVector, dt);
    self.positionVector = GLKVector3Add(self.positionVector, displacementVector);
    
//    screen wrapping
    float newX = self.positionVector.x;
    float newY = self.positionVector.y;
    float newZ = self.positionVector.z;
//    wrap X
    if (self.positionVector.x > worldSize.x) {
        newX = -worldSize.x;
    }
    else if (self.positionVector.x < -worldSize.x) {
        newX = worldSize.x;
    }
//    wrap Y
    if (self.positionVector.y > worldSize.y) {
        newY = -worldSize.y;
    }
    else if (self.positionVector.y < -worldSize.y) {
        newY = worldSize.y;
    }
//    wrap Z
    if (self.positionVector.z > zNearBound) {
        newZ = zFarBound;
    }
    else if (self.positionVector.z < zFarBound) {
        newZ = zNearBound;
    }
    self.positionVector = GLKVector3Make(newX, newY, newZ);
    
    NSLog(@"Position: %f, %f, %f", self.positionVector.x, self.positionVector.y, self.positionVector.z);
    
    // Calculate orientation vectors
    self.forwardVector = GLKVector3Normalize( self.velocityVector );
    self.sideVector = GLKVector3CrossProduct( self.forwardVector, _worldUpVector );
    self.sideVector = GLKVector3Normalize( self.sideVector ); // may be redundant
    self.upVector = GLKVector3CrossProduct( self.sideVector, self.forwardVector );
    self.upVector = GLKVector3Normalize( self.upVector );
    
    // Make the modelView matrix
    self.modelViewMatrix = GLKMatrix4Make(self.forwardVector.x, self.forwardVector.y, self.forwardVector.z, 0,
                                          self.upVector.x, self.upVector.y, self.upVector.z, 0,
                                          self.sideVector.x, self.sideVector.y, self.sideVector.z, 0,
                                          self.positionVector.x, self.positionVector.y, self.positionVector.z, 1);
    
}

- (void)updateSteering:(NSTimeInterval)dt
            otherBoids:(NSMutableArray*)otherBoids {
    GLKVector3 steeringVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
    // Repopulate the neighbor arrays
    for ( SteeringBehavior *behavior in self.behaviors ) {
        
        [behavior.neighbors removeAllObjects];
        
        for ( Boid *otherBoid in otherBoids ) {
            [behavior addNeighbor:otherBoid];
        }
        
        GLKVector3 adjustmentVector = [behavior calculateAdjustmentVector];
        steeringVector = GLKVector3Add( steeringVector, adjustmentVector );
    }
    
    // if the steering vector force is too great scale it down to kMaxSteeringVectorMagnitude
    float steeringVectorMagnitude = GLKVector3Length( steeringVector );
    if ( steeringVectorMagnitude > kMaxSteeringVectorMagnitude ) {
        steeringVector = GLKVector3Normalize( steeringVector );
        steeringVector = GLKVector3MultiplyScalar( steeringVector, kMaxSteeringVectorMagnitude );
    }
    
    steeringVector = GLKVector3MultiplyScalar( steeringVector, self.mass );
    self.velocityVector = GLKVector3Add( steeringVector, self.velocityVector );
    
    // scale the velocity if magnitude greater than speed
    float velocityVectorMagnitude = GLKVector3Length( self.velocityVector );
    if ( velocityVectorMagnitude > self.speed ) {
        self.velocityVector = GLKVector3Normalize( self.velocityVector );
        self.velocityVector = GLKVector3MultiplyScalar( self.velocityVector, self.speed );
    }

}



@end
