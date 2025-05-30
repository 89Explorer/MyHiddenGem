//
//  ActionSheetViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/30/25.
//

import UIKit

class ActionSheetViewController: UIViewController {
    
    
    // MARK: - UI Component
    private let stackView: UIStackView = UIStackView()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        setupUI()
        setupSheetPresentation()
    }
    
    
    // MARK: - Function
    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let listButton = makeButton(title: "리스트에 담기", action: #selector(handleListButton))
        let shareButton = makeButton(title: "공유하기", action: #selector(handleShareButton))
        let cancelButton = makeButton(title: "취소하기", isDestructive: true, action: #selector(handleCancelButton))
        
        let upperStack = UIStackView(arrangedSubviews: [listButton, shareButton])
        upperStack.axis = .vertical
        upperStack.spacing = 8
        upperStack.distribution = .fillEqually
        //upperStack.alignment = .center
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        stackView.addArrangedSubview(upperStack)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(cancelButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            //stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            

        ])
        
    }
    
    
    private func setupSheetPresentation() {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { _ in 220.0 }
            ]
            
            //sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
    }

    
    private func makeButton(title: String, isDestructive: Bool = false, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(isDestructive ? .systemRed : .label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    
    // MARK: - Button Actions
    
    @objc private func handleListButton() {
        print("리스트에 담기 버튼이 눌러졌습니다.")
    }
    
    @objc private func handleShareButton() {
        print("공유하기 버튼이 눌렸습니다.")
    }
    
    @objc private func handleCancelButton() {
        print("취소하기 버튼이 눌렸습니다.")
        dismiss(animated: true)
    }
    
}
