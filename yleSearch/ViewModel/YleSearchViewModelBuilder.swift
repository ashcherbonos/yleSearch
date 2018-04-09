//
//  YleSearchViewModelBuilder.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/9/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import Foundation

struct YleSearchViewModelBuilder {
    
    func make(delegate: SearchViewModelDelegate) -> SearchViewModel {
        let networkManager = NetworkingManagerShared()
        let tableDataSourcerFactory = YleTableDataSourcerFactory(networkManager: networkManager)
        let cache = ImageCache()
        let imageLoaderFactory = ImageLoaderWithFadeInFactory(cache: cache, networkingManager: networkManager)
        return SearchViewModel(delegate: delegate, dataSourceFactory: tableDataSourcerFactory, imageLoaderFactory: imageLoaderFactory, cache: cache)
    }
}
