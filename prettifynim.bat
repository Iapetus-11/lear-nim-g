@echo off

:: go through each file in the current directory that ends in .nim
FOR /R %%f IN (*.nim) DO (
    :: prettify it with nimpretty
    nimpretty --maxLineLen:100 --indent:4 %%f
)
