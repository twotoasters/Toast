//
//  CADisplayLinkAnimator.swift
//  EDPScrollingPrototype
//
//  Created by Duncan Lewis on 2/4/16.
//  Copyright © 2016 Duncan Lewis. All rights reserved.
//

import UIKit

final class CADisplayLinkAnimator: NSObject {

    // MARK: Typealias
    
    typealias AnimationUpdateBlock = (percentComplete: CGFloat) -> ()
    typealias CompletionBlock = () -> Void
    
    // MARK: Properties
    
    let animationDuration: NSTimeInterval
    private let animationUpdateBlock: (CGFloat) -> ()
    private let completionBlock: CompletionBlock?
    
    private var startTimestamp: CFTimeInterval
    private var currentTimestamp: CFTimeInterval = 0.0
    
    private lazy var displayLink: CADisplayLink = {
        return CADisplayLink(target: self, selector: "displayLinkDidFire:")
    }()
    
    
    // MARK: Public Methods
    
    class func animateUsingDisplayLink(
        duration animationDuration: NSTimeInterval,
        animationUpdateBlock: AnimationUpdateBlock)
        -> CADisplayLinkAnimator
    {
        return CADisplayLinkAnimator(
            animationDuration: animationDuration,
            animationUpdateBlock: animationUpdateBlock,
            completionBlock: nil,
            runLoopModes: [NSDefaultRunLoopMode])
    }
    
    
    class func animateUsingDisplayLink(
        duration animationDuration: NSTimeInterval,
        animationUpdateBlock: AnimationUpdateBlock,
        completionBlock: CompletionBlock)
        -> CADisplayLinkAnimator
    {
        return CADisplayLinkAnimator(
            animationDuration: animationDuration,
            animationUpdateBlock: animationUpdateBlock,
            completionBlock: completionBlock,
            runLoopModes: [NSDefaultRunLoopMode])
    }
    
    
    class func animateUsingDisplayLink(
        duration animationDuration: NSTimeInterval,
        animationUpdateBlock: AnimationUpdateBlock,
        completionBlock: CompletionBlock?,
        runLoopModes: [String])
        -> CADisplayLinkAnimator
    {
        return CADisplayLinkAnimator(
            animationDuration: animationDuration,
            animationUpdateBlock: animationUpdateBlock,
            completionBlock: completionBlock,
            runLoopModes: runLoopModes)
    }
    
    
    func cancel() {
        displayLink.invalidate()
    }
    
    
    var paused: Bool = false {
        didSet {
            displayLink.paused = paused
        }
    }

    
    // MARK: Initializers
    
    private init(animationDuration: NSTimeInterval, animationUpdateBlock: AnimationUpdateBlock, completionBlock: CompletionBlock?, runLoopModes: [String]) {
        self.animationDuration = animationDuration
        self.animationUpdateBlock = animationUpdateBlock
        self.startTimestamp = CACurrentMediaTime()
        self.completionBlock = completionBlock
        
        super.init()
        
        for runLoopMode in runLoopModes {
            self.displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: runLoopMode)
        }
        
        animationUpdateBlock(percentComplete: 0)
    }
    
    
    // MARK: Display Link Handling
    
    @objc private func displayLinkDidFire(displayLink: CADisplayLink) {
        
        let percentComplete = CGFloat(displayLink.timestamp - startTimestamp) / CGFloat(animationDuration)
        
        print(percentComplete)
        
        if (percentComplete < 1.0) {
            animationUpdateBlock(percentComplete)
        } else {
            animationUpdateBlock(1.0)
            completionBlock?()
            cancel()
        }
    }
    
}
