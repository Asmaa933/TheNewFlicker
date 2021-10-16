//
//  UIViewControllerExtension.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 26/09/2021.
//

import UIKit

extension UIViewController {
    func loadViewFromStoryboard<T>(viewControllerType: T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
