//
//  UIView.swift
//  majeHub
//
//  Created by Mauro Olivo on 13/02/21.
//

import UIKit

extension UIView {
  
  class func fromNib<T: UIView>() -> T {
    
    return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
  }
}
