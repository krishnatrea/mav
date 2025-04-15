# 🧠 Memory Allocator Visualizer

A simple CLI tool to visualize memory allocation and deallocation in a fixed-size block of memory.

---

## 🔧 Features

- Fixed-size memory of **64 bytes**
- Supports the following commands:
  - `alloc <size>` – Allocate a block of memory
  - `clear <id>` – Deallocate a previously allocated block by its ID
  - `show` – Visualize the current memory layout in a simple text-based format

---

## 📦 Example Usage

```text
Total Memory: 64 bytes  
Type  'alloc <size>' or 'show', 'clear <id>'

> alloc 2
Allocated ID 1 (offset 0, size 2))

> show
Memory map
 [##..............................................................]

> alloc 8
Allocated ID 2 (offset 2, size 8))

> show
Memory map
 [##########......................................................]

> clear 1
Deleted Allocation ID 1 with size 0

> show
Memory map
 [..########......................................................]
```

---

## 🚀 How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/krishnatrea/mav.git
   cd mav
   ```

2. Build and run the project (if using Zig):
   ```bash
   zig build
   ./zig-out/bin/mav
   ```

3. Interact with the CLI using the supported commands.

---

## 💡 Future Improvements

- Better visualization (e.g., color-coded output)
- Error handling for invalid input or overlapping allocations
- Support for memory fragmentation and compaction
- Create a GUI

---

## 🛠 Tech Stack

- Zig (for high-performance, low-level control)
- CLI-based interface (lightweight and interactive)
