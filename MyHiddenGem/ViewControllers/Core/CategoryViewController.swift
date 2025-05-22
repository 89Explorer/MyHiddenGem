//
//  CategoryViewController.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/20/25.
//

import UIKit
import Combine

class CategoryViewController: UIViewController {
    
    // MARK: - Variable
    
    private var categoryCode: String = ""
    private var categoryName: String = ""
    private var pageNo: Int = 1
    
    private let categoriesViewModel: CategoryViewModel = CategoryViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    private var dataSource: UICollectionViewDiffableDataSource<EateryFromCategorySection, EateryFromCategoryType>?
    
    
    // MARK: - UI Component
    private var eateryCollectionView: UICollectionView!
    
    
    // MARK: - init
    
    init(code: String, name: String) {
        super.init(nibName: nil, bundle: nil)
        self.categoryCode = code
        self.categoryName = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        print("✅ 선택된 카테고리 이름: \(categoryName), 선택된 카테고리 코드: \(categoryCode)")
        
        setupNavigationBar()
        fetchEateryFromCategory()
        bindViewModel()
        
        setupCollectionView()
        createDataSource()
        
        eateryCollectionView.delegate = self
        categoriesViewModel.clearEateryData()
    }
    
}


// MARK: - Extension: 네비게이션 바 세팅

extension CategoryViewController {

    /// 네비게이션바 설정하는 함수
    func setupNavigationBar() {
        navigationItem.title = categoryName
 
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


// MARK: - CategoryViewController

extension CategoryViewController {
    
    
    /// 카테고리에 따른 음식점 리스트를 요청하는 메서드
    private func fetchEateryFromCategory() {
        
        Task {
            async let eateryList: () = categoriesViewModel.fetchEateryFromCategory(pageNo: "\(pageNo)", cat3: categoryCode)
            await eateryList
        }
    }
    
    /// 카테고리에 해당하는 음식점 리스트를 감지하는 메서드 
    private func bindViewModel() {
        
        categoriesViewModel.$eateryFromCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                //print("✅ 가져오기 성공! \(items.count) 개")
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
}


// MARK: - Extension: CollectionView 설멍

extension CategoryViewController {
    
    /// eateryCollectionView 설정하는 메서드
    private func setupCollectionView() {
        
        eateryCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompostionalLayout())
        eateryCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eateryCollectionView.backgroundColor = .systemBackground
        eateryCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(eateryCollectionView)
        
        eateryCollectionView.register(EateryFromCategoryCell.self, forCellWithReuseIdentifier: EateryFromCategoryCell.reuseIdentifier)
        
    }
    
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<EateryFromCategorySection, EateryFromCategoryType>()
        
        snapshot.appendSections([.category])
        
        snapshot.appendItems(categoriesViewModel.eateryFromCategory.map { .category($0) }, toSection: .category)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<EateryFromCategorySection, EateryFromCategoryType>(collectionView: eateryCollectionView) { collectionView, indexPath,   item in
            switch item {
            case .category(let eatery):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EateryFromCategoryCell.reuseIdentifier, for: indexPath) as? EateryFromCategoryCell
                cell?.configure(with: eatery)
                return cell
            }
        }
    }
    
    
    private func createCompostionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, environment in
            let sectionIdentifier = EateryFromCategorySection.allCases[sectionIndex]
            
            switch sectionIdentifier {
            case .category:
                return self.createFeaturedSection(using: self.categoriesViewModel.eateryFromCategory)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    
    private func createFeaturedSection(using section: [EateryItem]) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.97 / 2.0), heightDimension: .fractionalHeight(1.0))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(210.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem, layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        return  layoutSection
    }
}


// MARK: - Extension: 데이터를 가져오는 페이징 기능 설정
extension CategoryViewController: UICollectionViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffsetY = scrollView.contentOffset.y
//        let collectionViewHeight = eateryCollectionView.contentSize.height
//        let pagination = collectionViewHeight * 0.45
//        
//        if contentOffsetY > collectionViewHeight - pagination && !categoriesViewModel.isLoading {
//            pageNo += 1
//            fetchEateryFromCategory()
//        }
//    }
    
    
    // ✅ 마지막 셀 감지해서 데이터 요청하기
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemCount = categoriesViewModel.eateryFromCategory.count
        
        if indexPath.item == itemCount - 1 && !categoriesViewModel.isLoading {
            pageNo += 1
            fetchEateryFromCategory()
        }
    }

}
