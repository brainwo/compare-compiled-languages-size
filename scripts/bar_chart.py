#!/usr/bin/env python3

import plotly.express as px

file = open("size.txt", "r")
size_data = file.readlines()

lang_size = list(
    map(lambda x: int(''.join(x.split()[0].split(","))), size_data))
lang_name = list(map(lambda x: f"{x.split()[1]} ({x.split()[0]})", size_data))


def generate_image(log: bool):
    fig = px.bar(
        title=f"Compiled language size comparison {'(in logarithmic scale)' if log else ''}",
        x=lang_name,
        y=lang_size,
        labels={"x": "compiler-language", "y": "size in bytes"},
        log_y=log
    )

    output = open(f"assets/chart{'_log' if log else ''}.png", "wb")
    output.write(fig.to_image("png"))
    output.close()


if __name__ == "__main__":
    generate_image(False)
    generate_image(True)

    file.close()
