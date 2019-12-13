//
//  Created by Timothy Rascher on 12/12/19.
//  Copyright © 2019 California State Lottery. All rights reserved.
//

import Foundation

public extension String {
    var date: Date? { date(with: .storage) }
    func date(with format: Date.StringFormats) -> Date? {
        func formatDate(with format: String) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.date(from: self)
        }
        return formatDate(with: format.all) ?? formatDate(with: format.date) ?? formatDate(with: format.time)
    }
}
