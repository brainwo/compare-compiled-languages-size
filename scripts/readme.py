#!/usr/bin/env python3

readme = open("README.md", "w")

sizetxt = open("size.txt",  "r")
versiontxt = open("version.txt",  "r")
size = sizetxt.readlines()
version = versiontxt.readlines()

version_data = list(map(lambda x: (
    x.strip().split('|')[0],
    x.strip().split('|')[1],
), version))


def get_version_number(compiler: str) -> (str | None):
    for name, version in version_data:
        if compiler.startswith(name):
            return version
    return None


data = list(map(lambda x: (
    x.strip().split(' ')[1].split('-')[1],
    x.strip().split(' ')[1].split('-')[0],
    get_version_number(x.strip().split(' ')[1].split('-')[0]),
    x.strip().split(' ')[0],
), size))

new_line = "\n"

template = f"""
Compare size of compiled languages.

### Chart

Linear scale:

![](./assets/chart.png)

Logarithmic scale:

![](./assets/chart_log.png)

### Table

| language | compiler | version | size (in bytes) |
| -------- | -------- | ---------- | --------------- |
{new_line.join(list(map(lambda x: f"|{x[0]}|{x[1]}|{x[2]}|{x[3]}|" ,data)))}

"""
readme.write(template.strip())
readme.close()
sizetxt.close()
versiontxt.close()
