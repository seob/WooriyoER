//
//  PanModalVC.swift
//  PinPle
//
//  Created by seob on 2020/07/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class PanModalVC: UIViewController{

    
    private let alertViewHeight: CGFloat = 262

    let alertView: ContractInfoView = {
        let alertView = ContractInfoView()
        alertView.layer.cornerRadius = 50
        alertView.layer.masksToBounds = true
        alertView.clipsToBounds = true
        alertView.layer.maskedCorners = [.layerMinXMinYCorner]
        return alertView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertViewHeight).isActive = true
    }

    // MARK: - PanModalPresentable
}
extension PanModalVC : PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(alertViewHeight)
    }

    var longFormHeight: PanModalHeight {
        return shortFormHeight
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.1)
    }

    var shouldRoundTopCorners: Bool {
        return false
    }

    var showDragIndicator: Bool {
        return true
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    var isUserInteractionEnabled: Bool {
        return true
    }

}
