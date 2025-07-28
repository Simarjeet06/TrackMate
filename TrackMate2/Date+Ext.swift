//
//  Date+Ext.swift
//  TrackMate2
//
//  Created by Simarjeet Kaur on 28/07/25.
//

import Foundation

extension Date{
    func formatDate()->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.string(from: self)

    }
    }


