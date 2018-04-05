//
//  SearchViewModel.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/5/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit


protocol SearchViewModelDelegate {
    func updateView()
}

class SearchViewModel {
    
    let delegate: SearchViewModelDelegate
    
    var dataCount: Int { return dataSource.count}
    var dataLastIndex: Int { return dataCount - 1 }
    var isReady: Bool { return !loadingData }
    
    private let dataSourceFactory:TableDataSourcerMaker = YleTableDataSourcerFactory()
    private var dataSource: TableDataSourcer = EmptyTableDataSource()
    
    private var loadingData = false
    
    init(delegate: SearchViewModelDelegate){
        self.delegate = delegate
    }
    
    func search(for query: String) {
        dataSource = dataSourceFactory.make(query: query) { [weak self] in
            self?.loadingData = false
            self?.delegate.updateView()
        }
        loadData(amount: 20)
    }
    
    func getData(for index: Int) -> TvProgramm {
        return dataSource[index] as! TvProgramm
    }
    
    func loadMoreData() {
        loadData(amount: 20)
    }
    
    private func loadData(amount: Int) {
        loadingData = true
        dataSource.giveNext(20)
    }
}
