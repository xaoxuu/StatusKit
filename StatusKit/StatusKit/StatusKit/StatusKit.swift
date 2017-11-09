//
//  StatusKit.swift
//  StatusKit
//
//  Created by xaoxuu on 09/11/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

import UIKit


class StatusKit: UIView {
    
    /// 是否是iPhone X
    internal static let isIphoneX: Bool = {
        if UIScreen.main.currentMode?.size.equalTo(CGSize.init(width: 1125, height: 2436)) == true {
            return true
        } else {
            return false
        }
    }()
    
    /// 系统状态栏
    public static var systemStatusBar: UIView = {
        return UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as! UIView
    }()
    
    /// 自定义状态栏
    public static var customStatusBar: UIView = {
        let view = UIView.init(frame: StatusKit.systemStatusBar.bounds)
        StatusKit.systemStatusBar.insertSubview(view, at: 0)
        return view
    }()
    

}


// MARK: 状态栏消息
extension StatusKit {
    
    /// 是否正在显示
    internal static var isStatusMessageShowing = false
    
    /// 状态栏消息容器
    internal static var statusBarMessageContentView: UIView = {
        var frame = StatusKit.systemStatusBar.bounds
        if isIphoneX {
            frame.size.height += 6;
        }
        let view = UIView.init(frame: frame)
        StatusKit.systemStatusBar.insertSubview(view, at: 0)
        return view
    }()
    
    /// 状态栏消息
    internal static var statusBarMessageLabel: UILabel = {
        var frame = StatusKit.systemStatusBar.bounds
        if isIphoneX {
            frame.size.height += 6
        }
        let label = UILabel.init(frame: StatusKit.systemStatusBar.bounds)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        StatusKit.statusBarMessageContentView.addSubview(label)
        return label
    }()
    
    
    /// 设置并获取状态栏label
    ///
    /// - Parameter text: 文字
    /// - Returns: label
    internal static func getStatusBarMessageLabel(text: String) -> UILabel {
        statusBarMessageLabel.text = text
        statusBarMessageLabel.sizeToFit()
        var frame = statusBarMessageLabel.frame
        frame.size.height = 20
        frame.origin.x = 6
        frame.origin.y = statusBarMessageContentView.bounds.size.height - 20
        statusBarMessageLabel.frame = frame
        
        let offset = 2 * frame.origin.x + frame.size.width - systemStatusBar.bounds.size.width
        statusBarMessageLabel.layer.removeAllAnimations()
        if offset > 0 {
            let animation = CABasicAnimation.init(keyPath: "transform.translation.x")
            animation.repeatDuration = 100
            animation.toValue = -offset
            animation.autoreverses = true
            animation.duration = CFTimeInterval(offset/40.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.38, execute: {
                statusBarMessageLabel.layer.add(animation, forKey: "scroll")
            })
        }
        return statusBarMessageLabel
    }
    
    internal static var hideMessageTask = DispatchWorkItem.init {
        
    }
    
    internal static func showStatusBarMessageView(duration: TimeInterval) {
        // 显示
        if !isStatusMessageShowing {
            statusBarMessageContentView.alpha = 0
            systemStatusBar.addSubview(statusBarMessageContentView)
            UIView.animate(withDuration: 0.38, animations: {
                statusBarMessageContentView.alpha = 1
            }) { (finished) in
                isStatusMessageShowing = true
            }
        }
        
        // 超时自动消失
        hideMessageTask.cancel()
        hideMessageTask = DispatchWorkItem.init(block: {
            hideStatusBarMessage()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: hideMessageTask)
    }
    
    @objc internal static func hideStatusBarMessage() {
        UIView.animate(withDuration: 0.38, animations: {
            statusBarMessageContentView.alpha = 0
        }) { (finished) in
            isStatusMessageShowing = false
            statusBarMessageContentView.removeFromSuperview()
        }
    }
    @discardableResult
    public static func showStatusBarMessage(message: String, textColor: UIColor, backgroundColor: UIColor, duration: TimeInterval) -> UILabel {
        statusBarMessageContentView.backgroundColor = backgroundColor
        let label = getStatusBarMessageLabel(text: message)
        label.textColor = textColor
        showStatusBarMessageView(duration: duration)
        return label
    }
    
    
}

// MARK: 状态栏进度消息
extension StatusKit {
    internal static var isStatusProgressMessageShowing = false
    // 状态栏进度信息容器
    internal static var statusBarProgressMessageContentView: UIView = {
        let view = UIView.init()
        let statusBarSize = StatusKit.systemStatusBar.bounds.size
        let width = CGFloat(100)
        var frame = CGRect.init(x: (statusBarSize.width - width)/2, y: 0, width: width, height: statusBarSize.height)
        if isIphoneX {
            let moreWidth = CGFloat(20)
            frame.size.width += 2*moreWidth
            frame.origin.x = -moreWidth
            frame.size.height -= 14
        } else {
            
        }
        view.frame = frame
        StatusKit.systemStatusBar.insertSubview(view, at: 0)
        return view
    }()
    
    
    internal static var statusBarProgressMessageLabel: UILabel = {
        let label = UILabel.init()
        let contentBounds = StatusKit.statusBarProgressMessageContentView.bounds
        var frame = contentBounds
        if isIphoneX {
            frame.size.height = 14
            frame.origin.y = contentBounds.size.height - frame.size.height
            label.font = UIFont.boldSystemFont(ofSize: 15)
        } else {
            frame.size.height = 20
            label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        label.frame = frame
        label.textAlignment = .center
        StatusKit.statusBarProgressMessageContentView.addSubview(label)
        return label
    }()
    
    
    internal static func getStatusBarProgressMessageLabel(text: String) -> UILabel {
        statusBarProgressMessageLabel.text = text
        return statusBarProgressMessageLabel
    }
    
    internal static var hideProgressMessageTask = DispatchWorkItem.init {
        
    }
    
    @objc internal static func hideStatusBarProgressMessage() {
        UIView.animate(withDuration: 0.38, animations: {
            statusBarProgressMessageContentView.alpha = 0
        }) { (finished) in
            isStatusProgressMessageShowing = false
            statusBarProgressMessageContentView.removeFromSuperview()
        }
    }
    
    
    
    
    
    internal static func showStatusBarProgressMessageView(duration: TimeInterval) {
        // 显示
        if !isStatusProgressMessageShowing {
            statusBarProgressMessageContentView.alpha = 0
            systemStatusBar.addSubview(statusBarProgressMessageContentView)
            UIView.animate(withDuration: 0.38, animations: {
                statusBarProgressMessageContentView.alpha = 1
            }) { (finished) in
                isStatusProgressMessageShowing = true
            }
        }
        // 超时自动消失
        hideProgressMessageTask.cancel()
        hideProgressMessageTask = DispatchWorkItem.init(block: {
            hideStatusBarProgressMessage()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: hideProgressMessageTask)
        
    }
    
    
    @discardableResult
    public static func showStatusBarProgressMessage(message: String, textColor: UIColor, backgroundColor: UIColor, duration: TimeInterval) -> UILabel {
        if message.lengthOfBytes(using: .utf8) > 6 {
            return showStatusBarMessage(message: message, textColor: textColor, backgroundColor: backgroundColor, duration: duration)
        }
        statusBarProgressMessageContentView.backgroundColor = backgroundColor
        let label = getStatusBarProgressMessageLabel(text: message)
        label.textColor = textColor
        showStatusBarProgressMessageView(duration: duration)
        return label
    }
    
}


extension CALayer {
    
    public func showColorAnimation(color: UIColor, callback: (_ : CABasicAnimation) -> Swift.Void) {
        let animation = CABasicAnimation.init(keyPath: "backgroundColor")
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = 1
        animation.repeatCount = 1
        animation.toValue = color.cgColor
        callback(animation)
        self.add(animation, forKey: "backgroundColor")
    }
    
    public func showColorAnimation(color: UIColor, duration: CFTimeInterval, repeatCount: Float) {
        showColorAnimation(color: color) { (ani) in
            ani.duration = duration
            ani.repeatCount = repeatCount
        }
    }
    
    public func showColorAnimation(color: UIColor, duration: CFTimeInterval, repeatDuration: CFTimeInterval) {
        showColorAnimation(color: color) { (ani) in
            ani.duration = duration
            ani.repeatDuration = repeatDuration
        }
    }
    
    public func hideColorAnimation() {
        self.removeAnimation(forKey: "backgroundColor")
    }
    
}


