for f in $(find ./ -name '*.nim'); do nimpretty --maxLineLen:100 --indent:4 $f; done
