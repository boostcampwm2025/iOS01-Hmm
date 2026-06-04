//
//  ComponentIconView.swift
//  DUDesignSystemExample
//

import SwiftUI
import DUDesignSystem

struct ComponentIconView: View {

    private let sizes: [CGFloat] = [
        TokenIconSize.size15,
        TokenIconSize.size18,
        TokenIconSize.size24,
        TokenIconSize.size28,
        TokenIconSize.size38,
    ]

    @State private var selectedSize: CGFloat = TokenIconSize.size24
    @State private var selectedIcon: DUIconName?

    var body: some View {
        List {
            Section {
                Picker("크기", selection: $selectedSize) {
                    ForEach(sizes, id: \.self) { size in
                        Text("\(Int(size))pt").tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            Section {
                ForEach(DUIconName.allCases, id: \.self) { icon in
                    Button { selectedIcon = icon } label: {
                        HStack(spacing: TokenSpacing.md) {
                            DUIcon(icon, size: selectedSize)
                                .frame(width: TokenIconSize.size38, height: TokenIconSize.size38)
                                .overlay(
                                    RoundedRectangle(cornerRadius: TokenRadius.xs)
                                        .stroke(Color.orange300.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                                )

                            Text(".\(icon)")
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(Color.gray400)
                        }
                        .padding(.vertical, TokenSpacing.xs)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
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
                    DUIcon(icon, size: 120)
                        .padding(TokenSpacing.xl)
                        .background(Color.beige100)
                        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.xl))
                        .tokenShadow(TokenShadow.`default`)

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
                .tokenShadow(TokenShadow.dim)
                .padding(.horizontal, TokenSpacing.lg)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.gray400)
                    .padding(TokenSpacing.sm)
                    .background(Color.beige50)
                    .clipShape(Circle())
                    .tokenShadow(TokenShadow.dim)
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
