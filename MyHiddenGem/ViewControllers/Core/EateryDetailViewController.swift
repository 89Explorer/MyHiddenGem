//
//  EateryDetailViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/23/25.
//

import UIKit
import Combine


class EateryDetailViewController: UIViewController {

    
    // MARK: - Variable
    private var contentID: String = ""
    private var contentType: String = ""
    private var eateryTitle: String = ""
    private var posterPath: String = ""
    
    private var headerData: EateryFromDetailHeader?
    
    
    private var detailViewModel: DetailViewModel = DetailViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<EateryFromDetailSection, EateryFromDetailType>?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Component
    
    private var detailCollectionView: UICollectionView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
 
    // MARK: - Init
    
    init(with headerData: EateryFromDetailHeader) {
        super.init(nibName: nil, bundle: nil)
        self.headerData = headerData
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("✅ 음식점 이름: \(eateryTitle), 음식점 코드: \(contentID)")
        
        setupNavigationBar()
        setupCollectionView()
        //self.navigationController?.navigationBar.isHidden = true;
        createDataSource()
    
        fetchEateryDetailIntroInfo(contentId: headerData!.contentId, contentType: headerData!.contentType)
        bindViewModel()
        
    }
}


// MARK: - Extension: 네비게이션 바 설정

extension EateryDetailViewController {
    
    /// 네비게이션바 설정하는 함수
    func setupNavigationBar() {
        navigationItem.title = "상세페이지"
        
        navigationItem.hidesBackButton = true
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .done, target: self, action: #selector(didTappedBackButton))
        backBarButton.tintColor = .label
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    /// 뒤로가기 액션 메서드
    @objc private func didTappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}



// MARK: - Extension: CollectionView 설정

extension EateryDetailViewController {
    
    
    private func setupCollectionView() {
        
        detailCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        detailCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailCollectionView.backgroundColor = .systemGray6
        detailCollectionView.showsVerticalScrollIndicator = false
        detailCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(detailCollectionView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = view.center
        
        detailCollectionView.register(DetailHeaderCell.self, forCellWithReuseIdentifier: DetailHeaderCell.reuseIdentifier)
    }
    
    
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<EateryFromDetailSection, EateryFromDetailType>()
        
        snapshot.appendSections([.header])
        
        let headerInfo = EateryFromDetailHeader(
            contentId: headerData!.contentId,
            contentType: headerData!.contentType,
            eateryTitle: headerData?.eateryTitle ?? "상세 페이지",
            posterPath: headerData!.posterPath,
            cat3: headerData!.cat3)
        
        snapshot.appendItems([.header(headerInfo)], toSection: .header)
        //snapshot.appendItems(detailViewModel.detailIntro.map { .eateryInfo($0)}, toSection: .eateryInfo)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<EateryFromDetailSection, EateryFromDetailType>(collectionView: detailCollectionView) { collectionView, indexPath, item in
            switch item {
            case .header(let header):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.reuseIdentifier, for: indexPath) as? DetailHeaderCell
                cell?.configure(headerData: header)
                return cell
//            case .eateryInfo(let info):
//                return UICollectionViewCell()
            }
        }
    }
    
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, environment in
            let sectionIdentifier = EateryFromDetailSection.allCases[sectionIndex]
            
            switch sectionIdentifier {
            case .header:
                return self.createHeaderSection(using: self.headerData!)
//            case .eateryInfo:
//                return self.createHeaderSection(using: self.headerData!)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    
    private func createHeaderSection(using section: EateryFromDetailHeader) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        return section
    }
    
    
}


// MARK: - Extension: 바인딩 함수

extension EateryDetailViewController {
    
    private func fetchEateryDetailIntroInfo(contentId: String, contentType: String) {
        
        Task {
            async let eateryInfo: () = detailViewModel.fetchDetailInfo(contentId: contentId, contentType: contentType)
            
            await eateryInfo
        }
    }
    
    
    private func bindViewModel() {
        
        detailViewModel.$detailIntro
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
}
