# xv6
Currently, xv6 limits file size to 268 blocks due to its inode structure (12 direct blocks + 1 single indirect block). The task is to increase this limit by adding a double indirect block to the inode, allowing up to 65,803 blocks per file. This requires modifying the filesystem code, particularly the bmap() function, to handle the new double indirect addressing while keeping the inode size fixed. The bigfile program should successfully create a file of this larger size, and user tests must pass.

### Key points:

- Change NDIRECT from 12 to 11 direct blocks to free space for the double indirect block.
- Update filesystem constants and recreate the disk image.
- Handle block allocation and freeing properly, including the new double indirect blocks.

### Symbolic Links:
Implement symbolic links that reference files or directories by path name. Unlike hard links, symbolic links can span directories and disks. Only the open() syscall must follow symbolic links, resolving them recursively to avoid cycles (with a depth limit).

Key points:
- Implement symlink(target, path) syscall to create a symbolic link.
- Add a new file type T_SYMLINK and a flag O_NOFOLLOW to open().
- Modify open() to follow symbolic links unless O_NOFOLLOW is set.
- Ensure other syscalls like link() and unlink() operate on the link itself, not its target.

The project requires understanding xv6’s inode layout, block mapping, and pathname resolution. It includes modifying kernel data structures, filesystems code, and adding user tests.
