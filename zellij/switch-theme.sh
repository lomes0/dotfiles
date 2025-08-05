#!/bin/bash

# Zellij Theme Switcher
# Usage: ./switch-theme.sh [theme-name]

ZELLIJ_CONFIG="/home/eransa/dotfiles/zellij/.config/zellij/config.kdl"

themes=(
    "catppuccin-mocha"
    "catppuccin-macchiato" 
    "catppuccin-frappe"
    "catppuccin-latte"
    "rose-pine"
    "enhanced-dark"
    "minimal-light"
    "neon-cyber"
    "modern-tabs"
    "clean-minimal"
    "box-style"
    "nord"
)

layouts=(
    "compact"
    "enhanced"
    "full-bar"
    "compact-enhanced"
    "top-tabs"
    "clean-tabs"
    "minimal-tabs"
)

show_help() {
    echo "Zellij Theme & Layout Switcher"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  -t, --theme THEME     Set theme"
    echo "  -l, --layout LAYOUT   Set layout"
    echo "  --list-themes         List available themes"
    echo "  --list-layouts        List available layouts"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Available themes:"
    for theme in "${themes[@]}"; do
        echo "  - $theme"
    done
    echo ""
    echo "Available layouts:"
    for layout in "${layouts[@]}"; do
        echo "  - $layout"
    done
}

set_theme() {
    local theme=$1
    if [[ " ${themes[*]} " == *" $theme "* ]]; then
        sed -i "s/^theme \".*\"/theme \"$theme\"/" "$ZELLIJ_CONFIG"
        echo "✅ Theme set to: $theme"
        echo "🔄 Restart Zellij to see changes"
    else
        echo "❌ Invalid theme: $theme"
        echo "Available themes: ${themes[*]}"
        exit 1
    fi
}

set_layout() {
    local layout=$1
    if [[ " ${layouts[*]} " == *" $layout "* ]]; then
        sed -i "s/^default_layout \".*\"/default_layout \"$layout\"/" "$ZELLIJ_CONFIG"
        echo "✅ Layout set to: $layout"
        echo "🔄 Restart Zellij to see changes"
    else
        echo "❌ Invalid layout: $layout"
        echo "Available layouts: ${layouts[*]}"
        exit 1
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--theme)
            set_theme "$2"
            shift 2
            ;;
        -l|--layout)
            set_layout "$2"
            shift 2
            ;;
        --list-themes)
            echo "Available themes:"
            for theme in "${themes[@]}"; do
                echo "  - $theme"
            done
            exit 0
            ;;
        --list-layouts)
            echo "Available layouts:"
            for layout in "${layouts[@]}"; do
                echo "  - $layout"
            done
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# If no arguments provided, show help
if [[ $# -eq 0 ]]; then
    show_help
fi
