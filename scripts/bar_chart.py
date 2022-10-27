#!/usr/bin/env python3

import plotly.express as px

file = open("size.txt", "r")
size_data = file.readlines()

lang_size = list(map(lambda x: int(x.split()[0]), size_data))
lang_name = list(map(lambda x: f"{x.split()[1]} ({x.split()[0]}K)", size_data))


def generate_image(log: bool):
    fig = px.bar(
        title=f"Compiled language size comparison {'(in logarithmic)' if log else ''}",
        x=lang_name,
        y=lang_size,
        labels={"x": "compiler-language", "y": "size in kilobytes"},
        log_y=log
    )

    output = open(f"assets/chart{'_log' if log else ''}.png", "wb")
    output.write(fig.to_image("png"))
    output.close()


if __name__ == "__main__":
    generate_image(False)
    generate_image(True)

    file.close()
