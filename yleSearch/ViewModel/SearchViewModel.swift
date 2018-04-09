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
  
    var dataCount: Int { return dataSource.count}
    var dataLastIndex: Int { return dataCount - 1 }
    var isReady: Bool { return !loadingData }
    
    weak var delegate: SearchViewModelDelegate?
    private let dataSourceFactory:TableDataSourcerMaker
    private var loadingData = false
    private let imageLoaderFactory: ImageLoaderMaker
    private let cache: ImageCacher
    
    // MARK: - Model
    private var dataSource: TableDataSource
    
    init(delegate: SearchViewModelDelegate, dataSourceFactory: TableDataSourcerMaker, imageLoaderFactory: ImageLoaderMaker, cache: ImageCacher){
        dataSource = TableDataSourceNullObject()
        self.dataSourceFactory = dataSourceFactory
        self.imageLoaderFactory = imageLoaderFactory
        self.cache = cache
        self.delegate = delegate
    }
    
    func search(for query: String) {
        dataSource = dataSourceFactory.make(query: query) { [weak self] in
            self?.loadingData = false
            self?.delegate?.updateView()
        }
        loadData()
    }
    
    func loadMoreData() {
        loadData()
    }
    
    func fill(consumer: DataConsumer, withIndex index: Int){
        let imageLoader = imageLoaderFactory.make()
        consumer.fill(withData: dataSource[index], imageLoader: imageLoader)
    }
    
    func  emptyMemory() {
        cache.empty()
    }
    
    private func loadData() {
        loadingData = true
        dataSource.loadData(amount: AppConstants.searchLimit)
    }
}
