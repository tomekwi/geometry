{- This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, you can
   obtain one at http://mozilla.org/MPL/2.0/.

   Copyright 2016 by Ian Mackenzie
   ian.e.mackenzie@gmail.com
-}


module OpenSolid.Frame3d
    exposing
        ( xyz
        , at
        , xAxis
        , yAxis
        , zAxis
        , xyPlane
        , xzPlane
        , yxPlane
        , yzPlane
        , zxPlane
        , zyPlane
        , point
        , vector
        , scaleAbout
        , rotateAround
        , rotateAroundOwn
        , translateBy
        , translateAlong
        , translateAlongOwn
        , mirrorAcross
        , mirrorAcrossOwn
        , toLocalIn
        , toGlobalFrom
        )

import OpenSolid.Core.Types exposing (..)
import OpenSolid.Point3d as Point3d
import OpenSolid.Vector3d as Vector3d
import OpenSolid.Direction3d as Direction3d


xyz : Frame3d
xyz =
    at Point3d.origin


at : Point3d -> Frame3d
at point =
    Frame3d point Direction3d.x Direction3d.y Direction3d.z


xAxis : Frame3d -> Axis3d
xAxis frame =
    Axis3d frame.originPoint frame.xDirection


yAxis : Frame3d -> Axis3d
yAxis frame =
    Axis3d frame.originPoint frame.yDirection


zAxis : Frame3d -> Axis3d
zAxis frame =
    Axis3d frame.originPoint frame.zDirection


xyPlane : Frame3d -> Plane3d
xyPlane frame =
    Plane3d frame.originPoint
        frame.xDirection
        frame.yDirection
        frame.zDirection


xzPlane : Frame3d -> Plane3d
xzPlane frame =
    Plane3d frame.originPoint
        frame.xDirection
        frame.zDirection
        (Direction3d.negate frame.yDirection)


yxPlane : Frame3d -> Plane3d
yxPlane frame =
    Plane3d frame.originPoint
        frame.yDirection
        frame.xDirection
        (Direction3d.negate frame.zDirection)


yzPlane : Frame3d -> Plane3d
yzPlane frame =
    Plane3d frame.originPoint
        frame.yDirection
        frame.zDirection
        frame.xDirection


zxPlane : Frame3d -> Plane3d
zxPlane frame =
    Plane3d frame.originPoint
        frame.zDirection
        frame.xDirection
        frame.yDirection


zyPlane : Frame3d -> Plane3d
zyPlane frame =
    Plane3d frame.originPoint
        frame.zDirection
        frame.yDirection
        (Direction3d.negate frame.xDirection)


point : Float -> Float -> Float -> Frame3d -> Point3d
point x y z frame =
    Point3d.plus (vector x y z frame) frame.originPoint


vector : Float -> Float -> Float -> Frame3d -> Vector3d
vector x y z frame =
    let
        xDisplacement =
            Direction3d.times x frame.xDirection

        yDisplacement =
            Direction3d.times y frame.yDirection

        zDisplacement =
            Direction3d.times z frame.zDirection
    in
        Vector3d.plus zDisplacement
            (Vector3d.plus yDisplacement xDisplacement)


scaleAbout : Point3d -> Float -> Frame3d -> Frame3d
scaleAbout centerPoint scale frame =
    let
        scaledOriginPoint =
            Point3d.scaleAbout centerPoint scale frame.originPoint
    in
        { frame | originPoint = scaledOriginPoint }


rotateAround : Axis3d -> Float -> Frame3d -> Frame3d
rotateAround axis angle =
    let
        rotatePoint =
            Point3d.rotateAround axis angle

        rotateDirection =
            Direction3d.rotateAbout axis.direction angle
    in
        \frame ->
            Frame3d (rotatePoint frame.originPoint)
                (rotateDirection frame.xDirection)
                (rotateDirection frame.yDirection)
                (rotateDirection frame.zDirection)


rotateAroundOwn : (Frame3d -> Axis3d) -> Float -> Frame3d -> Frame3d
rotateAroundOwn axis angle frame =
    rotateAround (axis frame) angle frame


translateBy : Vector3d -> Frame3d -> Frame3d
translateBy vector frame =
    { frame | originPoint = Point3d.plus vector frame.originPoint }


translateAlong : Axis3d -> Float -> Frame3d -> Frame3d
translateAlong axis distance =
    translateBy (Vector3d.along axis distance)


translateAlongOwn : (Frame3d -> Axis3d) -> Float -> Frame3d -> Frame3d
translateAlongOwn axis distance frame =
    translateAlong (axis frame) distance frame


mirrorAcross : Plane3d -> Frame3d -> Frame3d
mirrorAcross plane =
    let
        mirrorPoint =
            Point3d.mirrorAcross plane

        mirrorDirection =
            Direction3d.mirrorIn plane.normalDirection
    in
        \frame ->
            Frame3d (mirrorPoint frame.originPoint)
                (mirrorDirection frame.xDirection)
                (mirrorDirection frame.yDirection)
                (mirrorDirection frame.zDirection)


mirrorAcrossOwn : (Frame3d -> Plane3d) -> Frame3d -> Frame3d
mirrorAcrossOwn plane frame =
    mirrorAcross (plane frame) frame


toLocalIn : Frame3d -> Frame3d -> Frame3d
toLocalIn otherFrame =
    let
        localizePoint =
            Point3d.toLocalIn otherFrame

        localizeDirection =
            Direction3d.toLocalIn otherFrame
    in
        \frame ->
            Frame3d (localizePoint frame.originPoint)
                (localizeDirection frame.xDirection)
                (localizeDirection frame.yDirection)
                (localizeDirection frame.zDirection)


toGlobalFrom : Frame3d -> Frame3d -> Frame3d
toGlobalFrom frame =
    let
        globalizePoint =
            Point3d.toGlobalFrom frame

        globalizeDirection =
            Direction3d.toGlobalFrom frame
    in
        \frame ->
            Frame3d (globalizePoint frame.originPoint)
                (globalizeDirection frame.xDirection)
                (globalizeDirection frame.yDirection)
                (globalizeDirection frame.zDirection)
