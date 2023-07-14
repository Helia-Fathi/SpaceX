//
//  Response.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/13/23.
//

import Foundation

struct SpaceXResponse: Decodable {
    let docs: [Launch]
    let totalDocs: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

struct Launch: Decodable {
    let name: String
    let flight_number: Int
    let details: String?
    let success: Bool?
    let links: Links
    let date_utc: String
}

struct Links: Decodable {
    let wikipedia: String?
    let patch: Patch
    let flickr: Flickr
}

struct Patch: Decodable {
    let small: String
    let large: String
}

struct Flickr: Decodable {
    let small: [String]
    let original: [String]
}

