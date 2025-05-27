//
//  DetailLoadingViewModel.swift
//  MyHiddenGem
//
//  Created by 권정근 on 5/27/25.
//

import Foundation
import Combine


@MainActor
final class DetailLoadingViewModel {
    
    @Published var isLoading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init(detailVM: DetailViewModel) {
        Publishers.CombineLatest3(
            detailVM.$isIntroLoading,
            detailVM.$isImageLoading,
            detailVM.$isCommonLoading
        )
        .map { $0 && $1 && $2 }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] value in
            self?.isLoading = value
        }
        .store(in: &cancellables)
    }

}
