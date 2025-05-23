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
    private let regionCodeViewModel: RegionViewModel = RegionViewModel()
    private var loadingViewModel: LoadingViewModel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var dataSource: UICollectionViewDiffableDataSource<EaterySection, EateryItemType>?
    
    
    // MARK: - UI Componnets
    
    private var recommendationCollectionView: UICollectionView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupHeaderView(with: "투데이")
        setupHeaderButtons()
        
        bindLoading()
        
        bindViewModel()
        fetchCategories()
        
        setupCollectionView()
        createDataSource()
        
        recommendationCollectionView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // CategoryCell 내에 라베을 선택한 것을 초기화
        recommendationCollectionView.indexPathsForSelectedItems?.forEach { recommendationCollectionView.deselectItem(at: $0, animated: false)
        }
    }
    
    
    // MARK: - Functions
    
    /// recommendationCollectionView UI 셋팅 메서드
    private func setupCollectionView() {
        
        recommendationCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompostionalLayout())
        recommendationCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        recommendationCollectionView.backgroundColor = .systemBackground
        recommendationCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(recommendationCollectionView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = view.center
        
        recommendationCollectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: RecommendationCell.reuseIdentifier)
        
        recommendationCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        
        recommendationCollectionView.register(GyeonggiCell.self, forCellWithReuseIdentifier: GyeonggiCell.reuseIdentifier)
        
        recommendationCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
    }
    
    
    /// 컬렉션 뷰에 표시할 데이터를 구성하고 적용하는 메서드
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<EaterySection, EateryItemType>()
        
        snapshot.appendSections([.category, .list, .gyeonggido, .seoul, .incheon, .regionCode])
        
        snapshot.appendItems(categoriesViewModel.emojiCategories.map { .category($0) }, toSection: .category)
        snapshot.appendItems(eateriesViewModel.eateries.map { .eatery($0) }, toSection: .list)
        snapshot.appendItems(eateriesViewModel.gyeonggiEateries.map { .gyeonggido($0)}, toSection: .gyeonggido)
        snapshot.appendItems(eateriesViewModel.seoulEateries.map { .seoul($0)}, toSection: .seoul)
        snapshot.appendItems(eateriesViewModel.incheonEateries.map { .incheon($0)}, toSection: .incheon)
        snapshot.appendItems(regionCodeViewModel.regionList.map { .regionCode($0)} ,toSection: .regionCode)
        
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
                
            case .gyeonggido(let gyeonggido):
                let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: GyeonggiCell.reuseIdentifier, for: indexPath) as? GyeonggiCell
                
                cell?.configure(with: gyeonggido)
                return cell
                
            case .seoul(let seoul):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GyeonggiCell.reuseIdentifier, for: indexPath) as? GyeonggiCell
                
                cell?.configure(with: seoul)
                return cell
                
            case .incheon(let incheon):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GyeonggiCell.reuseIdentifier, for: indexPath) as? GyeonggiCell
                
                cell?.configure(with: incheon)
                return cell
            case .regionCode(let region):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell
                cell?.configure(with: region.name)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            
            // ✅ 헤더 뷰 dequeue
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseIdentifier,
                for: indexPath
            ) as? SectionHeader else {
                return nil
            }
            
            
            // 섹션 번호 -> EaterySection 변환
            guard let section = EaterySection(rawValue: indexPath.section) else { return nil }
            
            // 특정 섹션에는 헤더 안보이게 처리
            switch section {
            case .category, .list:
                return nil
            case .gyeonggido:
                sectionHeader.configure(main: "부대찌개만 있는게 아니죠 🙅", sub: "다양한 음식이 있는 도시, 경기도")
                return sectionHeader
            case .seoul:
                sectionHeader.configure(main: "남산돈가스 또 먹어요? 🤷", sub: "먹을게 넘치는 도시, 서울")
                return sectionHeader
            case .incheon:
                sectionHeader.configure(main: "젓국갈비 먹어봤어요? 🙆", sub: "짜장면, 쫄면의 도시, 인천")
                return sectionHeader
            case .regionCode:
                sectionHeader.configure(main: "지역 구분 🌐", sub: "지역별 음식점 소개")
                return sectionHeader
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
                
            case .gyeonggido:
                return self.createMediumSection(using: self.eateriesViewModel.gyeonggiEateries)
                
            case .seoul:
                return self.createMediumSection(using: self.eateriesViewModel.seoulEateries)
                
            case .incheon:
                return self.createMediumSection(using: self.eateriesViewModel.incheonEateries)
                
            case .regionCode:
                return self.createRegionSection(using: self.regionCodeViewModel.regionList)
                
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
    
    ///  지역별 음식점 소개 UI를 담당하는 메서드
    private func createMediumSection(using section: [EateryItem]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.97), heightDimension: .fractionalHeight(0.33))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    
    /// 지역 구분 소개 UI를 담당하는 메서드
    private func createRegionSection(using section: [RegionCodeModel]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.97 / 2.0), heightDimension: .fractionalHeight(1.0))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(45)
        )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [layoutItem, layoutItem] )
        
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.93),
            heightDimension: .estimated(150)
        )
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [horizontalGroup, horizontalGroup, horizontalGroup]
        )
        
        let layoutSection = NSCollectionLayoutSection(group: verticalGroup)
        layoutSection.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
        
        
        layoutSection.boundarySupplementaryItems = [createSectionHeader()]
        return layoutSection
    }

    
    /// 각 섹션 헤더 UI를 담당하는 메서드
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return layoutSectionHeader
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
    
    /// ViewModel의 데이터 변경 시 CollectionView Snapshot 갱신
    private func bindViewModel() {
        
        categoriesViewModel.$emojiCategories
            .combineLatest(eateriesViewModel.$eateries)
            .combineLatest(eateriesViewModel.$gyeonggiEateries)
            .combineLatest(eateriesViewModel.$seoulEateries)
            .combineLatest(eateriesViewModel.$incheonEateries)
            .combineLatest(regionCodeViewModel.$regionList)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
    }
    
    /// 각 ViewModel에서 데이터를 받았는지 여부를 isLoading에 저장, 비교하여 감지하는 메서드
    private func bindLoading() {
        loadingViewModel = LoadingViewModel(
            eateryVM: eateriesViewModel,
            categoryVM: categoriesViewModel,
            regionVM: regionCodeViewModel
        )
        
        loadingViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.recommendationCollectionView.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.recommendationCollectionView.isHidden = false
                    self?.recommendationCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    /// 음식점 리스트를 외부에서 요청하는 메서드
    private func fetchCategories() {
        
        // 각각의 함수가 독립적으로 실행
        Task {
            async let categoriesFetch: () = categoriesViewModel.fetchCategories()
            async let eateriesFetch: () = eateriesViewModel.fetchEateries()
            async let regionFetch: () = regionCodeViewModel.fetchRegionCode()
            
            await categoriesFetch
            categoriesViewModel.updateCategories()
            await eateriesFetch
            await regionFetch
        }
    }
}


// MARK: - Extension: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let seletedItem = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch seletedItem {
            
        case .category(let category):
            
            
            let categoryVC = CategoryViewController(code: category.code, name: category.name)
            navigationController?.pushViewController(categoryVC, animated: true)
            
        case .eatery(let eatery):
            print("선택된 음식점: \(eatery.title)")
        case .gyeonggido(let gyeonggido):
            print("선택된 경기도 음식점: \(gyeonggido.title)")
        case .incheon(let incheon):
            print("선택된 인천 음식점: \(incheon.title)")
        case .seoul(let seoul):
            print("선택된 서울 음식점: \(seoul.title)")
        case .regionCode(let region):

            let regionVC = EateryFromRegionViewController(regionCode: region.code, regionName: region.name)
            navigationController?.pushViewController(regionVC, animated: true)
                    
        }
    }
}
