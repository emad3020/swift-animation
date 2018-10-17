//
//  ViewController.swift
//  Facebook Popup Animation
//
//  Created by Emad on 10/16/18.
//  Copyright © 2018 Askerlap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bgImageView : UIImageView = {
        let imge = UIImage(named: "fb_core_bg")
        let imageView = UIImageView(image: imge)
        return imageView
        
    }()
    
    let iconContainerView : UIView = {
        let conatinerView = UIView()
        conatinerView.backgroundColor = .white
        
//        let redView = UIView()
//        redView.backgroundColor = .red
//
//        let blueView = UIView()
//        blueView.backgroundColor = .blue
//
//        let yellowView = UIView()
//        yellowView.backgroundColor = .yellow
//
//        let grayView = UIView()
//        grayView.backgroundColor = .gray
//
//        let arrangedSubviews = [redView , blueView , yellowView, grayView]
        
        let iconHeight: CGFloat = 50
        let padding: CGFloat = 8
        
        let images = [UIImage(named: "like_emoji") , UIImage(named:"sad_emoji"),UIImage(named: "wow_emoji"), UIImage(named: "haha_emoji"),
                      UIImage(named: "love_emoji"), UIImage(named: "angry_emoji")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            imageView.isUserInteractionEnabled = true
            return imageView
//            let v = UIView()
//            v.backgroundColor = color
//            v.layer.cornerRadius = iconHeight / 2
//            return v
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        
        
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let numIcon = CGFloat(arrangedSubviews.count)
        let width = numIcon * iconHeight + (numIcon + 1) * padding
        
        conatinerView.addSubview(stackView)
        
        conatinerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
         conatinerView.layer.cornerRadius = conatinerView.frame.height / 2
        conatinerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        conatinerView.layer.shadowRadius = 8
        conatinerView.layer.shadowOpacity = 0.5
        conatinerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = conatinerView.frame
        return conatinerView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bgImageView)
        bgImageView.frame =  view.frame
        
        setupLongPressGesture()

    }
    
    override var prefersStatusBarHidden: Bool {return true}


    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer){
//        print("Long  pressd: ", Date())
        
        
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
            
        } else if gesture.state == .ended {
          
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackview = self.iconContainerView.subviews.first
                stackview?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
            }) { (_) in
                self.iconContainerView.removeFromSuperview()
            }
            
            
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        
        let pressedLocation = gesture.location(in: self.iconContainerView)
        print("gesture Location Changed: ", pressedLocation)
        
       let hitTestView = iconContainerView.hitTest(pressedLocation, with: nil)
        
        
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackview = self.iconContainerView.subviews.first
                stackview?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
        
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconContainerView)
        
        
        let pressLocation = gesture.location(in: self.view)
        print(pressLocation)
        
        let centeredX = (view.frame.width - iconContainerView.frame.width) / 2
        
        iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressLocation.y )
        
        iconContainerView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.iconContainerView.alpha = 1
            
            self.iconContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressLocation.y - self.iconContainerView.frame.height)
        })
    }
}

