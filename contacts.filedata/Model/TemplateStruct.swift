//
//  TemplateStruct.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      Template v0.1.2 Fast Five Products LLC's public AGPL template.
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
//  READ and Delete when using template:
//
//     TemplateStruct: is a sample of a struct that is then later used in the app
//     and persisted locally using FileManager
//
//     Also note other examples/samples:
//     "Announcement" in this app is ready-only and sourced from Firebase Firestore
//     "User" in this app is a mix of Firebase Authentication and Firebase Data Connect
//     "Post" in this app is read-write and stored via Firebase Data Connect
//


import Foundation

struct TemplateStruct: Listable {
    var id = UUID()
    
    // attributes
    var passwordHint: String
    var favoriteColor: String
    var dogName: String

    // to conform to Listable, use known data to describe the object
    var objectDescription: String {
        "Hint: \(passwordHint), Color: \(favoriteColor), Dog: \(dogName)"
    }
    
    // add a helper to determine if a particular struct instance is valid
    var isValid: Bool {
        guard !favoriteColor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !dogName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            debugprint("validation failed.")
            return false
        }
        return true
    }
}

// to conform to Listable, add placeholder features --
// some patterns use a 'placeholder' until/if data is available
extension TemplateStruct {

    static let usePlaceholder = false
    static let placeholder = TemplateStruct(passwordHint: "", favoriteColor: "", dogName: "")
}

// create a CaptureForm ViewModel Fatory so this struct is capturable
extension TemplateStruct {
    @MainActor static func makeCaptureFormViewModel(store: ListableFileStore<TemplateStruct>) -> CaptureFormViewModel<TemplateStruct> {
        CaptureFormViewModel(
            title: "Sample Form",
            fields: [
                CaptureField(id: "passwordHint", labelText: "Password Hint", promptText: "optional: Password Hint", required: false, autoCapitalize: false, checkRestrictedWordList: false),
                CaptureField(id: "favoriteColor", labelText: "Favorite Color", promptText: "required: Favorite Color"),
                CaptureField(id: "dogName", labelText: "Dog's Name", promptText: "required: Your Dog's Name")
            ],
            makeStruct: { fields in
                let dict = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, $0) })
                return TemplateStruct(
                    passwordHint: dict["passwordHint"]?.text ?? "",
                    favoriteColor: dict["favoriteColor"]?.text ?? "",
                    dogName: dict["dogName"]?.text ?? ""
                )
            },
            insertAction: { item in
                store.insert(item)
            }
        )
    }
}


#if DEBUG
extension TemplateStruct {
    static let testObject = TemplateStruct(
        passwordHint: "Sunshine",
        favoriteColor: "Blue",
        dogName: "Daisy"
    )
}
#endif
