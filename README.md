# SourceCounter

统计 C/C++ 源代码的行数信息

## 环境依赖

依赖 `Erlang` `Elixir`，Windows 需前往官网下载安装，*nix 下建议使用对应的包管理器安装。

### ArchLinux

``` shell
sudo pacman -S erlang elixir
```

### MacOS

``` shell
brew install erlang elixir
```

## 运行

*下面所说的线程为 Erlang 线程*

参数指定一个目录时，每一个文件一个线程。

``` shell
$ cd ./source_counter
$ mix counter ./test/src/
file:dir/hello.c total:7 empty:1 effective:5 comment:1
file:folder/dir/hi.c total:5 empty:0 effective:5 comment:0
file:hello.c total:19 empty:4 effective:7 comment:11
file:folder/dir/hello.c total:7 empty:1 effective:5 comment:1
```

多个参数同时指定多个目录，每个目录一个线程，其中每个文件一个线程。

``` shell
$ mix counter ./test/src/folder/ ./test/src/dir
file:dir/hi.c total:5 empty:0 effective:5 comment:0
file:hello.c total:7 empty:1 effective:5 comment:1
file:dir/hello.c total:7 empty:1 effective:5 comment:1
```

可混合指定目录和文件，目录一个线程，文件一个线程，目录中每个文件一个线程。

``` shell
$ mix counter ./test/src/folder/ ./test/src/dir/hello.c
file:dir/hi.c total:5 empty:0 effective:5 comment:0
file:dir/hello.c total:7 empty:1 effective:5 comment:1
file:./test/src/dir/hello.c total:7 empty:1 effective:5 comment:1
```

### 运行测试

``` shell
$ cd ./source_counter
$ mix test
file:test/src/hello.c total:19 empty:4 effective:7 comment:11
.file:test/src/hello.c total:19 empty:4 effective:7 comment:11
file:test/src/dir/hello.c total:7 empty:1 effective:5 comment:1
file:test/src/folder/dir/hello.c total:7 empty:1 effective:5 comment:1
file:test/src/folder/dir/hi.c total:5 empty:0 effective:5 comment:0
.

Finished in 0.04 seconds
2 tests, 0 failures

Randomized with seed 383000

```

## TODO

- [x] 多线程
- [ ] 通过配置文件，后缀名，配置更多语言的支持
- [ ] 增加非 UTF-8 编码支持
- [ ] ...
