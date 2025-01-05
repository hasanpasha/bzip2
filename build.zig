const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bzip2_version_h = b.addConfigHeader(
        .{
            .style = .{ .cmake = b.path("bz_version.h.in") },
            .include_path = "bz_version.h",
        },
        .{},
    );

    const libbzip2_sources = [_][]const u8{
        "blocksort.c",
        "huffman.c",
        "crctable.c",
        "randtable.c",
        "compress.c",
        "decompress.c",
        "bzlib.c",
    };

    const static_lib = b.addStaticLibrary(.{
        .name = "bzip2",
        .target = target,
        .optimize = optimize,
    });
    static_lib.linkLibC();
    static_lib.addConfigHeader(bzip2_version_h);
    static_lib.addCSourceFiles(.{ .files = &libbzip2_sources });
    b.installArtifact(static_lib);

    const shared_lib = b.addSharedLibrary(.{
        .name = "bzip2",
        .target = target,
        .optimize = optimize,
    });
    shared_lib.linkLibC();
    shared_lib.addConfigHeader(bzip2_version_h);
    shared_lib.addCSourceFiles(.{ .files = &libbzip2_sources });
    b.installArtifact(shared_lib);
}
