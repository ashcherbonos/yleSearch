//
//  SearchViewModel.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/5/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

protocol SearchViewModelDelegate: class {
    func updateView()
}

protocol DataConsumer {
    func fill(withData: CellDataSource, imageLoader: ImageLoader)
}

class SearchViewModel {

    typealias ConcreteSourcerFactory = AppConstants.Dependencies.ConcreteSourcerFactory
    typealias ConcreteImageLoader = AppConstants.Dependencies.ConcreteImageLoader
    typealias ConcreteImageCacher = AppConstants.Dependencies.ConcreteImageCacher
    typealias ConcreteNetworkingManager = AppConstants.Dependencies.ConcreteNetworkingManager
    
    var dataCount: Int { return dataSource.count}
    var dataLastIndex: Int { return dataCount - 1 }
    var isReady: Bool { return !loadingData }
    
    private weak var delegate: SearchViewModelDelegate?
    private let networkManager: NetworkingManager
    private let dataSourceFactory:TableDataSourcerMaker
    private var dataSource: TableDataSource
    private var loadingData = false
    private let imageCache: ImageCacher
    
    init(delegate: SearchViewModelDelegate){
        self.delegate = delegate
        dataSource = TableDataSourceNullObject()
        imageCache = ConcreteImageCacher()
        networkManager =  ConcreteNetworkingManager()
        dataSourceFactory = ConcreteSourcerFactory(networkManager: networkManager)
    }
    
    func search(for query: String) {
        dataSource = dataSourceFactory.make(query: query) { [weak self] in
            self?.loadingData = false
            self?.delegate?.updateView()
        }
        loadData()
    }
    
    func getData(for index: Int) -> CellDataSource {
        return dataSource[index]
    }
    
    func loadMoreData() {
        loadData()
    }
    
    private func loadData() {
        loadingData = true
        dataSource.loadData(amount: AppConstants.searchLimit)
    }
    
    func fill(consumer: DataConsumer, withIndex index: Int){
        let imageLoader = ConcreteImageLoader(cache: imageCache, networkingManager: networkManager)
        consumer.fill(withData: getData(for: index), imageLoader: imageLoader)
    }
    
    func  emptyMemory() {
        imageCache.empty()
    }
}
