/*
*   GFWithinTests.m
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
*   Created by Tony Stone on 06/15/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFWithinTests : XCTestCase
@end

#define WithinTest(T1,input1,T2, input2,expected) XCTAssertEqual([[[T1 alloc] initWithWKT: (input1)] within: [[T2 alloc] initWithWKT: (input2)]], (expected))

@implementation GFWithinTests

    - (void) testWithin_WithPointWithinPoint {
        WithinTest(GFPoint, @"POINT(4 1)", GFPoint, @"POINT(4 1)", true);
    }

    - (void) testWithin_WithPointOutsidePoint {
        WithinTest(GFPoint, @"POINT(0 0)", GFPoint, @"POINT(4 1)", false);
    }

    - (void) testWithin_WithPointWithinLineString {
        WithinTest(GFPoint, @"POINT(0.5 0.5)", GFLineString, @"LINESTRING(0 0,1 1)", true);
    }

    - (void) testWithin_WithPointOutsideLineString {
        WithinTest(GFPoint, @"POINT(2 2)", GFLineString, @"LINESTRING(0 0,1 1)", false);
    }

    - (void) testWithin_WithPointWithinPolygon {
        WithinTest(GFPoint, @"POINT(4 1)", GFPolygon, @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", true);
    }

    - (void) testWithin_WithLineStringWithinPolygon {
        WithinTest(GFLineString, @"LINESTRING(4 1,4 2)", GFPolygon, @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", true);
    }

    - (void) testWithin_WithLineStringOutsidePolygon {
        WithinTest(GFLineString, @"LINESTRING(0 0,1 1)", GFPolygon, @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", false);
    }

    - (void) testWithin_WithPointWithinRing {
        WithinTest(GFPoint, @"POINT(4 1)", GFRing, @"LINESTRING(2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)", true);
    }

    - (void) testWithin_WithPointOutsideRing {
        WithinTest(GFPoint, @"POINT(2 2)", GFRing, @"LINESTRING(0 0,1 1)", false);
    }

@end