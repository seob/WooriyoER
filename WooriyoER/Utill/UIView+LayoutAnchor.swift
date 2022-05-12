//
//  UIView+LayoutAnchor.swift
//  PinPle
//
//  Created by seob on 2020/02/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//
 
import UIKit

extension UIView {
  func topAnchor(equalTo view: UIView, constant: CGFloat = 0.0) -> Self {
    self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
    return self
  }
  func bottomAnchor(equalTo view: UIView, constant: CGFloat = 0.0) -> Self {
    self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
    return self
  }
  func leadingAnchor(equalTo view: UIView, constant: CGFloat = 0.0) -> Self {
    self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    return self
  }
  func trailingAnchor(equalTo view: UIView, constant: CGFloat = 0.0) -> Self {
    self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    return self
  }
  func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> Self {
    self.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self
  }
  func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0.0) -> Self {
    self.bottomAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    return self
  }
  func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> Self {
    self.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    return self
  }
  func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0.0) -> Self {
    self.trailingAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    return self
  }
  func widthAnchor(qeualToConstant: CGFloat) -> Self {
    self.widthAnchor.constraint(equalToConstant: qeualToConstant).isActive = true
    return self
  }
  func heightAnchor(equalTConstant: CGFloat) -> Self {
    self.heightAnchor.constraint(equalToConstant: equalTConstant).isActive = true
    return self
  }
  func sizeAnchor(size : CGSize) -> Self {
    self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    return self
  }
  func activeAnchor() {
    translatesAutoresizingMaskIntoConstraints = false
  }
}

 
