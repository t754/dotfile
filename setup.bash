#!/bin/bash
go get https://github.com/FooSoft/homemaker
homemaker  -variant fedora -verbose  homeLink.toml .
homemaker  -variant fedora -task ghq -verbose  homeLink.toml .
homemaker  -variant fedora -task dropbox -verbose  homeLink.toml .
