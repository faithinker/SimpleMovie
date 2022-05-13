//
//  MovieModel.swift
//  Basic
//
//  Created by pineone on 2022/04/14.
//

import UIKit

// MARK: - MovieResponse 공통 리스폰스
struct MovieResponse: Codable {
    let status, statusMessage: String
    let data: MovieListModel // Any
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case data
        case meta = "@meta"
    }
}

// MARK: - MovieListModel
struct MovieListModel: Codable {
    let movieCount, limit, pageNumber: Int
    let movieList: [Movie]

    enum CodingKeys: String, CodingKey {
        case movieCount = "movie_count"
        case limit
        case pageNumber = "page_number"
        case movieList = "movies"
    }
}

struct Movie: Codable {
    let title: String
    let rating: Double
}

// MARK: - Torrent
struct Torrent: Codable {
    let url: String
    let hash, quality, type: String
    let seeds, peers: Int
    let size: String
    let sizeBytes: Int
    let dateUploaded: String
    let dateUploadedUnix: Int

    enum CodingKeys: String, CodingKey {
        case url, hash, quality, type, seeds, peers, size
        case sizeBytes = "size_bytes"
        case dateUploaded = "date_uploaded"
        case dateUploadedUnix = "date_uploaded_unix"
    }
}


// MARK: - Meta
struct Meta: Codable {
    let serverTime: Int
    let serverTimezone: String
    let apiVersion: Int
    let executionTime: String

    enum CodingKeys: String, CodingKey {
        case serverTime = "server_time"
        case serverTimezone = "server_timezone"
        case apiVersion = "api_version"
        case executionTime = "execution_time"
    }
}
