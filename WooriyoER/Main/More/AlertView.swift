//
//  AlertView.swift
//  PinPle
//
//  Created by seob on 2020/07/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    // MARK: - Views
    
    struct Constants {
        static let contentInsets = UIEdgeInsets(top: 200.0, left: 16.0, bottom: 12.0, right: 16.0)
    }
    lazy var profimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeRounded()
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansCJKkr-Medium", size: 17.0)
        label.textColor = .black
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 13.0)
        label.textColor = .black
        return label
    }()
    
    let tmpsaveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 168).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansCJKkr-Medium", size: 13.0)
        label.textColor = UIColor.init(hexString: "#FF7600")
        return label
    }()
    
    
    private lazy var alertStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10.0
        return stackView
    }()
     
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tmpsaveButton , saveButton])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 11.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    
    let btnLabel: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icn_lc_later")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return view
    }()

    let btnLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "임 시 저 장"
        label.font = UIFont(name: "NotoSansCJKkr-Medium", size: 17.0)
        return label
    }()
    
    let btnsaveLabel: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "icn_lc_exit")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return view
    }()

    let btnsaveLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.text = "작 성 종 료"
        label.font = UIFont(name: "NotoSansCJKkr-Medium", size: 17.0)
        return label
    }()
    
    

   private lazy var stackView2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [btnLabel, btnLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var stackView3: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [btnsaveLabel, btnsaveLabel2])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupView() {
        backgroundColor = .white
        addSubview(profimageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(stackView)
        addSubview(timeLabel)
        tmpsaveButton.addSubview(stackView2)
        saveButton.addSubview(stackView3)
        layoutIcon()
    }
    
    private func layoutIcon() {
        profimageView.translatesAutoresizingMaskIntoConstraints = false
        profimageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        profimageView.topAnchor.constraint(equalTo: topAnchor, constant: 21).isActive = true
        profimageView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        profimageView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        
        profimageView.makeRounded()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: profimageView.trailingAnchor, constant: 9).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: profimageView.trailingAnchor, constant: 9).isActive = true
        
         
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 50).isActive = true
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInsets.top).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInsets.left).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.contentInsets.right).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.contentInsets.bottom).isActive = true
        
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.leadingAnchor.constraint(equalTo: tmpsaveButton.leadingAnchor, constant: 20).isActive = true
        stackView2.trailingAnchor.constraint(equalTo: tmpsaveButton.trailingAnchor, constant: 0).isActive = true
        stackView2.topAnchor.constraint(equalTo: tmpsaveButton.topAnchor, constant: 0).isActive = true
        stackView2.bottomAnchor.constraint(equalTo: tmpsaveButton.bottomAnchor, constant: 0).isActive = true
        
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        stackView3.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: 20).isActive = true
        stackView3.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 0).isActive = true
        stackView3.topAnchor.constraint(equalTo: saveButton.topAnchor, constant: 0).isActive = true
        stackView3.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 0).isActive = true
    }
     
}
