# redaccie-twister
A template for writing TWISTER articles in typst.

## Installing the template

Clone (download) this repository into your local packages folder.
- For me, this is at `~/.local/share/typst/packages/local/`. (So after installing, the complete path to this README should be `~/.local/share/typst/packages/local/redaccie-twister/README.md`)
- On Windows, idk, you’ll have to figure it out. If you do, feel free to submit a pull request explaining where it goes.

## Using the template

You can create a new article from the command line by running `typst init @local/redaccie-twister article` from a folder where you store your articles. This will create a folder named `article` with a file inside named `article.typ`, where you can write your article.

You can also change the `article` in the command to something else, to name the created folder with say, your article title. For example, `typst init @local/redaccie-twister "i don't like endings"` would create a folder named `i don't like endings`.

Happy typsting!
