#!/usr/bin/env python3

readme = open("README.md", "w")

sizetxt = open("size.txt",  "r")
versiontxt = open("version.txt",  "r")
filetypetxt = open("filetype.txt", "r")
size = sizetxt.readlines()
version = versiontxt.readlines()
filetype = filetypetxt.readlines()

version_data = list(map(lambda line: (
    line.strip().split('|')[0],
    line.strip().split('|')[1],
), version))


def get_linking(file: str) -> str:
    if "static" in file:
        return "statically linked"
    else:
        return "dynamically linked"


filetype_data = list(map(lambda line: (
    get_linking(line),
    line.strip().split('/')[1].split(':')[0]
), filetype))


def get_version_number(compiler: str) -> (str | None):
    for name, version in version_data:
        if compiler.startswith(name):
            return version
    return None


def get_filetype(name: str) -> str:
    return list(filter(lambda data: data[1] == name, filetype_data))[0][0]


data = list(map(lambda x: (
    x.strip().split(' ')[1].split('-')[1],
    x.strip().split(' ')[1].split('-')[0],
    get_version_number(x.strip().split(' ')[1].split('-')[0]),
    get_filetype(x.strip().split(' ')[1]),
    x.strip().split(' ')[0],
), size))

new_line = "\n"

template = f"""
<!--
This file is auto-generate using scripts/generate_readme.py
Do not change manually
-->

Compare size of compiled languages.

### Chart

Linear scale:

![](./assets/chart.png)

Logarithmic scale:

![](./assets/chart_log.png)

### Table

| language | compiler | version | linking | size (in bytes) |
| -------- | -------- | ------- | ------- | --------------- |
{new_line.join(list(map(lambda x: f"|{x[0]}|{x[1]}|{x[2]}|{x[3]}|{x[4]}|" ,data)))}

"""

readme.write(template.strip())
readme.close()
sizetxt.close()
versiontxt.close()
