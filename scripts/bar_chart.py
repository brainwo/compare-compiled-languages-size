#!/usr/bin/env python3

import plotly.express as px

file = open("size.txt", "r")
size_data = file.readlines()

lang_size = map(lambda x: int(x.split()[0]), size_data)
lang_name = map(lambda x: f"{x.split()[1]} ({x.split()[0]}K)", size_data)

fig = px.bar(y=list(lang_size), x=list(lang_name))

output = open("assets/chart.png", "wb")
output.write(fig.to_image("png"))

file.close()
output.close()
