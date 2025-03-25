const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();

    const allocator = arena.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    _ = args.next();

    const count = try std.fmt.parseUnsigned(usize, args.next() orelse "25", 10);

    const result = try solve(allocator, "4329 385 0 1444386 600463 19 1 56615", count);
    std.debug.print("{d}\n", .{result});
}

test "Example" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const result = solve(arena.allocator(), "125 17", 25);
    try std.testing.expectEqual(@as(usize, 55312), result);
}

fn solve(allocator: std.mem.Allocator, input: []const u8, count: usize) !usize {
    var result: usize = 0;

    var itr = std.mem.splitScalar(u8, input, ' ');
    while (itr.next()) |entry| {
        const pebble = try std.fmt.parseUnsigned(usize, entry, 10);
        result += try solvePebble(allocator, pebble, count);
    }

    return result;
}

fn solvePebble(allocator: std.mem.Allocator, pebble: usize, count: usize) !usize {
    if (count == 0) {
        return 1;
    }

    var result: usize = 0;

    if (pebble == 0) {
        result += try solvePebble(allocator, 1, count - 1);
    } else {
        var buffer: [128]u8 = undefined;
        const str = try std.fmt.bufPrint(&buffer, "{d}", .{pebble});

        if (str.len % 2 == 0) {
            const first = try std.fmt.parseUnsigned(usize, str[0..@divExact(str.len, 2)], 10);
            result += try solvePebble(allocator, first, count - 1);
            const second = try std.fmt.parseUnsigned(usize, str[@divExact(str.len, 2)..], 10);
            result += try solvePebble(allocator, second, count - 1);
        } else {
            result += try solvePebble(allocator, pebble * 2024, count - 1);
        }
    }

    return result;
}
