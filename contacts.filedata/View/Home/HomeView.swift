//
//  HomeView.swift
//
//  Template created by Pete Maiser, July 2024 through May 2025
//      Template v0.1.4 (updated) Fast Five Products LLC's public AGPL template.
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


import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var currentUserService: CurrentUserService
    @ObservedObject var announcementStore: AnnouncementStore
    @ObservedObject var publicCommentStore: PublicCommentStore
    @ObservedObject var privateMessageStore: PrivateMessageStore
    @ObservedObject var templateStructStore = ListableFileStore<TemplateStruct>()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: -- Announcements
                    VStackBox(title: "Announcements") {
                        ListableStoreView(store: announcementStore)
                            .padding(.horizontal)

                        if !currentUserService.isSignedIn {
                            Divider().padding(.horizontal)
                            NavigationLink {
                                UserAccountView(
                                    viewModel: UserAccountViewModel(),
                                    currentUserService: currentUserService)
                            } label: {
                                HStack {
                                    Text("Tap Here or ") + Text(Image(systemName: "person")) + Text(" to Sign In!")
                                }
                                .foregroundColor(.accentColor)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // MARK: -- Text Capture Section, Local File
                    Divider().padding(.horizontal)
                    VStackBox {
                        HStack {
                            Text ("Capture Form Example")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            NavigationLink {
                                Form() {
                                    ListableStoreView(store: templateStructStore, showSectionHeader: true, showDividers: false)
                                }
                            } label: {
                                Text("Records")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                    } content: {
                        CaptureFormView(
                            viewModel: TemplateStruct.makeCaptureFormViewModel(store: templateStructStore),
                            showHeader: false
                        )
                            .padding(.horizontal)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    

                    // MARK: -- Testing Talk
                    Divider().padding(.horizontal)
                    VStackBox {
                        HStack {
                            Text("Testing Talk")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            if currentUserService.isSignedIn {
                                NavigationLink {
                                    UserCommentPostsStackView(
                                        currentUserService: currentUserService,
                                        viewModel: UserPostViewModel<PublicComment>(),
                                        store: publicCommentStore
                                    )
                                } label: {
                                    Text("Write a Comment")
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    } content: {
                        if currentUserService.isSignedIn {
                            PostsScrollView(
                                store: publicCommentStore,
                                currentUserId: currentUserService.userKey.uid,
                                showFromUser: true,
                                hideWhenEmpty: true
                            )
                        } else {
                            HStack {
                                Text("Not Signed In!")
                                Spacer()
                                Text("...tap ") + Text(Image(systemName: "person")) + Text(" above")
                            }
                            .padding(.horizontal)
                        }
                    }
                    // MARK: -- END VStack
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Template")
                        .font(.title)
                }
                
                // MARK: -- Activity Log
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ActivityLogView()
                    } label: {
                        Label("Activity Log", systemImage: "book.pages")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                
                // MARK: -- Settings
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                // MARK: -- Messages
                if currentUserService.isSignedIn
                && privateMessageStore.list.count > 0       //  only displays when messages exist, essentially turning-off Message functionality
                {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            UserMessagePostsStackView(
                                viewModel: UserPostViewModel<PrivateMessage>(),
                                currentUserService: currentUserService,
                                store: privateMessageStore)
                        } label: {
                            Label("Messages", systemImage: "envelope")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                // MARK: -- User Account & Profile
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        UserAccountView(
                            viewModel: UserAccountViewModel(),
                            currentUserService: currentUserService)
                    } label: {
                        Label("User Account", systemImage: currentUserService.isSignedIn ? "person.fill" : "person")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .dynamicTypeSize(...ViewConfiguration.dynamicSizeMax)
            .environment(\.font, Font.body)
        }
    }
}


#if DEBUG
#Preview ("test-data signed-in") {
    let currentUserService = CurrentUserTestService.sharedSignedIn
    HomeView(
        viewModel: HomeViewModel(),
        currentUserService: currentUserService,
        announcementStore: AnnouncementStore.testLoaded(),
        publicCommentStore: PublicCommentStore.testLoaded(),
        privateMessageStore: PrivateMessageStore(),             // loading empty because private messages not used yet
        templateStructStore: ListableFileStore<TemplateStruct>()
    )
}

#Preview ("test-data signed-out") {
    let container = try! ModelContainer()
    let currentUserService = CurrentUserTestService.sharedSignedOut
    HomeView(
        viewModel: HomeViewModel(),
        currentUserService: currentUserService,
        announcementStore: AnnouncementStore.testLoaded(),
        publicCommentStore: PublicCommentStore.testLoaded(),
        privateMessageStore: PrivateMessageStore.testLoaded(),
        templateStructStore: ListableFileStore<TemplateStruct>()
    )
}
#endif
