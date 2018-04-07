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
    func fill(withData: TvProgramm, imageLoader: ImageLoader)
}

class SearchViewModel {
    
    var dataCount: Int { return dataSource.count}
    var dataLastIndex: Int { return dataCount - 1 }
    var isReady: Bool { return !loadingData }
    
    private weak var delegate: SearchViewModelDelegate?
    private let dataSourceFactory:TableDataSourcerMaker = YleTableDataSourcerFactory()
    private var dataSource: TableDataSourcer = TableDataSourceNullObject()
    private var loadingData = false
    private let imageCache: ImageCacher
    
    init(delegate: SearchViewModelDelegate){
        self.delegate = delegate
        imageCache = ImageCach()
    }
    
    func search(for query: String) {
        dataSource = dataSourceFactory.make(query: query) { [weak self] in
            self?.loadingData = false
            self?.delegate?.updateView()
        }
        loadData()
    }
    
    func getData(for index: Int) -> TvProgramm {
        return dataSource[index] as! TvProgramm
    }
    
    func loadMoreData() {
        loadData()
    }
    
    private func loadData() {
        loadingData = true
        dataSource.loadData(amount: AppConstants.searchLimit)
    }
    
    func fill(consumer: DataConsumer, withIndex index: Int){
        let imageLoader = ImageLoader(cache: imageCache)
        consumer.fill(withData: getData(for: index), imageLoader: imageLoader)
    }
    
    func  didReceiveMemoryWarning() {
        imageCache.empty()
    }
}
