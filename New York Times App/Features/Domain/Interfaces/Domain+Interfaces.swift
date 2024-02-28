//
//  Domain+Interfaces.swift
//  New York Times App
//
//  Created by Iñigo Alonso on 2/1/22.
//

import Foundation

protocol FetchPostsRepository {
    func fetchPosts(parameters: FetchPostsRespositoryParameters) async throws -> PostsDecodable
}
