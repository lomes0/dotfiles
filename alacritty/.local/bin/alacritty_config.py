#!/usr/bin/env python3
"""
Alacritty Configuration Manager

A utility to manage numeric values in alacritty.toml configuration file.
Supports increasing, decreasing, and resetting values to defaults.
"""

import argparse
import sys
from pathlib import Path
import tomllib
import tomli_w
from typing import Dict, Any, Optional, Union


class AlacrittyConfigManager:
    """Manages Alacritty TOML configuration file."""
    
    # Default values for common configuration options
    DEFAULT_VALUES = {
        'font.size': 12.0,
        'window.opacity': 1.0,
        'window.padding.x': 0,
        'window.padding.y': 0,
        'window.dimensions.lines': 24,
        'window.dimensions.columns': 80,
    }
    
    def __init__(self, config_path: Optional[str] = None):
        """Initialize with config file path."""
        if config_path:
            self.config_path = Path(config_path)
        else:
            # Default Alacritty config path
            self.config_path = Path.home() / '.config' / 'alacritty' / 'alacritty.toml'
        
        if not self.config_path.exists():
            raise FileNotFoundError(f"Config file not found: {self.config_path}")
    
    def load_config(self) -> Dict[str, Any]:
        """Load and parse the TOML configuration file."""
        try:
            with open(self.config_path, 'rb') as f:
                return tomllib.load(f)
        except Exception as e:
            raise RuntimeError(f"Failed to load config: {e}")
    
    def save_config(self, config: Dict[str, Any]) -> None:
        """Save configuration back to TOML file."""
        try:
            with open(self.config_path, 'wb') as f:
                tomli_w.dump(config, f)
        except Exception as e:
            raise RuntimeError(f"Failed to save config: {e}")
    
    def get_nested_value(self, config: Dict[str, Any], key_path: str) -> Optional[Union[int, float]]:
        """Get a nested value from config using dot notation (e.g., 'font.size')."""
        keys = key_path.split('.')
        current = config
        
        for key in keys:
            if isinstance(current, dict) and key in current:
                current = current[key]
            else:
                return None
        
        return current if isinstance(current, (int, float)) else None
    
    def set_nested_value(self, config: Dict[str, Any], key_path: str, value: Union[int, float]) -> None:
        """Set a nested value in config using dot notation."""
        keys = key_path.split('.')
        current = config
        
        # Navigate to the parent of the target key
        for key in keys[:-1]:
            if key not in current:
                current[key] = {}
            current = current[key]
        
        # Set the final value
        current[keys[-1]] = value
    
    def list_numeric_values(self) -> Dict[str, Union[int, float]]:
        """List all numeric values in the configuration."""
        config = self.load_config()
        numeric_values = {}
        
        def extract_numeric(obj: Any, prefix: str = '') -> None:
            if isinstance(obj, dict):
                for key, value in obj.items():
                    new_prefix = f"{prefix}.{key}" if prefix else key
                    if isinstance(value, (int, float)):
                        numeric_values[new_prefix] = value
                    elif isinstance(value, dict):
                        extract_numeric(value, new_prefix)
        
        extract_numeric(config)
        return numeric_values
    
    def modify_value(self, key_path: str, operation: str, amount: float = 1.0) -> None:
        """Modify a numeric value in the configuration."""
        config = self.load_config()
        current_value = self.get_nested_value(config, key_path)
        
        if current_value is None:
            print(f"Key '{key_path}' not found or is not a numeric value")
            return
        
        if operation == 'increase':
            new_value = current_value + amount
        elif operation == 'decrease':
            new_value = current_value - amount
        elif operation == 'reset':
            new_value = self.DEFAULT_VALUES.get(key_path)
            if new_value is None:
                print(f"No default value defined for '{key_path}'")
                return
        else:
            print(f"Unknown operation: {operation}")
            return
        
        # Ensure non-negative values for certain keys
        if key_path in ['font.size', 'window.opacity'] and new_value < 0:
            new_value = 0
        
        # Ensure opacity doesn't exceed 1.0
        if key_path == 'window.opacity' and new_value > 1.0:
            new_value = 1.0
        
        self.set_nested_value(config, key_path, new_value)
        self.save_config(config)
        
        print(f"Updated '{key_path}': {current_value} → {new_value}")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Manage numeric values in Alacritty configuration",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --list                           # List all numeric values
  %(prog)s --key font.size --increase       # Increase font size by 1
  %(prog)s --key font.size --decrease 0.5   # Decrease font size by 0.5
  %(prog)s --key window.opacity --reset     # Reset opacity to default
  %(prog)s --key window.padding.x --increase 5  # Increase padding by 5
        """
    )
    
    parser.add_argument(
        '--config', '-c',
        help='Path to alacritty.toml file (default: ~/.config/alacritty/alacritty.toml)'
    )
    
    parser.add_argument(
        '--list', '-l',
        action='store_true',
        help='List all numeric configuration values'
    )
    
    parser.add_argument(
        '--key', '-k',
        help='Configuration key to modify (e.g., font.size, window.opacity)'
    )
    
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        '--increase', '-i',
        nargs='?',
        const=1.0,
        type=float,
        help='Increase value by amount (default: 1.0)'
    )
    
    group.add_argument(
        '--decrease', '-d',
        nargs='?',
        const=1.0,
        type=float,
        help='Decrease value by amount (default: 1.0)'
    )
    
    group.add_argument(
        '--reset', '-r',
        action='store_true',
        help='Reset value to default'
    )
    
    args = parser.parse_args()
    
    try:
        manager = AlacrittyConfigManager(args.config)
        
        if args.list:
            print("Numeric configuration values:")
            print("-" * 40)
            values = manager.list_numeric_values()
            for key, value in sorted(values.items()):
                default = manager.DEFAULT_VALUES.get(key, 'N/A')
                print(f"{key:<25} = {value:<10} (default: {default})")
            return
        
        if not args.key:
            print("Error: --key is required when not using --list")
            parser.print_help()
            sys.exit(1)
        
        if args.increase is not None:
            manager.modify_value(args.key, 'increase', args.increase)
        elif args.decrease is not None:
            manager.modify_value(args.key, 'decrease', args.decrease)
        elif args.reset:
            manager.modify_value(args.key, 'reset')
        else:
            print("Error: specify --increase, --decrease, or --reset")
            parser.print_help()
            sys.exit(1)
    
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
