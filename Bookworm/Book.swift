//
//  Book.swift
//  Bookworm
//
//  Created by 임지성 on 4/25/24.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var isRating1: Bool {
        if rating == 1 {
            return true
        }
        return false
    }
    var date = Date.now
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
    
    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
