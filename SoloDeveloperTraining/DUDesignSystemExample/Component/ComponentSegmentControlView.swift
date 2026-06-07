//
//  ComponentSegmentControlView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentSegmentControlView: View {

    @State private var selectedIndex: Int = 0
    @State private var leading: String = "아이템"
    @State private var trailing: String = "부동산"

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Preview Area
            PreviewArea {
                SegmentControl(leading: leading, trailing: trailing, selectedIndex: $selectedIndex)
                    .frame(maxWidth: .infinity)
            }

            // MARK: - Controls
            List {
                Section("앞 텍스트") {
                    HStack {
                        TextField("앞 텍스트", text: $leading)
                        if !leading.isEmpty {
                            Button { leading = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.gray400)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("뒤 텍스트") {
                    HStack {
                        TextField("뒤 텍스트", text: $trailing)
                        if !trailing.isEmpty {
                            Button { trailing = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.gray400)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.beige200)
        .navigationTitle("SegmentControl")
    }
}

#Preview {
    NavigationStack {
        ComponentSegmentControlView()
    }
}
