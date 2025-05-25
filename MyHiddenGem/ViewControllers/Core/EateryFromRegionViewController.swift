//
//  EateryFromRegionViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/22/25.
//

import UIKit
import Combine


class EateryFromRegionViewController: UIViewController {
    
    
    // MARK: - Variable
    private var selectedCategoryCode: String? = ""
    private var regionCode: String = ""
    private var regionName: String = ""
    private var pageNo: Int = 1
    
    private let regionViewModel: RegionViewModel = RegionViewModel()
    private let categoryViewModel: CategoryViewModel = CategoryViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var dataSource: UICollectionViewDiffableDataSource<EateryFromRegionSection, EateryFromRegionType>?
    
    
    // MARK: - UI Component
    
    private var eateryCollectionView: UICollectionView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    // MARK: - Init
    
    init(regionCode: String, regionName: String) {
        super.init(nibName: nil, bundle: nil)
        self.regionCode = regionCode
        self.regionName = regionName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        fetchEateryFromRegion()
        bindViewModel()
        bindLoading()
        
        setupCollectionView()
        createDataSource()
        
        eateryCollectionView.delegate = self

    }
}


// MARK: - Extension: 네비게이션 바 세팅

extension EateryFromRegionViewController {
    
    /// 네비게이션바 설정하는 함수
    func setupNavigationBar() {
        navigationItem.title = regionName
        
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


// MARK: - Extension: 바인딩 함수
extension EateryFromRegionViewController {
    
    
    /// 외부 API를 통해 지역 내 음식점 리스트를 받아오는 메서드
    private func fetchEateryFromRegion(categoryCode: String? = nil) {
        
        guard let areaCode = Int(regionCode) else { return }
        
        Task {
            
            async let eateryList: () = regionViewModel.fetchEateryFromRegion(pageNo:"\(pageNo)", areaCode: areaCode, categoryCode: categoryCode )
            async let categoriesFetch: () = categoryViewModel.fetchCategories()
            
            await categoriesFetch
            categoryViewModel.updateCategories()
            await eateryList
            
        }
        
    }
    
    /// 받아온 음식점 리스트를 감지하는 메서드
    private func bindViewModel() {
        
        regionViewModel.$eateryFromRegion
            .combineLatest(categoryViewModel.$emojiCategories)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    /// 데이터 로딩 중에는 인디게이터를 보여주는 메서드
    private func bindLoading() {
        regionViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    //self?.eateryCollectionView.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                    //self?.eateryCollectionView.isHidden = false
                    //self?.eateryCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
}


// MARK: - Extension: CollectionView 설정

extension EateryFromRegionViewController {
    
    
    /// eateryCollectionView 설정하는 메서드
    private func setupCollectionView() {
        
        eateryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompostionalLayout())
        eateryCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eateryCollectionView.backgroundColor = .systemBackground
        eateryCollectionView.showsHorizontalScrollIndicator = false
        eateryCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(eateryCollectionView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = view.center
        
        eateryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        eateryCollectionView.register(EateryFromCategoryCell.self, forCellWithReuseIdentifier: EateryFromCategoryCell.reuseIdentifier)
        
    }
    
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<EateryFromRegionSection, EateryFromRegionType>()
        
        snapshot.appendSections([.category, .region])
        
        snapshot.appendItems(regionViewModel.eateryFromRegion.map { .region($0)}, toSection: .region)
        snapshot.appendItems(categoryViewModel.emojiCategories.map {.category($0)}, toSection: .category)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<EateryFromRegionSection, EateryFromRegionType>(collectionView: eateryCollectionView) { collectionView, indexPath,   item in
            switch item {
                
            case .category(let category):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell
                let emojiCategory = "\(category.icon) \(category.name)"
                cell?.configure(with: emojiCategory)
                return cell
                
            case .region(let eatery):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EateryFromCategoryCell.reuseIdentifier, for: indexPath) as? EateryFromCategoryCell
                cell?.configure(with: eatery)
                return cell
                
            }
        }
    }
    
    
    private func createCompostionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, environment in
            let sectionIdentifier = EateryFromRegionSection.allCases[sectionIndex]
            
            switch sectionIdentifier {
            case .category:
                return self.createCategorySection(using: self.categoryViewModel.categories)
            case .region:
                return self.createFeaturedSection(using: self.regionViewModel.eateryFromRegion)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return section
    }
    
    
    private func createFeaturedSection(using section: [EateryItem]) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.0), heightDimension: .fractionalHeight(1.0))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(210.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem, layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        return  layoutSection
    }
}


// MARK: - Extension: 데이터를 가져오는 페이징 기능 설정

extension EateryFromRegionViewController: UICollectionViewDelegate {
    
    // ✅ 마지막 셀 감지해서 데이터 요청하기
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemCount = regionViewModel.eateryFromRegion.count
        
        if indexPath.item == itemCount - 1 && !regionViewModel.isLoading {
            pageNo += 1
            fetchEateryFromRegion(categoryCode: selectedCategoryCode)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        switch selectedItem {
        case .category(let category):
            print("선택된 카테고리 코드: \(category.code)")
            selectedCategoryCode = category.code
            pageNo = 1
            regionViewModel.clearEateryData()
            fetchEateryFromRegion(categoryCode: category.code)
            
            
            
        case .region(let eatery):
            print("선택되 음식점 정보: \(eatery.title)")
        }
    }
}
