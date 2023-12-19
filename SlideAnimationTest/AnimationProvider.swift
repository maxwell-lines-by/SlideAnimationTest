import Foundation

//protocol for view controllers with custom transition Animations
protocol TransitionAnimationProvider
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
