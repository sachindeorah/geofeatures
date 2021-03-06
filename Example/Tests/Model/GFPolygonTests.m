/*
*   GFPolygonTests.m
*
*   Copyright 2015 Tony Stone
*
*   Licensed under the Apache License, Version 2.0 (the "License");
*   you may not use this file except in compliance with the License.
*   You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
*   Unless required by applicable law or agreed to in writing, software
*   distributed under the License is distributed on an "AS IS" BASIS,
*   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*   See the License for the specific language governing permissions and
*   limitations under the License.
*
*   Created by Tony Stone on 04/14/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

static NSDictionary * geoJSON1;
static NSDictionary * geoJSON2;
static NSDictionary * invalidGeoJSON;

//
// Static constructor
//
static __attribute__((constructor(101),used,visibility("internal"))) void staticConstructor (void) {
    geoJSON1       = @{@"type": @"Polygon",
                      @"coordinates": @[
                        @[ @[@(100.0), @(0.0)], @[@(200.0), @(100.0)],@[@(200.0), @(0.0)], @[@(100.0), @(1.0)], @[@(100.0), @(0.0)] ],
                        @[ @[@(100.2), @(0.2)], @[@(100.8), @(0.2)],  @[@(100.8), @(0.8)], @[@(100.2), @(0.8)], @[@(100.2), @(0.2)] ]
                        ]
                    };
    geoJSON2       = @{@"type": @"Polygon",
                         @"coordinates": @[
                            @[ @[@(98.0), @(0.0)], @[@(101.0), @(1.0)],@[@(101.0), @(0.0)], @[@(98.0), @(1.0)], @[@(98.0), @(0.0)] ]
                        ]
                    };
    invalidGeoJSON = @{@"type": @"Polygon", @"coordinates": @{}};
}

@interface GFPolygonTests : XCTestCase
@end


@implementation GFPolygonTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFPolygon alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFPolygon alloc] init]);
    }

    - (void) testInit {
        XCTAssertEqualObjects([[[GFPolygon alloc] init] toWKTString], @"POLYGON(())");
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void)testInitWithGeoJSONGeometry_WithValidGeoJSONGeometry  {
        XCTAssertEqualObjects([[[GFPolygon alloc] initWithGeoJSONGeometry: geoJSON1] toWKTString], @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))");
    }

    - (void)testInitWithGeoJSONGeometry_WithInvalidGeoJSONGeometry  {
        XCTAssertThrowsSpecificNamed([[GFPolygon alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void) testInitWIthWKT_WithValidWKT {
        XCTAssertEqualObjects([[[GFPolygon alloc] initWithWKT: @"POLYGON((98 0,101 1,101 0,98 1,98 0))"] toWKTString],@"POLYGON((98 0,101 1,101 0,98 1,98 0))");
    }

    - (void)testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFPolygon alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFPolygon alloc] initWithWKT: @"POLYGON((98 0,101 1,101 0,98 1,98 0))"] copy] toWKTString], @"POLYGON((98 0,101 1,101 0,98 1,98 0))");
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFPolygon alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test description

    - (void) testDescription_WithGeoJSON1 {
        XCTAssertEqualObjects([[[GFPolygon alloc] initWithGeoJSONGeometry: geoJSON1] description], @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))");
    }

    - (void) testDescription_WithGeoJSON2 {
        XCTAssertEqualObjects([[[GFPolygon alloc] initWithGeoJSONGeometry: geoJSON2] description], @"POLYGON((98 0,101 1,101 0,98 1,98 0))");
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [[[GFPolygon alloc] initWithGeoJSONGeometry: geoJSON1]  mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolygon class]]);
        
        MKPolygon * polygon = (MKPolygon *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([polygon pointCount] == 5);
        XCTAssertTrue   ([[polygon interiorPolygons] count] == 1);
        
    }

#pragma mark - Test outerRing

    - (void) testOuterRing {
        XCTAssertEqualObjects([[[[GFPolygon alloc] initWithWKT: @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))"] outerRing] toWKTString], @"LINESTRING(100 0,200 100,200 0,100 1,100 0)");
    }

#pragma mark - Test innerRings

    - (void) testInnerRings {
        XCTAssertEqualObjects([[[[[GFPolygon alloc] initWithWKT: @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))"] innerRings] firstGeometry] toWKTString], @"LINESTRING(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)");
    }

@end