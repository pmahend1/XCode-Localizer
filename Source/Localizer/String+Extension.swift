//
//  String+Extension.swift
//  Localizer
//
//  Created by Prateek Mahendrakar on 5/17/23.
//

import Foundation

extension String {
   var lowercasingFirst: String { prefix(1).lowercased() + dropFirst() }
   var uppercasingFirst: String { prefix(1).uppercased() + dropFirst() }

   var camelCased: String {
      guard !isEmpty else { return "" }
      let parts = components(separatedBy: .alphanumerics.inverted)
      let first = parts.first!.lowercasingFirst
      let rest = parts.dropFirst().map { $0.uppercasingFirst }

      return ([first] + rest).joined()
   }
}
