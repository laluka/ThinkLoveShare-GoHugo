# Desctiption

This github contains the sources for thinkloveshare.com
This project is using hugo and github pages.

# Helpers hugo_
```bash
# Serve the site so you can debug
./hugo_serve.sh
# Add all changes and commit on source & prod
./hugo_publish.sh GIT_COMMIT_MESSAGE
```

# How to contribute
```bash
git clone https://github.com/ThinkLoveShare/sources
cd sources
# Make changes
git status
git add .
git commit -a -m "I did THAT_THING on THIS_FILE"
git push
```

# Format to use
Hugo syntax : https://sourceforge.net/p/hugo-generator/wiki/markdown_syntax

Extended md : https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

```html
<!-- Custom images size -->
<img class="img_{full,big,med,small}" alt="image_name" src="img.ext" >
```

# How to test locally

```bash
# Install hugo : https://github.com/gohugoio/hugo
# In sources :
rm -rf resources; hugo serve
# Reach http://localhost:1313/
```

# Expose local webserver to the world
```bash
sed -i "s/.*GatewayPorts.*/GatewayPorts yes/g" /etc/ssh/sshd_config
ssh -R 0.0.0.0:1313:127.0.0.1:1313 USER@RHOST
hugo serve --baseURL=http://RHOST/
```

# How to deploy
```bash
# In sources :
git clone git@github.com:ThinkLoveShare/ThinkLoveShare.github.io.git
/bin/rm -rf resources ThinkLoveShare.github.io/*
hugo -d ThinkLoveShare.github.io/ -b https://thinkloveshare.com/
cd ThinkLoveShare.github.io/
git add .
git commit -a -m "I did THAT_THING on THIS_FILE"
git push
# Reach https://thinkloveshare.com/
# Usually, deploy time takes less that one minute.
```
