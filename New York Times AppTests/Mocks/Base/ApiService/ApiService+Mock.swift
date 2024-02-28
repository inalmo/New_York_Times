//
//  ApiService+Mock.swift
//  New York Times AppTests
//
//  Created by Iñigo Alonso on 15/1/22.
//

import Foundation
@testable import New_York_Times_App


class MockFailureApiService: ApiService {
    func getDataFromGetRequest(with url: String) async throws -> Data {
        throw AppError.missingData
    }
}
