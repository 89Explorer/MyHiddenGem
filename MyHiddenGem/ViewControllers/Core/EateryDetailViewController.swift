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
        
        setupNavigationBar()
        setupCollectionView()
        createDataSource()
        //self.navigationController?.navigationBar.isHidden = true;
        bindViewModel()
        fetchEateryDetailIntroInfo(contentId: headerData!.contentId, contentType: headerData!.contentType)
        
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
        
        detailCollectionView.register(DetailCommonCell.self, forCellWithReuseIdentifier: DetailCommonCell.reuseIdentifier)
        detailCollectionView.register(DetailHeaderCell.self, forCellWithReuseIdentifier: DetailHeaderCell.reuseIdentifier)
        detailCollectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.reuseIdentifier)
    }
    
    
    private func reloadData() {
        
        guard let dataSource else {
            print("⚠️  dataSource 없음 - reloadData() 무시됨")
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<EateryFromDetailSection, EateryFromDetailType>()
        
        snapshot.appendSections([.header, .common, .detailImage])
        
        let headerInfo = EateryFromDetailHeader(
            contentId: headerData!.contentId,
            contentType: headerData!.contentType,
            eateryTitle: headerData?.eateryTitle ?? "상세 페이지",
            posterPath: headerData!.posterPath,
            cat3: headerData!.cat3)
        
        snapshot.appendItems([.header(headerInfo)], toSection: .header)
        snapshot.appendItems(detailViewModel.commonIntro.map { .common($0)}, toSection: .common)
        snapshot.appendItems(detailViewModel.detailImageList.map { .detailImage($0)}, toSection: .detailImage)
        
        //snapshot.appendItems(detailViewModel.detailIntro.map { .eateryInfo($0)}, toSection: .eateryInfo)
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<EateryFromDetailSection, EateryFromDetailType>(collectionView: detailCollectionView) { collectionView, indexPath, item in
            switch item {
            case .header(let header):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.reuseIdentifier, for: indexPath) as? DetailHeaderCell
                cell?.configure(headerData: header)
                return cell
            case .common(let common):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCommonCell.reuseIdentifier, for: indexPath) as? DetailCommonCell
                cell?.configure(with: common)
                return cell
                
            case .detailImage(let detailImage):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.reuseIdentifier, for: indexPath) as? DetailImageCell
                cell?.configure(with: detailImage)
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
                return self.createHeaderSection()
            case .common:
                return self.createCommonSection()
            case .detailImage:
                return self.createImageSection()
//            case .eateryInfo:
//                return self.createHeaderSection(using: self.headerData!)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    
//    private func createHeaderSection(using section: EateryFromDetailHeader) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 8
//        return section
//    }
    
    private func createHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        return section
    }
    
    
    private func createCommonSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        return section
    }
    
    
    private func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)

        return section
    }
}


// MARK: - Extension: 바인딩 함수

extension EateryDetailViewController {
    
    private func fetchEateryDetailIntroInfo(contentId: String, contentType: String) {
        
        Task {
            async let eateryInfo: () = detailViewModel.fetchDetailInfo(contentId: contentId, contentType: contentType)
            async let detailInfo: () = detailViewModel.fetchCommonIntroInfo(contentId: contentId)
            async let detailImage: () = detailViewModel.fetchDetailImageList(contentId: contentId)
            
            await eateryInfo
            await detailInfo
            await detailImage
        }
    }
    
    
    private func bindViewModel() {
        
        detailViewModel.$detailIntro
            .combineLatest(detailViewModel.$detailIntro)
            .combineLatest(detailViewModel.$detailImageList)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
}
