#!/bin/bash
homemaker  -variant fedora -verbose  homeLink.toml .
homemaker  -variant fedora -task ghq -verbose  homeLink.toml .
homemaker  -variant fedora -task dropbox -verbose  homeLink.toml .
