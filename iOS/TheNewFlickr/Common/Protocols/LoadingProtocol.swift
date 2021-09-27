//
//  LoadingProtocol.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 26/09/2021.
//

import UIKit

protocol LoadingProtocol {
    func showLoading(view: UIView) -> UIActivityIndicatorView
    func removeLoading(_ activityIndicator: UIActivityIndicatorView?, from view: UIView)
}

extension LoadingProtocol {
    
    func showLoading(view: UIView) -> UIActivityIndicatorView {
        view.isUserInteractionEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.4941176471, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }

    func removeLoading(_ activityIndicator: UIActivityIndicatorView?, from view: UIView) {
        view.isUserInteractionEnabled = true
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
}
