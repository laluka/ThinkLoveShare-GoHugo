# Desctiption

This github contains the sources for thinkloveshare.com
This project is using hugo and github pages.

# GoHugo Helpers

```bash
./hugo_serve.sh
```

# How to Contribute

```bash
git clone git@github.com:laluka/ThinkLoveShare-GoHugo.git
cd ThinkLoveShare-GoHugo
git checkout -b "i_am_foo/doing_bar"
# Make changes
./hugo_serve.sh
git status
git add .
git status
git commit -m "I did THAT_THING on THIS_FILE"
git push
```

# Format to use

- Hugo syntax : https://sourceforge.net/p/hugo-generator/wiki/markdown_syntax
- Extended md : https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- Github CICD : https://github.com/laluka/ThinkLoveShare-GoHugo/actions
- End Website : https://thinkloveshare.com/

```html
<!-- Custom images size -->
<img class="img_{full,big,med,small}" alt="image_name" src="img.ext" >
```
