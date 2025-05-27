//
//  IntroSheetViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/27/25.
//

import UIKit

class IntroSheetViewController: UIViewController {
    
    
    // MARK: - Variable
    
    private let text: String

    
    // MARK: - Init
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupUI()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
    }
    
    
    // MARK: - Function
    private func setupUI() {
        
        let label = BasePaddingLabel()
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false

        let backButton = UIButton()
        backButton.layer.cornerRadius = 8
        backButton.clipsToBounds = true
        backButton.setTitle("확인", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.backgroundColor = .systemGreen
        backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(backButton)

        // contentView 내부 제약
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            label.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20),

            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }


    
    @objc private func didTappedBackButton() {
        self.dismiss(animated: true)
    }
}
