//
//  ComponentIconView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentIconView: View {

    private struct SizeGroup: Identifiable {
        let id: String
        let size: CGFloat
        let icons: [DUIconName]
    }

    private let groups: [SizeGroup] = {
        let allBySize = Dictionary(grouping: DUIconName.allCases) { $0.defaultSize }
        return allBySize.keys.sorted().map { size in
            SizeGroup(id: "\(Int(size))pt", size: size, icons: allBySize[size]!)
        }
    }()

    @State private var selectedIcon: DUIconName?

    var body: some View {
        List {
            ForEach(groups) { group in
                Section(group.id) {
                    ForEach(group.icons, id: \.self) { icon in
                        Button { selectedIcon = icon } label: {
                            HStack(spacing: TokenSpacing.md) {
                                DUIcon(icon)
                                    .padding(TokenSpacing.sm)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: TokenRadius.xs)
                                            .stroke(Color.orange300.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                                    )

                                Text(".\(icon)")
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundStyle(Color.gray600)
                            }
                            .padding(.vertical, TokenSpacing.xs)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Icon")
        .navigationSubtitle("Cell을 탭하면 크게 볼 수 있어요")
        .fullScreenCover(item: $selectedIcon) { icon in
            IconFullScreenView(icon: icon)
        }
    }
}

private struct IconFullScreenView: View {
    let icon: DUIconName
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.beige200.ignoresSafeArea()

            VStack(spacing: TokenSpacing.xl) {
                VStack(spacing: TokenSpacing.lg) {
                    DUIcon(icon, size: TokenIconSize.size64)
                        .padding(TokenSpacing.xl)
                        .background(Color.orange100)
                        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xl))
                        .tokenShadow(TokenShadow.medium)

                    VStack(spacing: TokenSpacing.xs) {
                        Text(".\(icon)")
                            .font(.system(.title3, design: .monospaced).weight(.semibold))
                            .foregroundStyle(Color.gray700)

                        Text(icon.rawValue)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(Color.gray400)
                    }
                }
                .padding(TokenSpacing.xl)
                .frame(maxWidth: .infinity)
                .background(Color.beige50)
                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xl))
                .tokenShadow(TokenShadow.small)
                .padding(.horizontal, TokenSpacing.lg)

                HStack(spacing: TokenSpacing.xxl) {
                    VStack(spacing: TokenSpacing.xx) {
                        Text("기본 크기")
                            .duFont(.caption)
                            .foregroundStyle(Color.gray400)
                        Text("\(Int(icon.defaultSize))pt")
                            .duFont(.headline)
                            .foregroundStyle(Color.gray700)
                    }

                    Divider()
                        .frame(height: 32)

                    VStack(spacing: TokenSpacing.xx) {
                        Text("에셋 경로")
                            .duFont(.caption)
                            .foregroundStyle(Color.gray400)
                        Text(icon.rawValue)
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(Color.gray700)
                    }
                }
                .padding(TokenSpacing.md)
                .background(Color.beige50)
                .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
                .tokenShadow(TokenShadow.small)
                .padding(.horizontal, TokenSpacing.lg)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.gray500)
                    .padding(TokenSpacing.sm)
                    .background(Color.beige50)
                    .clipShape(Circle())
                    .tokenShadow(TokenShadow.small)
            }
            .padding(TokenSpacing.md)
        }
    }
}

extension DUIconName: Identifiable {
    public var id: String { rawValue }
}

#Preview {
    NavigationStack {
        ComponentIconView()
    }
}
