//
//  HomeViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 4/23/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Variable
    
    private let categoriesViewModel: CategoryViewModel = CategoryViewModel()
    private let eateriesViewModel: EateryViewModel = EateryViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private var dataSource: UICollectionViewDiffableDataSource<EaterySection, EateryItemType>?
    
    
    // MARK: - UI Componnets
    
    private var recommendationCollectionView: UICollectionView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupHeaderView(with: "투데이")
        setupHeaderButtons()
        
        bindViewModel()
        fetchCategories()
        
        setupCollectionView()
        createDataSource()
    }
    
    
    // MARK: - Functions
    
    /// recommendationCollectionView UI 셋팅 메서드
    private func setupCollectionView() {
        
        recommendationCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompostionalLayout())
        recommendationCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        recommendationCollectionView.backgroundColor = .systemBackground
        recommendationCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(recommendationCollectionView)
        
        recommendationCollectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: RecommendationCell.reuseIdentifier)
        recommendationCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        
    }
    
    /// 컬렉션 뷰에 표시할 데이터를 구성하고 적용하는 메서드
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<EaterySection, EateryItemType>()
        
        snapshot.appendSections([.category, .list])
        snapshot.appendItems(categoriesViewModel.emojiCategories.map { .category($0) }, toSection: .category)
        snapshot.appendItems(eateriesViewModel.eateries.map { .eatery($0) }, toSection: .list)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<EaterySection, EateryItemType>(collectionView: recommendationCollectionView) { collectionView, indexPath, item in
            
            switch item {
                
            case .eatery(let eatery):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCell.reuseIdentifier, for: indexPath) as? RecommendationCell
                cell?.configure(with: eatery)
                return cell
                
            case .category(let category):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell
                
                let emojiCategory = "\(category.icon) \(category.name)"
                
                cell?.configure(with: emojiCategory)
                return cell
            }
            
        }
    }
    
    /// recommendationCollectionView 통합 UI 관리하는 메서드
    private func createCompostionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let sectionIdentifier = EaterySection.allCases[sectionIndex]
            
            switch sectionIdentifier {
            case .category:
                return self.createCategorySection(using: self.categoriesViewModel.categories)
                
            case .list:
                return self.createFeaturedSection(using: self.eateriesViewModel.eateries)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    /// 오늘의 음식점 정보 UI를 담당하는 메서드
    private func createFeaturedSection(using section: [EateryItem]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(300))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        return layoutSection
    }
    
    /// 음식점 카테고리 UI를 담당하는 메서드
    private func createCategorySection(using section: [StoreCategory]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .absolute(35)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .absolute(35)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
}


// MARK: - Extension: 홈화면 상단 View

extension HomeViewController {
    
    /// 홈 화면 상단 뷰 설정
    func setupHeaderView(with title: String) {
        let titleLabel: UILabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .label
        
        let leftBarButton = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    /// 홈 화면 상단 오른쪽 버튼 설정 (검색, 알람)
    func setupHeaderButtons() {
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .label
        searchButton.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        
        let alarmButton = UIButton(type: .system)
        alarmButton.setImage(UIImage(systemName: "bell"), for: .normal)
        alarmButton.tintColor = .label
        alarmButton.addTarget(self, action: #selector(didTappedAlarmButton), for: .touchUpInside)
        
        let alarmBarButton = UIBarButtonItem(customView: alarmButton)
        
        navigationItem.rightBarButtonItems = [alarmBarButton, searchBarButton]
    }
    
    
    // MARK: - Actions
    
    /// 검색 버튼을 누르면 동작하는 액션 메서드
    @objc private func didTappedSearchButton() {
        print("검색 버튼을 눌름")
    }
    
    
    /// 알람 버튼을 누르면 동작하는 액션 메서드
    @objc private func didTappedAlarmButton() {
        print("알람 버튼을 눌름")
    }
}


// MARK: - Extension: 바인딩 함수

extension HomeViewController {
    
    // MARK: - Functions
    
    /// 음식점 리스트를 담고 있는 배열을 바인딩 하는 메서드
    private func bindViewModel() {
        
        Publishers.CombineLatest(
            categoriesViewModel.$emojiCategories,
            eateriesViewModel.$eateries
            )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _, _ in
            self?.reloadData()
        }
        .store(in: &cancellables)
        
    }
    
    /// 음식점 리스트를 외부에서 요청하는 메서드
    private func fetchCategories() {
        
        // 각각의 함수가 독립적으로 실행
        Task {
            async let categoriesFetch: () = categoriesViewModel.fetchCategories()
            async let eateriesFetch: () = eateriesViewModel.fetchEateries()
            
            await categoriesFetch
            categoriesViewModel.updateCategories()
            
            await eateriesFetch
            //print("🍛 음식점 목록:")
            //eateriesViewModel.eateries.forEach { print("- \($0.title)") }
        }
    }
}
