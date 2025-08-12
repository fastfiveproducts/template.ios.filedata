//
//  CaptureFormViewModel.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      Template v0.1.2 (moved from another Template v0.1.1 file) Fast Five Products LLC's public AGPL template.
//
//  Copyright © 2025 Fast Five Products LLC. All rights reserved.
//
//  This file is part of a project licensed under the GNU Affero General Public License v3.0.
//  See the LICENSE file at the root of this repository for full terms.
//
//  An exception applies: Fast Five Products LLC retains the right to use this code and
//  derivative works in proprietary software without being subject to the AGPL terms.
//  See LICENSE-EXCEPTIONS.md for details.
//
//  For licensing inquiries, contact: licenses@fastfiveproducts.llc
//


import Foundation

@MainActor
class CaptureFormViewModel<T: Listable>: ObservableObject {
    @Published var fields: [CaptureField]

    let title: String
    private let makeStruct: ([CaptureField]) -> T
    private let insertAction: (T) -> Void

    init(
        title: String,
        fields: [CaptureField],
        makeStruct: @escaping ([CaptureField]) -> T,
        insertAction: @escaping (T) -> Void
    ) {
        self.title = title
        self.fields = fields
        self.makeStruct = makeStruct
        self.insertAction = insertAction
    }

    var isValid: Bool {
        fields.allSatisfy { $0.isValid }
    }

    func insert() {
        let newItem = makeStruct(fields)
        insertAction(newItem)
    }
}

