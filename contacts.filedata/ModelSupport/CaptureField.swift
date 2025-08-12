//
//  CaptureField.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      Template v0.1.2 (renamed and split-out from TextCaptureSectionView) Fast Five Products LLC's public AGPL template.
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

struct CaptureField: Identifiable {
    var id: String            // this will be the 'name' of the field; 'id' ensures conformance to Identifiable
    var labelText: String
    var promptText: String
    var text: String = ""
    var required: Bool = true
    var autoCapitalize: Bool = true
    var checkRestrictedWordList: Bool = true

    var isValid: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !required
    }
}
