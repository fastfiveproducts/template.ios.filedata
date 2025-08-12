//
//  CaptureFormView.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      Template v0.1.2 (renamed) Fast Five Products LLC's public AGPL template.
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
import SwiftUI

struct CaptureFormView<T: Listable>: View {
    @ObservedObject var viewModel: CaptureFormViewModel<T>
    var showHeader: Bool = true

    @FocusState private var focusedFieldIndex: Int?

    private func nextField() {
        let nextIndex = (focusedFieldIndex ?? -1) + 1
        if nextIndex < viewModel.fields.count {
            focusedFieldIndex = nextIndex
        } else {
            if viewModel.isValid { viewModel.insert() }
            focusedFieldIndex = 0
        }
    }

    var body: some View {
        Section(header: showHeader ? Text(viewModel.title) : nil) {
            ForEach(viewModel.fields.indices, id: \.self) { i in
                displayLabeledTextField(atIndex: i)
            }

            Button("Submit") {
                viewModel.insert()
            }
            .disabled(!viewModel.isValid)
        }
    }

    private func displayLabeledTextField(atIndex i: Int) -> some View {
        LabeledContent {
            TextField(
                viewModel.fields[i].promptText,
                text: Binding(
                    get: { viewModel.fields[i].text },
                    set: { viewModel.fields[i].text = $0 }
                )
            )
            .textInputAutocapitalization(viewModel.fields[i].autoCapitalize ? .words : .never)
            .disableAutocorrection(true)
            .focused($focusedFieldIndex, equals: i)
            .onTapGesture { focusedFieldIndex = i }
            .onSubmit { nextField() }
        } label: {
            Text(viewModel.fields[i].labelText)
        }
        .labeledContentStyle(TopLabeledContentStyle())
    }
}


#if DEBUG
#Preview {
    Form {
        CaptureFormView(
            viewModel: TemplateStruct.makeCaptureFormViewModel(store: ListableFileStore<TemplateStruct>())
        )
    }
    .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
    .environment(\.font, Font.body)
}
#endif
