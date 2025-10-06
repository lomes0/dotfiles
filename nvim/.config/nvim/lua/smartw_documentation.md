# SmartW - Tree-sitter Based Smart Word Navigation

- https://www.reddit.com/r/neovim/comments/1594hlo/does_anyone_actually_navigate_or_search_their/

## Overview

SmartW is a Neovim plugin that provides intelligent cursor movement based on code semantics rather than traditional word boundaries. It uses Tree-sitter's Abstract Syntax Tree (AST) to understand code structure and navigate between meaningful code elements.

## What It Does

SmartW enhances the traditional `w` (word forward) and `b` (word backward) motions by:

- **Understanding code structure**: Navigates between function names, parameters, variables, and other syntactic elements
- **Context-aware movement**: Behaves differently based on syntactic context (e.g., inside function calls, parameter lists, strings)
- **Language-agnostic**: Works across different programming languages via Tree-sitter parsers
- **Smart fallback**: Falls back to regex-based navigation when Tree-sitter is unavailable or fails

## Core Logic

### Architecture

The plugin is organized into several logical modules:

1. **Configuration System** (`config`)
2. **Utility Functions** (`utils`)
3. **Tree-sitter Integration** (`ts`)
4. **Context Detection** (`contexts`)
5. **Node Traversal** (`traversal`)
6. **Movement Logic** (`movement`)

### Navigation Flow

```
User triggers navigation (forward/backward)
    ↓
Get current cursor position
    ↓
Skip leading whitespace (if at line start)
    ↓
Get Tree-sitter node at cursor
    ↓
Detect context (parameters? function call? string?)
    ↓
Apply context-specific navigation rules
    ↓
Find next target node via AST traversal
    ↓
Fallback to regex if Tree-sitter fails
    ↓
Move cursor to target position
```

### Key Components

#### 1. Configuration System

Defines what constitutes a navigation target:

- **Target Nodes**: AST node types to navigate to (identifiers, functions, strings, member expressions, etc.)
- **Container Nodes**: Nodes that contain other navigable elements (arguments, blocks, etc.)
- **Separator Nodes**: Punctuation and operators
- **Debug Mode**: Toggle verbose logging

#### 2. Utility Functions (`utils`)

Core helpers for position management:

- `get_cursor_pos()`: Get current cursor position (0-indexed)
- `set_cursor_pos(row, col)`: Set cursor position
- `skip_leading_whitespace()`: Smart whitespace handling at line start
- `debug_log()`: Conditional debug output

#### 3. Tree-sitter Integration (`ts`)

Interfaces with Neovim's Tree-sitter API:

- **Parser Caching**: Maintains parsers per buffer/language for performance
- `get_parser(bufnr, lang)`: Retrieve or create Tree-sitter parser
- `get_root(bufnr)`: Get AST root node
- `get_node_at_cursor(bufnr, row, col)`: Find AST node at cursor position
- `node_text(node, bufnr)`: Extract text content of a node

#### 4. Context Detection (`contexts`)

Determines the syntactic context around the cursor:

- `is_in_function_call(node)`: Checks if cursor is inside a function call
- `is_in_string(node)`: Detects string literal contexts
- `is_in_container(node)`: Identifies container structures (arrays, blocks, etc.)
- `is_in_parameters(node)`: Detects parameter/argument lists
- `is_in_member_expression(node)`: Detects dotted expressions (e.g., `vim.api.nvim_buf_get_lines`, `Foo.bar.baz`)

**How it works**: Walks up the AST parent chain until finding a matching context node. For member expressions, it finds the root of the entire chain.

#### 5. Node Traversal (`traversal`)

AST navigation utilities:

- `get_next_sibling_target(node)`: Find next navigable sibling node
- `get_prev_sibling_target(node)`: Find previous navigable sibling node
- `get_first_child_target(node)`: Find first navigable child
- `get_last_child_target(node)`: Find last navigable child
- `is_target_node(node)`: Check if node is a valid navigation target

**Algorithm**: Combines horizontal sibling traversal with vertical child exploration. If a sibling isn't a target, recursively checks its children. **Automatically skips punctuation** (brackets, commas, semicolons) so navigation never stops on structural syntax.

#### 6. Movement Logic (`movement`)

Core navigation implementation:

##### `find_next_target(bufnr, row, col, direction)`
Main entry point for finding the next navigation position.

**Logic**:
1. Get current AST node at cursor
2. Check for special contexts (parameters, function calls)
3. Apply context-specific navigation if applicable
4. Otherwise, use general forward/backward traversal
5. Fall back to regex-based navigation if AST fails

##### `navigate_parameters(param_container, current_node, direction)`
Specialized navigation within parameter lists.

**Logic**:
1. Collect all parameter nodes within the container
2. Find current position in parameter list
3. Move to next/previous parameter
4. If not on a parameter, jump to first (forward) or last (backward)

##### `navigate_function_call(func_call, current_node, direction)`
Handles function call navigation.

**Special behavior**: When on a function name moving forward, jumps directly to the first argument (not the opening parenthesis).

##### `navigate_member_expression(member_expr, current_node, direction)`
Handles dotted member expression navigation (e.g., `vim.api.nvim_buf_get_lines`, `obj.foo.bar.baz`).

**Special behavior**: 
- **Forward**: Treats the entire dotted chain as a single unit and jumps past it
- **Backward**: Jumps to the start of the entire chain
- Prevents navigation stopping on individual dots or parts of the expression

**Example**: When cursor is on any part of `vim.api.nvim_buf_get_lines` (on `vim`, a dot, `api`, etc.), pressing forward will jump past the entire expression, not just to the next dot.

##### `find_next_forward(node)` / `find_next_backward(node)`
General AST traversal for forward/backward navigation.

**Algorithm**:
1. Try to find next/previous sibling target
2. If not found, walk up to parent and try parent's siblings
3. Continue until target found or root reached

##### `fallback_movement(bufnr, row, col, direction)`
Regex-based navigation when Tree-sitter unavailable.

**Patterns matched**:
- Words (`%w+`)
- Brackets (`[](){}`)
- Punctuation (`,.:;`)
- Comparison operators (`==`, `!=`, etc.)
- Math operators (`+-*/%^`)

### Special Features

#### Punctuation Skipping
Navigation automatically skips over structural punctuation that isn't semantically meaningful:
- **Brackets**: `(`, `)`, `[`, `]`, `{`, `}`
- **Separators**: `,`, `;`
- **Other**: `:` (in some contexts)

This ensures navigation always lands on actual code elements (identifiers, strings, numbers) rather than syntax structure.

**Example**:
```lua
print("hello", "world")
^     ^       ^
Navigate: print -> "hello" -> "world" (skips '(' and ',')
```

#### Leading Whitespace Handling
When cursor is at the beginning of a line with leading whitespace, the plugin automatically jumps to the first non-whitespace character before attempting further navigation. This prevents unnecessary movements through indentation.

#### Parser Caching
Tree-sitter parsers are cached per buffer:filetype combination to avoid repeated parser creation overhead.

#### Nested Structure Handling
The traversal system recursively explores child nodes when siblings aren't targets, enabling navigation through complex nested structures.

## Public API

### Setup Function

```lua
require('smartw').setup({
    -- Override default configuration
    target_nodes = { ... },
    container_nodes = { ... },
    separator_nodes = { ... },
    debug = false
})
```

### Navigation Functions

#### `M.move_forward()` → `boolean`
Move cursor forward to next target position.

**Returns**: `true` if movement occurred, `false` otherwise

#### `M.move_backward()` → `boolean`
Move cursor backward to previous target position.

**Returns**: `true` if movement occurred, `false` otherwise

#### `M.forward(count)` → `void`
Move forward `count` times (with count support for keymaps).

**Parameters**:
- `count` (number, optional): Number of movements (default: 1)

#### `M.backward(count)` → `void`
Move backward `count` times (with count support for keymaps).

**Parameters**:
- `count` (number, optional): Number of movements (default: 1)

### Internal API (Testing/Debugging)

Exposed via `M._internal`:

```lua
local smartw = require('smartw')

-- Access internal modules
smartw._internal.utils
smartw._internal.ts
smartw._internal.contexts
smartw._internal.traversal
smartw._internal.movement
smartw._internal.config
smartw._internal.cache
```

## Usage Example

```lua
-- In your init.lua or plugin config
local smartw = require('smartw')

smartw.setup({
    debug = false,  -- Enable for verbose logging
})

-- Map to keys (example)
vim.keymap.set('n', 'w', function()
    smartw.forward(vim.v.count1)
end, { desc = 'Smart word forward' })

vim.keymap.set('n', 'b', function()
    smartw.backward(vim.v.count1)
end, { desc = 'Smart word backward' })
```

## Navigation Examples

### Example 1: Function Call Navigation

```lua
print("hello", "world")
^                        -- Cursor here
```

Press `w`:
```lua
print("hello", "world")
      ^                  -- Jumps to first argument (skips '(')
```

Press `w` again:
```lua
print("hello", "world")
               ^         -- Jumps to second argument (skips ',')
```

### Example 2: Parameter List Navigation

```lua
function foo(a, b, c)
             ^         -- Cursor on 'a'
```

Press `w`:
```lua
function foo(a, b, c)
                ^      -- Jumps to 'b'
```

### Example 3: Leading Whitespace Handling

```lua
    local x = 5
^                   -- Cursor at line start
```

Press `w`:
```lua
    local x = 5
    ^               -- Jumps to first non-whitespace (past indentation)
```

### Example 4: Member Expression Navigation (NEW)

```lua
local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
               ^                           -- Cursor on 'vim'
```

Press `w`:
```lua
local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                                         ^  -- Jumps past entire member expression
```

Another example with chained expressions:
```lua
local value = obj.foo.bar.baz.qux
              ^                    -- Cursor anywhere on the chain
```

Press `w`:
```lua
local value = obj.foo.bar.baz.qux
                                 ^  -- Jumps past entire chain
```

Press `b` (backward) from end:
```lua
local value = obj.foo.bar.baz.qux
              ^                    -- Jumps to start of chain
```

## Performance Considerations

1. **Parser Caching**: Parsers are cached to avoid recreation overhead
2. **Lazy Evaluation**: Tree parsing only happens when navigation is triggered
3. **Fallback Strategy**: Quick regex fallback when Tree-sitter fails prevents blocking

## Error Handling

- **Parser Failures**: Gracefully falls back to regex-based navigation
- **Invalid Positions**: Validates cursor positions before setting
- **Missing Parsers**: Returns early if Tree-sitter parser unavailable
- **Malformed AST**: Defensive checks for nil nodes throughout traversal

## Limitations & Future Enhancements

### Current Limitations
- No LSP integration for semantic information (e.g., jump to definition)
- Limited cross-line navigation optimization
- No visual feedback for navigation targets
- Configuration is global (not per-filetype)

### Potential Enhancements (from design doc)
- Integration with LSP for semantic context
- Custom tree-sitter grammar support
- Visual indicators for navigation targets
- Per-filetype configuration
- Macro recording compatibility improvements
- Performance profiling and optimization

## Debugging

Enable debug mode to see navigation decisions:

```lua
require('smartw').setup({ debug = true })
```

This will output notifications showing:
- Current node type and position
- Target node type and position
- Whitespace skipping actions
- Parser failures

## Implementation Status

Based on the design document, the following features are implemented:

✅ Core Infrastructure
✅ Tree-sitter query system
✅ Cursor to AST node mapping
✅ Node traversal utilities
✅ Position validation

✅ Navigation Contexts
✅ Function call detection
✅ Parameter navigation (with exit on boundary)
✅ **Punctuation skipping (brackets, commas, semicolons)**
✅ **Member expression navigation (dotted chains)**
✅ String literal detection (partial)
✅ Object/Array structure navigation (partial)

✅ Smart Movement Logic
✅ Context-sensitive target selection
✅ Backward navigation support
✅ Edge case handling at line boundaries

✅ Performance Optimization
✅ Parser caching
✅ Optimized tree traversal

⚠️ Partial Implementation
- Template literal expression navigation
- Control flow construct navigation
- Language-specific enhancements

❌ Not Yet Implemented
- LSP integration
- Custom navigation rules configuration
- Comprehensive test suite
- Visual navigation indicators

## Summary

SmartW provides intelligent, syntax-aware cursor movement by leveraging Tree-sitter's understanding of code structure. It's designed to make navigation more intuitive and efficient by understanding the semantic meaning of code elements, while maintaining robust fallback mechanisms for reliability.
