#!/bin/bash

# Theme Preview for Zellij
# Shows color palettes for all available themes

echo "🎨 Zellij Theme Preview"
echo "======================="
echo ""

preview_theme() {
    local theme_name=$1
    local colors=("$@")
    
    echo "📋 $theme_name"
    echo "──────────────"
    
    # Print color blocks
    local color_names=("bg" "fg" "red" "green" "blue" "yellow" "magenta" "orange" "cyan" "black" "white")
    
    for i in "${!color_names[@]}"; do
        if [[ $((i + 2)) -lt ${#colors[@]} ]]; then
            local color=${colors[$((i + 2))]}
            printf "%-8s: %s\n" "${color_names[$i]}" "$color"
        fi
    done
    echo ""
}

echo "🌸 Catppuccin Themes:"
echo ""

echo "🌙 Catppuccin Mocha (Dark)"
preview_theme "catppuccin-mocha" \
    "#585b70" "#cdd6f4" "#f38ba8" "#a6e3a1" "#89b4fa" "#f9e2af" "#f5c2e7" "#fab387" "#89dceb" "#181825" "#cdd6f4"

echo "🌃 Catppuccin Macchiato (Dark)"
preview_theme "catppuccin-macchiato" \
    "#5b6078" "#cad3f5" "#ed8796" "#a6da95" "#8aadf4" "#eed49f" "#f5bde6" "#f5a97f" "#91d7e3" "#1e2030" "#cad3f5"

echo "🌆 Catppuccin Frappe (Dark)"
preview_theme "catppuccin-frappe" \
    "#626880" "#c6d0f5" "#e78284" "#a6d189" "#8caaee" "#e5c890" "#f4b8e4" "#ef9f76" "#99d1db" "#292c3c" "#c6d0f5"

echo "☀️ Catppuccin Latte (Light)"
preview_theme "catppuccin-latte" \
    "#acb0be" "#4c4f69" "#d20f39" "#40a02b" "#1e66f5" "#df8e1d" "#ea76cb" "#fe640b" "#04a5e5" "#e6e9ef" "#4c4f69"

echo "🌹 Rose Pine (Elegant Dark)"
echo "A sophisticated theme with muted, elegant colors"
echo ""

echo "💎 Custom Enhanced Themes:"
echo ""

echo "🌌 Enhanced Dark"
preview_theme "enhanced-dark" \
    "#1e1e2e" "#cdd6f4" "#f38ba8" "#a6e3a1" "#89b4fa" "#f9e2af" "#cba6f7" "#fab387" "#94e2d5" "#181825" "#f5f5f5"

echo "🌅 Minimal Light"
preview_theme "minimal-light" \
    "#fafafa" "#383a42" "#e45649" "#50a14f" "#4078f2" "#c18401" "#a626a4" "#da8548" "#0184bc" "#fafafa" "#383a42"

echo "🚀 Neon Cyber"
preview_theme "neon-cyber" \
    "#0d1117" "#58a6ff" "#ff6b6b" "#51cf66" "#339af0" "#ffd43b" "#d0bfff" "#ff922b" "#3bc9db" "#21262d" "#f0f6fc"

echo "🎯 Modern Tab Styles:"
echo ""

echo "🚀 Modern Tabs"
preview_theme "modern-tabs" \
    "#1a1b26" "#c0caf5" "#f7768e" "#9ece6a" "#7aa2f7" "#e0af68" "#bb9af7" "#ff9e64" "#7dcfff" "#15161e" "#c0caf5"

echo "✨ Clean Minimal"
preview_theme "clean-minimal" \
    "#f8f8f2" "#272822" "#f92672" "#a6e22e" "#66d9ef" "#e6db74" "#ae81ff" "#fd971f" "#66d9ef" "#272822" "#f8f8f2"

echo "📦 Box Style"
preview_theme "box-style" \
    "#282a36" "#f8f8f2" "#ff5555" "#50fa7b" "#8be9fd" "#f1fa8c" "#ff79c6" "#ffb86c" "#8be9fd" "#21222c" "#f8f8f2"

echo "❄️ Nord (Built-in)"
echo "Clean and minimal Nordic theme"
echo ""

echo "🔧 Usage:"
echo "To switch themes: ./switch-theme.sh -t [theme-name]"
echo "To switch layouts: ./switch-theme.sh -l [layout-name]"
echo ""
echo "📐 Available Layouts:"
echo "• compact           - Minimal bar with tabs at bottom (original)"
echo "• enhanced          - Tab bar at top + Status bar at bottom (clean style)"
echo "• full-bar          - Tab bar (2 lines) + Status bar (maximum info)"
echo "• compact-enhanced  - Compact bar with enhanced styling"
echo "• top-tabs          - Clean tab bar at top only"
echo "• clean-tabs        - Clean tab bar with no arrows/decorations"
echo "• minimal-tabs      - Minimal compact bar without decorations"
echo ""
echo "💡 Pro tip: Enable 'simplified_ui true' in config for clean tab styling!"
