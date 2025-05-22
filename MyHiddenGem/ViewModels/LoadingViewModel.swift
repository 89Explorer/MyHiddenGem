//
//  LoadingViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/17/25.
//

import Foundation
import Combine


@MainActor
final class LoadingViewModel {
    @Published var isLoading: Bool = true

    private var cancellables = Set<AnyCancellable>()

    init(eateryVM: EateryViewModel, categoryVM: CategoryViewModel, regionVM: RegionViewModel) {
        Publishers.CombineLatest3(
            eateryVM.$isLoading,
            categoryVM.$isLoading,
            regionVM.$isLoading
        )
        .map { $0 || $1 || $2 } // 하나라도 로딩 중이면 true
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            self?.isLoading = value
        }
        .store(in: &cancellables)
    }
    
    
}
