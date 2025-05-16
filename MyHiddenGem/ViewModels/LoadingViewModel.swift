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
    
    init(eateryVM: EateryViewModel, categoryVM: CategoryViewModel) {
        Publishers.CombineLatest(
            eateryVM.$isLoading,
            categoryVM.$isLoading
        )
            .map { $0 || $1 } // 하나라도 로딩 중이면 true
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }
}
