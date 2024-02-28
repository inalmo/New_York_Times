//
//  RadioFilter+Model.swift
//  New York Times App
//
//  Created by Iñigo Alonso on 1/1/22.
//

import Foundation

enum FilterTypes {
    case period, postType, mostSharedType
}

struct PostFiltersModel {
    let filterName: String
    let filterType: FilterTypes
    let filterValue: String
    let isFilterSelected: Bool
}
