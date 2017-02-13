module OpenSolid.Circle3d
    exposing
        ( Circle3d(Circle3d)
        , centerPoint
        , axialDirection
        , radius
        )

{-|

A `Circle3d` is defined by its center point, axial direction and radius. The
axial direction is the direction of the axis through the center of the circle
that all points on the circle are equidistant from, or equivalently the normal
direction of the plane defined by the circle. Currently you can only do a few
basic things with circles, such as measuring the area or circumference, but this
should increase in the future.

Circles can be constructed by passing a record with `centerPoint`,
`axialDirection` and `radius` fields to the `Circle3d` constructor, for example

    exampleCircle =
        Circle3d
            { centerPoint = Point3d ( 2, 0, 1 )
            , axialDirection = Direction3d.z
            , radius = 3
            }

**You must ensure the provided radius is positive** (or zero, but that's not a
very useful circle).

# Types

@docs Circle3d

# Accessors

@docs centerPoint, axialDirection, radius
-}

import OpenSolid.Geometry.Types exposing (..)


{-| A circle in 3D, defined by its center point, axial direction and radius.
-}
type Circle3d
    = Circle3d
        { centerPoint : Point3d
        , axialDirection : Direction3d
        , radius : Float
        }


{-| Get the center point of a circle.

    Circle3d.centerPoint exampleCircle
    --> Point3d ( 2, 0, 1 )
-}
centerPoint : Circle3d -> Point3d
centerPoint (Circle3d properties) =
    properties.centerPoint


{-| Get the axial direction of a circle.

    Circle3d.axialDirection exampleCircle
    --> Direction3d.z
-}
axialDirection : Circle3d -> Direction3d
axialDirection (Circle3d properties) =
    properties.axialDirection


{-| Get the radius of a circle.

    Circle3d.radius exampleCircle
    --> 3
-}
radius : Circle3d -> Float
radius (Circle3d properties) =
    properties.radius