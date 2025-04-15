const std = @import("std");

const Allocation = struct {
    id: usize,
    offset: usize,
    size: usize,
};

const MAX_MEMORY = 64;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allcation = gpa.allocator();
    var stdout = std.io.getStdOut().writer();

    var used_offset: usize = 0;
    var allocations = std.ArrayList(Allocation).init(allcation);
    defer allocations.deinit();

    var id_counter: usize = 1;

    try stdout.print("Memoery Allocator Visualizer\n", .{});
    try stdout.print("Type  'alloc <size>' or 'show', 'clear <id>' \n\n", .{});
    try stdout.print("Total Memory: {d} bytes\n", .{MAX_MEMORY});

    var stdin = std.io.getStdIn().reader();

    while (true) {
        try stdout.print("> ", .{});

        var line_buf: [64]u8 = undefined;
        const line = try stdin.readUntilDelimiterOrEof(&line_buf, '\n');
        if (line == null) break;

        const input = std.mem.trim(u8, line.?, " \t");

        if (std.mem.startsWith(u8, input, "alloc ")) {
            const size_str = input[6..];
            const size = try std.fmt.parseInt(usize, size_str, 10);

            if (used_offset + size > MAX_MEMORY) {
                try stdout.print("Not Enough memory to allocate {d} bytes. \n", .{size});
                continue;
            }

            try allocations.append(.{ .id = id_counter, .offset = used_offset, .size = size });

            try stdout.print("Allocated ID {d} (offset {d}, size {d}))\n", .{ id_counter, used_offset, size });

            used_offset += size;
            id_counter += 1;
        } else if (std.mem.eql(u8, input, "show")) {
            try stdout.print("Memory map \n [", .{});

            var mem_index: usize = 0;

            for (allocations.items) |a| {
                while (mem_index < a.offset) {
                    try stdout.print(".", .{});
                    mem_index += 1;
                }

                for (a.offset..a.offset + a.size) |_| {
                    try stdout.print("#", .{});

                    mem_index += 1;
                }
            }
            while (mem_index < MAX_MEMORY) {
                try stdout.print(".", .{});
                mem_index += 1;
            }

            try stdout.print("]\n", .{});
        } else if (std.mem.startsWith(u8, input, "clear ")) {
            const id_str: []const u8 = input[6..];
            const id: usize = try std.fmt.parseInt(usize, id_str, 10);

            if (used_offset == 0) {
                try stdout.print("UNDERFLOW \n", .{});
                continue;
            }

            var find: bool = false;
            for (allocations.items) |*a| {
                if (a.id == id) {
                    a.size = 0;
                    find = true;
                    try stdout.print("Deleted Allocation ID {d} with size {d}\n", .{ a.id, a.size });
                }
            }

            if (!find) {
                try stdout.print("Allocation with id {d} does not exits, please provide existing id\n", .{id});
            }
        } else {
            try stdout.print("Unknown command. \n", .{});
        }
    }
}
