{- This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, you can
   obtain one at http://mozilla.org/MPL/2.0/.

   Copyright 2016 by Ian Mackenzie
   ian.e.mackenzie@gmail.com
-}


module OpenSolid.Core.Axis3d
    exposing
        ( x
        , y
        , z
        , originPoint
        , direction
        , flip
        , scaleAbout
        , rotateAround
        , translateBy
        , moveTo
        , mirrorAcross
        , relativeTo
        , placeIn
        , projectOnto
        , projectInto2d
        )

import OpenSolid.Core.Types exposing (..)
import OpenSolid.Core.Point3d as Point3d
import OpenSolid.Core.Direction3d as Direction3d


x : Axis3d
x =
    Axis3d { originPoint = Point3d.origin, direction = Direction3d.x }


y : Axis3d
y =
    Axis3d { originPoint = Point3d.origin, direction = Direction3d.y }


z : Axis3d
z =
    Axis3d { originPoint = Point3d.origin, direction = Direction3d.z }


originPoint : Axis3d -> Point3d
originPoint (Axis3d properties) =
    properties.originPoint


direction : Axis3d -> Direction3d
direction (Axis3d properties) =
    properties.direction


flip : Axis3d -> Axis3d
flip axis =
    Axis3d
        { originPoint = originPoint axis
        , direction = Direction3d.negate (direction axis)
        }


scaleAbout : Point3d -> Float -> Axis3d -> Axis3d
scaleAbout centerPoint scale axis =
    let
        scalePoint =
            Point3d.scaleAbout centerPoint scale
    in
        Axis3d
            { originPoint = scalePoint (originPoint axis)
            , direction = direction axis
            }


rotateAround : Axis3d -> Float -> Axis3d -> Axis3d
rotateAround otherAxis angle =
    let
        rotatePoint =
            Point3d.rotateAround otherAxis angle

        rotateDirection =
            Direction3d.rotateAround otherAxis angle
    in
        \axis ->
            Axis3d
                { originPoint = rotatePoint (originPoint axis)
                , direction = rotateDirection (direction axis)
                }


translateBy : Vector3d -> Axis3d -> Axis3d
translateBy vector axis =
    Axis3d
        { originPoint = Point3d.translateBy vector (originPoint axis)
        , direction = direction axis
        }


moveTo : Point3d -> Axis3d -> Axis3d
moveTo newOrigin axis =
    Axis3d { originPoint = newOrigin, direction = direction axis }


mirrorAcross : Plane3d -> Axis3d -> Axis3d
mirrorAcross plane =
    let
        mirrorPoint =
            Point3d.mirrorAcross plane

        mirrorDirection =
            Direction3d.mirrorAcross plane
    in
        \axis ->
            Axis3d
                { originPoint = mirrorPoint (originPoint axis)
                , direction = mirrorDirection (direction axis)
                }


relativeTo : Frame3d -> Axis3d -> Axis3d
relativeTo frame =
    let
        relativePoint =
            Point3d.relativeTo frame

        relativeDirection =
            Direction3d.relativeTo frame
    in
        \axis ->
            Axis3d
                { originPoint = relativePoint (originPoint axis)
                , direction = relativeDirection (direction axis)
                }


placeIn : Frame3d -> Axis3d -> Axis3d
placeIn frame =
    let
        placePoint =
            Point3d.placeIn frame

        placeDirection =
            Direction3d.placeIn frame
    in
        \axis ->
            Axis3d
                { originPoint = placePoint (originPoint axis)
                , direction = placeDirection (direction axis)
                }


projectOnto : Plane3d -> Axis3d -> Maybe Axis3d
projectOnto plane axis =
    let
        projectedOrigin =
            Point3d.projectOnto plane (originPoint axis)

        toAxis direction =
            Axis3d { originPoint = projectedOrigin, direction = direction }
    in
        Maybe.map toAxis (Direction3d.projectOnto plane (direction axis))


projectInto2d : PlanarFrame3d -> Axis3d -> Maybe Axis2d
projectInto2d planarFrame axis =
    let
        projectedOrigin =
            Point3d.projectInto2d planarFrame (originPoint axis)

        maybeDirection =
            Direction3d.projectInto2d planarFrame (direction axis)

        toAxis direction =
            Axis2d { originPoint = projectedOrigin, direction = direction }
    in
        Maybe.map toAxis maybeDirection
