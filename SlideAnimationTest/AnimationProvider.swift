import Foundation

//protocol for view controllers with custom transition Animations
protocol TransitionAnimationProvider
{
    //this is for when a vc is being dismissed/ removed from the view hierarchy
    func dismissAnimation(completion: ((Bool) -> Void)?)
    //this is for when a vc is being presented/ added to the view hierarchy
    func presentAniamtion(completion: ((Bool) -> Void)?)
    //this is for when a vc is presenting an animation, and has to animation itself into the background/ offscreen
    func backgroundAnimation()
    //this is for when the animation being presented is dismissed, and the view beneth it is allowed to return to the main view
    func foregroundAnimation()
}
