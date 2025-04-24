//
//  AddNoteView.swift
//  Expense Tracker
//
//  Created by Saloni Singh on 02/04/25.
//

import SwiftUI

struct AddNoteView: View {
    @StateObject private var sharedImageVM = SharedImageViewModel()
    
@State private var activeTab: NoteTabModel = .addnote
    var body: some View {
        TabView(selection: $activeTab){
            NoteView(viewModel: sharedImageVM)
                .tag(NoteTabModel.addnote)
                .tabItem {NoteTabModel.addnote.noteTabContent}
            AttachmentView(viewModel: sharedImageVM)
                .tag(TabModel.search)
                .tabItem {NoteTabModel.attachment.noteTabContent}
            SpeakView()
                .tag(TabModel.charts)
                .tabItem {NoteTabModel.speak.noteTabContent}
        }
        .padding(.bottom,20)
        .tint(appTint)
    }
}

#Preview {
    AddNoteView()
}
