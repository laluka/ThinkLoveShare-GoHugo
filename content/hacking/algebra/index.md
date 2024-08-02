---
author: "Laluka"
title: "CSAW - Algebra"
slug: "algebra"
date: 2018-09-16
description: "Miscellaneous challenge that encourage the CTFer to either code an equation solver, of use one already existing. "
---


### Description

> Are you a real math wiz?

> nc misc.chal.csaw.io 9002


### TL;DR

This challenge consists in equations being thrown at us that we have to solve
and send the result in order to get the flag. Python and sage, I invoke you !


### Methology

A friend I was talking with while solving this chall told me :

>Well, the equations are simple, let's write a quick script to solve it !

Hearing that, I went like :

>Hum... Hum no. That's not how it works, they wouldn't give 100 points for that...

During CSAW 2017 quals, there was an other Misc I worked on, and the questions (bank card number to compute) were getting harder and harder, so I knew we had to find a better way to solve it automatically. So I took my worst coding skills, and used `popen` and `eval` like I it was my last day on earth.

Here's the result, 10mn coding ! :)


```python
#!/usr/bin/env python2

from pwn import *
import os

r = remote("misc.chal.csaw.io", 9002)

while True:
    try:
        data = r.recvuntil("equal?: ")
        line = [line for line in data.splitlines() if "=" in line][0]
        print "\n" + line
        out = os.popen("sage -c \"var('X'); print solve([" + line.replace("=", "==") + "], X)\"").read()
        answer = out.split("== ")[1].split("\n")[0]
        print answer
        if "/" in answer: # Sage does not simplify, so python will do it ! :)
            answer = eval(answer.replace("/", "/float(") + ")")
            print answer
        r.sendline(str(answer))
    except:
        print "out", out # In case of failure, please tell us why...
        r.interactive()
```

Just so you can laugh a bit, here are the first and last equations...

If I had to code something that can handle that... I would... I would not.

<img class="img_full" src="simple.png" alt="simple" >
<img class="img_full" src="hard.png" alt="hard" >

The flag is : __flag{y0u_s0_60od_aT_tH3_qU1cK_M4tH5}__


<h2 id="fr">French version</h2>


### Description

> Êtes-vous un vrai magicien ?

> nc misc.chal.csaw.io 9002


### TL;DR

Ce challenge consiste à recevoir des équations à résoudre puis envoyez le résultat afin d'obtenir le flag. Python et Sage, je vous invoque !


### Methologie

Un ami avec qui je parlais pendant que je codait ma solution à ce problème m'a dit :

> Bah, les équations sont simples, on a qu'à faire un script rapide (et sale) pour les résoudre !

En entendant ça, je me suis dit :

> Hum... Non. Ce n'est pas comme ça que ça marche, ils ne donneraient pas 100 points pour si peu...

Pendant les quals du CSAW 2017, j'ai travaillé sur un autre challenge misc, et les questions n'étaient pas des équations à résoudre mais des numéro de carte bancaire à générer, avec de plus en plus de contraintes (provenance, banque, numéro commencant par XXYY, ...), donc je me doutais que les équations de fin ne seraient pas aussi triviales. Il fallait trouver un meilleur moyen pour les résoudre automatiquement. Alors j'ai pris mes pires habitudes de développeur et j'ai utilisé `popen` et `eval` comme si c'était mon dernier jour sur terre.

Voici le résultat, 10mn de codage ! :)

```python
#!/usr/bin/env python2

from pwn import *
import os

r = remote("misc.chal.csaw.io", 9002)

while True:
    try:
        data = r.recvuntil("equal?: ")
        line = [line for line in data.splitlines() if "=" in line][0]
        print "\n" + line
        out = os.popen("sage -c \"var('X'); print solve([" + line.replace("=", "==") + "], X)\"").read()
        answer = out.split("== ")[1].split("\n")[0]
        print answer
        if "/" in answer: # Sage does not simplify, so python will do it ! :)
            answer = eval(answer.replace("/", "/float(") + ")")
            print answer
        r.sendline(str(answer))
    except:
        print "out", out # In case of failure, please tell us why...
        r.interactive()
```

Juste pour que vous puissiez rire un peu, voici la première et la dernière équation...

Si je devais coder quelque chose qui peut gérer ça... Je... Je m'abstiendrais.

<img class="img_full" src="simple.png" alt="simple" >
<img class="img_full" src="hard.png" alt="hard" >

Le flag est : __flag{y0u_s0_60od_aT_tH3_qU1cK_M4tH5}__
