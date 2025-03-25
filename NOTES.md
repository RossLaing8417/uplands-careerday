# Notes

## Loopy

### Original

```c
#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"
#include "time.h"

int main(int argc, char** argv) {
	int u = atoi(argv[1]);
	srand(time(NULL));
	int r = rand() % 10000;
	int32_t a[10000] = {0};
	for (int i = 0; i < 10000; i += 1) {
		for (int j = 0; j < 100000; j += 1) {
			a[i] = a[i] + j%u;
		}
		a[i] += r;
	}
	printf("%d\n", a[r]);
}
```

### Updated

```c
#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"
#include "time.h"

int main(int argc, char** argv) {
	int u = atoi(argv[1]);
	srand(time(NULL));
	int r = rand() % 10000;
	int32_t a[10000] = {0};
	for (int i = 0; i < 10000; i += 1) {
		for (int j = 0; j < 100000; j += 1) {
			double quotient = (double)j / (double)u;
			int remainder = j - u*(int)quotient;
			a[i] = a[i] + remainder;
		}
		a[i] += r;
	}
	printf("%d\n", a[r]);
}
```

## Plutonian Pebbles

### Part 2 Cache

```zig
const Cache = struct {
    pebble: usize,
    count: usize,
    result: usize,
};

var fn_cache = std.ArrayListUnmanaged(Cache){};

fn solvePebble(allocator: std.mem.Allocator, pebble: usize, count: usize) !usize {
    if (count == 0) {
        return 1;
    }

    for (fn_cache.items) |item| {
        if (item.pebble == pebble and item.count == count) {
            return item.result;
        }
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

    try fn_cache.append(allocator, Cache{
        .pebble = pebble,
        .count = count,
        .result = result,
    });
    return result;
}
```
