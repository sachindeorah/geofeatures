/*
*   GFIntersectionTests.m
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
*   Created by Tony Stone on 08/24/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFIntersectionTests : XCTestCase
@end

@implementation GFIntersectionTests

    - (NSString *)runTestWithInput1WKT: (NSString *) input1WKT input2WKT: (NSString *) input2WKT  {
        GFGeometry * testGeometry1 = [GFGeometry geometryWithWKT: input1WKT];
        GFGeometry * testGeometry2 = [GFGeometry geometryWithWKT: input2WKT];

        GFGeometry * result = [testGeometry1 intersection: testGeometry2];

        return [result toWKTString];
    }

    - (void) testPointPoint {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(0 0)"
                                               input2WKT: @"POINT(1 1)"],

                @"MULTIPOINT()");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(0 0)"
                                               input2WKT: @"POINT(0 0)"],

                @"MULTIPOINT(0 0)");
    }


    - (void) testMultiPointPoint {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(0 0)"
                                               input2WKT: @"POINT(1 1)"],

                @"MULTIPOINT()");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(0 0)"
                                               input2WKT: @"POINT(0 0)"],

                @"MULTIPOINT(0 0)");
    }

    - (void) testMultiPointMultiPoint {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(2 2,3 3,0 0,0 0,2 2,1 1,1 1,1 0,1 0)"
                                               input2WKT: @"MULTIPOINT(1 0,1 1,1 1,1 1)"],

                @"MULTIPOINT(1 0,1 1,1 1,1 1)");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(0 0,1 0,2 0,3 0,0 0,1 0,2 0)"
                                               input2WKT: @"MULTIPOINT(0 1,0 2,1 0,0 0,2 0)"],

                @"MULTIPOINT(1 0,0 0,2 0)");
    }

    - (void) testPointLineString {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(0 0)"
                                               input2WKT: @"LINESTRING(1 1,2 2)"],

                @"MULTIPOINT()");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(1 1)"
                                               input2WKT: @"LINESTRING(0 0,2 2)"],

                @"MULTIPOINT(1 1)");
    }

    - (void) testPointMultiLineString {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(0 0)"
                                               input2WKT: @"MULTILINESTRING((1 1,2 2))"],

                @"MULTIPOINT()");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(1 1)"
                                               input2WKT: @"MULTILINESTRING((0 0,2 2))"],

                @"MULTIPOINT(1 1)");
    }


    - (void) testMultiPointLineString {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(0 0)"
                                               input2WKT: @"LINESTRING(1 1,2 2,3 3,4 4,5 5)"],

                @"MULTIPOINT()");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(0 0,0 0,1 0)"
                                               input2WKT: @"LINESTRING(1 0,2 0)"],

                @"MULTIPOINT(1 0)");
    }

    - (void) testMultiPointMultiLineString {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(0 0,1 0,2 0)"
                                               input2WKT: @"MULTILINESTRING((1 0,1 1,1 1,4 4))"],

                @"MULTIPOINT(1 0)");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOINT(2 2,3 3,0 0,0 0,2 2,1 1,1 1,1 0,1 0)"
                                               input2WKT: @"MULTILINESTRING((1 0,1 1,1 1,4 4))"],

                @"ULTIPOINT(2 2,2 2,3 3,1 1,1 1,1 0,1 0)");
    }

    - (void) testLineStringLineString {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"LINESTRING(0 0,1 1,2 1,3 2)"
                                               input2WKT: @"LINESTRING(0 2,1 1,2 1,3 0)"],

                @"MULTILINESTRING((1 1,2 1))");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"LINESTRING(0 0,5 0)"
                                               input2WKT: @"LINESTRING(3 0,4 0)"],

                @"MULTILINESTRING((3 0,4 0))");
    }

    - (void) testPolygonPolygon {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POLYGON((0 0,0 10,10 10,10 0),(2 2,7 2,7 7,2 7))"
                                               input2WKT: @"POLYGON((2 3,2 6,6 6,6 3))"],

                @"MULTILINESTRING((2 3,2 6),(2 3,2 3))");

        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POLYGON((0 0,0 10,10 10,10 0),(2 2,7 2,7 7,2 7))"
                                               input2WKT: @"POLYGON((2 3,2 7,6 7,6 3))"],

                @"MULTILINESTRING((2 3,2 7,6 7),(2 3,2 3))");
    }

@end