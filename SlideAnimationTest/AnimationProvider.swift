//
//  AnimationProvider.swift
//  SlideAnimationTest
//
//  Created by Maxwell Altman on 12/19/23.
//

import Foundation
protocol AnimationProvider
{
    //this is for when a vc is being dismissed/ removed from the view hierarchy
    func dismissAnimation()
    //this is for when a vc is being presented/ added to the view hierarchy
    func presentAniamtion()
    //this is for when a vc is presenting an animation, and has to animation itself into the background/ offscreen
    func presentingAnimation()
    //
    func getPreferredAnimationType() -> AnimationType
}

enum AnimationType
{
    case horizontal
    case vertical
    case fadeOut
}
