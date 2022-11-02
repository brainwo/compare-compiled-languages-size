#!/usr/bin/env python3

import plotly.graph_objects as go

sizetxt = open("size.txt", "r")
filetypetxt = open("filetype.txt", "r")
size_data = sizetxt.readlines()


def get_linking(file: str) -> str:
    if "static" in file:
        return "red"  # Static is in red
    else:
        return "blue"  # Dynamic is in blue


filetype_data = list(map(lambda line: (
    line.strip().split('/')[1].split(':')[0],
    get_linking(line),
), filetypetxt.readlines()))


def get_filetype(name: str) -> str:
    return list(filter(lambda x: x[0] in name, filetype_data))[0][1]


lang_size = list(
    map(lambda x: int(''.join(x.split()[0].split(","))), size_data))
lang_name = list(map(lambda x: f"{x.split()[1]} ({x.split()[0]})", size_data))
lang_link = list(map(lambda x: get_filetype(x), lang_name))


def generate_image(log: bool):
    title = f"Compiled language size comparison {'(in logarithmic scale)' if log else ''}"
    # TODO
    labels = {"x": "compiler-language", "y": "size in bytes"}

    bar = go.Bar(
        x=lang_name,
        y=lang_size,
        marker_color=lang_link
    )

    fig = go.Figure(data=bar)
    if log:
        fig.update_yaxes(type="log")

    fig.update_annotations(row="compiler-language")

    fig.update_layout(title_text=title)

    output = open(f"assets/chart{'_log' if log else ''}.png", "wb")
    output.write(fig.to_image("png"))
    output.close()


if __name__ == "__main__":
    generate_image(False)
    generate_image(True)

    sizetxt.close()
