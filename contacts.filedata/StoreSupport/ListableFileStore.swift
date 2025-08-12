//
//  ListableFileStore.swift
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


import Foundation

@MainActor
class ListableFileStore<T: Listable>: ListableStore {
    
    @Published var list: Loadable<[T]> = .none
    
    private let filename: String
    private let fileManager = FileManager.default
    
    init(filename: String = "\(T.typeDescription).json") {
        self.filename = filename
        load()
    }

    // MARK: - Load previously-Saved items
    func load() {
        Task {
            list = .loading
            do {
                let url = fileURL()
                guard fileManager.fileExists(atPath: url.path) else {
                    list = .loaded([])
                    return
                }
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([T].self, from: data)
                list = .loaded(decoded)
            } catch {
                list = .error(error)
            }
        }
    }

    // MARK: - Insert item and Save
    func insert(_ item: T) {
        Task {
            switch list {
            case .loaded(let currentItems):
                await replaceWithList([item] + currentItems)
            default:
                await replaceWithList([item])
            }
        }
    }
    
    // MARK: - Update item and Save
    func update(_ item: T) {
        Task {
            guard case .loaded(let currentItems) = list else { return }
            let updated = currentItems.map { $0.id == item.id ? item : $0 }
            await replaceWithList(updated)
        }
    }

    // MARK: - Delete item and Save
    func delete(_ item: T) {
        Task {
            guard case .loaded(let currentItems) = list else { return }
            let updated = currentItems.filter { $0.id != item.id }
            await replaceWithList(updated)
        }
    }

    // MARK: - Delete all items and Save
    func deleteAll() {
        Task {
            await replaceWithList([])
        }
    }

    // MARK: - private update stored list, save list to disk
    private func replaceWithList(_ items: [T]) async {
        do {
            try saveToDisk(items)
            list = .loaded(items)
        } catch {
            list = .error(error)
        }
    }

    private func saveToDisk(_ items: [T]) throws {
        let url = fileURL()
        let data = try JSONEncoder().encode(items)
        try data.write(to: url, options: .atomic)
    }

    private func fileURL() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    }
}
