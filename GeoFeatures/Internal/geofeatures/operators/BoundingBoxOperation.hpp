/**
*   BoundingBoxOperation.hpp
*
*   Copyright 2015 The Climate Corporation
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
*   Created by Tony Stone on 6/11/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#ifndef __BoundingBoxOperation_HPP_
#define __BoundingBoxOperation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/envelope.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        class BoundingBoxOperation : public  boost::static_visitor<geofeatures::Box> {

        public:
            template <typename T>
            geofeatures::Box operator()(const T * v) const {
                return boost::geometry::return_envelope<geofeatures::Box>(*v);
            }

            geofeatures::Box operator()(const GeometryCollection<> * v) const {
                // zero size box
                return geofeatures::Box(geofeatures::Point(),geofeatures::Point());
            }
        };

    }   // namespace operators
}   // namespace geofeatures

#endif //__BoundingBoxOperation_HPP_
