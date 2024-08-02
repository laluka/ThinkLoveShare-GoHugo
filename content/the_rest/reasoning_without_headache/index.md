---
author: "Laluka"
title: "Reasoning without headache"
slug: "reasoning_without_headache"
date: 2017-03-07
description: "Reasoning is not simple and often leads to a headache or even stress. Here are some personal methods and advices that will hopefully allow you to better experience these research phases. "
---

Today, I propose to take a step back on how to approach problems, research, or even.... Life in general?

## Prologue

What I am going to tell you here is common sense to me, but it took me years to adopt these few methods, and even then, sometimes I forget to use them and quickly regret it.

I will therefore present some ideas and techniques that will serve you in your studies (cuckoo math and physics that hurts!), in your work (cuckoo administration, market', research,...), or in your passion (hello there fellow hacking challenges that take daysssss <3).

<img class="img_med" src="head.png" alt="head">

## HowTo

#### What I have, what I want, what I need in between

The name of this first point is quite explicit, a new problem? A new question? Reflex!

  1. I take what I need to write, I mark all the information, the means at my disposal in the first place.

  2. I mark at the bottom of the sheet (paper, word, .txt, whatever...) what I want to reach, my goal.

  3. I mark the possible intermediate steps that can serve as a "checkpoints", to know what has been validated or not, and through which paths one can go to access the same result.

#### Write everything, classify, sort, conclude

This step consists of recording each attempt, briefly, to find out what has been done or not, what may have worked or not. Once this information has been collected, sort them into small groups and try to draw conclusions and generalizations, but keep every piece of relevant information.

#### Descend from a level of abstraction, understand, ascend

 > Sure ! Wait... What?

 This one is a little confusing, can be explained, but it is much better understood with an example.

 Let's take maths, but kind ones, so we don't upset anyone, okay?

 I used to tutor students from college to high school, and one question that came up very often was this:

 How do powers work?

 I then put a simple line on the board:

 ```
 x^2*x^3 = ?
 ```

 "But I just want to know how it works, not to fail one more time while at the board... \
 -But... You already know how it works, believe me! What *is* x^2 ?
 -x*x\
 -Yes, and what *is* x^3?\
 -x*x*x\
 -All right, now, what if you replace what you don't know with what you already know? "\

 Then appears on the board:

 ```
 x*x*x*x*x
 ```

"And that... You know what it is, isn't it?
-Yes... It's x^5....\

*Piouf! Infinite knowledge!* :O

And that's exactly what this first barbaric sentence means. Take what I don't know, go backward until you reach something you know, or a definition, understand it, and assemble the little pieces until you understand how the studied object works. And the good thing about this technique is that it works with absolutely everything! Our world being made of many small bricks stacked one on top of each other, whether it is in science, philosophy, socio, etc...

Its only weakness is circular dependencies, when the definition of A sends to B, which refers to A, ... And then....

*Program received signal SIGSEGV, Segmentation fault.*

#### Do make diagrams

 > Diagrams save lives. Always

 Every day, every hour, every minute of your life you spend not making a diagram, extremists (religious and atheists all together) kill kittens to make you understand how bad it is.

 Making diagrams is giving yourself a chance to visualize what is happening, easily identify errors in your reasoning, measurement, logic, etc.

 A short tour on the youtube channel [ThreeBlueOneBrown](https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw will allow you to see that diagrams are beautiful, useful, and often necessary for a good understanding (especially in math, physics, info, ...)

#### One can't know everything, but can search about everything

Yup, we live in a world where a multitude of people have been searching (and finding) things in all areas for a very long time. So starting from the principle that we can know everything, discover everything alone, it is unrealistic and even pretentious. So for each new project or challenge, a documentation stage has been done in order to know what is feasible or not. This stage is crucial.

A short quote from OWASP (free and open security community):

 > The first phase in security assessment is focused on collecting as much information as possible about a target application. Information Gathering is the most critical step of an application security test. The security test should endeavour to test as much of the code base as possible. Thus mapping all possible paths through the code to facilitate thorough testing is paramount.

#### Proofreading and Self-feedback

Proofreading: Check that the result obtained is consistent, depending on the case, it can be:

"Is my result the initial objective? "

"Do I have a result in the right unit? Good order of magnitude? Good type? Realistic? "

This will allow students to make a small conclusion proudly announcing: "I did this, but I have enough perspective to know that I made a mistake! Give me a few points pleaseeee! °^° "

And others to review their approach before embarking on further operations with a shaky start, thus saving time, energy, etc....

Self-feedback: Once the reasoning has come to an end, take notes on what you may have done right or wrong, the little details that you missed. That way you'll pay more attention to it next time.

Example: During a CTF, when a challenge makes me download files to analyze / exploit, I tend to rush into the content of the file, and I have already lost days misleaded by my behaviour. A clue was in the name and the date the file, its creation timestamp. I was fooled twice on this point before telling myself "Oops, self-feedback... :x "

Now that I am aware of this issue, I remember not to forget to check these kind of informations first... ^.^

#### Know how to ask for help

Yes, sometimes, even with all these good practices, when it doesn't want to work, it does *not* want to. So knowing how to ask for help is essential, but not always easy. First of all, you have to dare. But even if you dare, there are many points to check before asking.

**MUST** :

 - Explain the problem precisely by specifying what is blocking or not
 - Pay attention to what is and is not disclosable (confidential project, challenge spoil, ...)
 - Explain what has been tried or not, and what the attempts have resulted in
 - Give the context of the tests (OS? Software? Location? Starting axioms? Anything that can affect the search or the result actually... Unsuspected case: The current hour! :D)
 - Remain polite and courteous, always, and thankful for the time spent helping, whether or not the help was helpful in the end... :)

**MUST NOT**:

 - "Iz no workin, aniwai i zuck nd it zuck. "
 - "Can you give me the answer? "
 - "Can you do it for me? "
 - "I've tried everything, so the exercise is broken, not my personal skills. " -> Personal experience... Java exams... Oopsy... :<
 - Spam someone waiting for their help, one must know  how to reason himself, stay stuck some time before asking for help.... (Hello Cyril, once again, sorry... :> )

## Epilogue

Now, with these few methods, you are a little better prepared to handle these tricky problems!

The idea is not to apply them strictly, but to have them as a 'guide-line' and to be able to lean on them when you're stuck, jumping from one to the other until the problem solves itself, and most often it works!

I am not saying that this is the only approach to use, because there are many cases where it cannot or should not apply, but it has served me so much that I can only advise you to keep it in mind for the right time. I'm sure that some day it will prevent you from drowning in a difficult task.

Wishing you a good unstuck reflexion,


<h2 id="fr">French version</h2>


Aujourd'hui, je vous propose une petite prise de recul sur la manière d'aborder un problème, une recherche, ou encore... La vie de manière générale ?


## Prologue

Ce que je vais vous dire ici est à mes yeux du bon sens, mais il m'a fallu lonnnngtemps avant d'adopter ces quelques méthodes, et encore, parfois j'oublie de les utiliser et le regrette vite.

je vais donc vous présenter quelques idées et techniques qui pourront vous servir dans vos études (coucou les maths et la physique qui piquent !), dans votre boulot (coucou l'administration, la comm', la recherche, ...), ou encore dans votre passion (coucou les challenges de hacking qui prennent des jourssss <3 ).

<img class="img_med" src="head.png" alt="head">

## HowTo

#### Ce que j'ai, ce que je veux, ce dont j'ai besoin entre les deux

Le nom de ce premier point est assez explicite, un nouveau problème ? Une nouvelle question ? Reflex !

  1. Je prends de quoi écrire, je marque toutes les informations, les moyens dont je dispose en premier lieu.

  2. Je marque en bas de feuille (papier, word, .txt, whatever...) ce à quoi je veux parvenir.

  3. Je marque les possibles étapes intermédiaires qui peuvent servir de 'point de sauvegarde', pour savoir ce qui a été validé ou non, et par quels chemins l'on peut passer pour accéder au même résultat.

#### Tout écrire, classer, trier, conclure

Cette étape consiste à noter chaque tentative, succintement, pour savoir ce qui a été fait ou non, ce qui a pu fonctionner ou non. Une fois ces informations receuillies, les trier par petits groupes, et essayer d'en tirer des conclusions, des généralisations, mais en gardant toutes les informations.

#### Descendre d'un niveau d'abstraction, comprendre, remonter

 > Oui ! Wait... What ?

Celle-ci est un peu confuse, peut être expliquée, mais on la comprend bien mieux avec un exemple.

Prenons des maths, mais des gentils, comme ça on ne fâche personne, ok ?

Je donnais souvent des cours à des élèves du collège au lycée, et une question qui revenait très souvent était la suivante :

Comment ça marche les puissances ?

Je posais alors une simple ligne au tableau :

```
x^2*x^3 = ?
```

"Mais justement, je veux savoir comment ça marche moi, pas échouer au tableau...\
-Mais... Tu le sais déjà, comment ça marche, crois-moi ! x^2, c'*est* quoi ?\
-x*x\
-Oui, et x^3, c'*est* quoi ?\
-x*x*x\
-Très bien, maintenant, et si tu remplaçais ce que tu ne connais pas par ce que tu connais ? "\

Apparait alors au tableau :

```
x*x*x*x*x
```

"Et ça... Tu sais ce que c'est non ?\
-Oui... C'est x^5...\

*Piouf ! Le savoir infiniii !* :O

Et c'est exactement ce que veut dire cette première phrase barbare. Prendre ce que je ne connais pas, retourner voir les définitions, le comprendre, et assembler les petits morceaux jusqu'à comprendre le fonctionnement des objets de départ. Et ce qui est bien avec cette technique, c'est qu'elle marche avec absolument tout ! Notre monde étant fait de plein de petites briques empilées les unes sur les autres, que ce soit en science, philo, socio, ...

Sa seule faiblesse, c'est les dépendances circulaires, où quand la définition de A envoie à B et celle de B renvoie à A... Et dans ces cas-là...

*Program received signal SIGSEGV, Segmentation fault.*

#### Faire des schémas

 > Les schémas, ça sauve des vies. Toujours.

Chaque jour, chaque heure, chaque minute de votre vie que vous passez à ne pas faire un schéma, des extrémistes (religieux comme athées tkt...) tuent des chatons pour vous faire comprendre à quel point c'est mal.

Faire des schémas, c'est se donner une chance de visualiser ce qu'il se passe, repérer facilement une erreur de raisonnement, mesure, logique, ...

Un petit tour sur la chaine youtube [ThreeBlueOneBrown](https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw vous permettra de voir que c'est beau, utile, et souvent nécessaire à une bonne compréhension (surtout en math, physique, info, ...)


#### On ne peut pas tout connaître, mais on peut tout chercher

Eh oui, on vit dans un monde ou une multitude de gens cherchent (et trouvent) dans tous les sens depuis déjà très longtemps. Donc partir du principe que l'on peut tout savoir, tout trouver, c'est irréaliste, prétentieux même. Donc pour chaque projet, chaque nouveau défi, une période de documentation est nécessaire pour savoir ce qui a été fait, ce qui est possible ou non. Cette phase est crucial.

Petite citation d'OWASP (free and open security community) :

 > La première phase de l'évaluation de la sécurité est axée sur la collecte d'autant d'informations que possible sur une application cible. La collecte d'informations est l'étape la plus critique d'un test de sécurité d'application. Le test de sécurité doit s'efforcer de tester le plus possible de surface. Il est donc primordial de cartographier tous les chemins possibles pour faciliter des tests approfondis.

#### Relecture et auto-contrôle

Relecture : Vérifier que le résultat obtenu est cohérent, suivant les cas, cela peut être :

"Est-ce que mon résultat est bien l'objectif de départ ? "

"Ais-je un résultat dans la bonne unité ? Bon ordre de grandeur ? Bon type ? Réaliste ? "

Ceci permettra aux étudiants de faire une petite conclusion annonçant fièrement : "J'ai fait ça, mais j'ai assez de recul pour savoir que c'est faux ! Quelques points s'iouplai ! °^° "

Et aux autres de revoir leur démarche avant de se lancer dans la suite des opérations avec un départ bancal, donc gain de temps, énergie, etc etc...

Auto-contrôle : Une fois le raisonnement arrivé à son terme, prendre des notes sur ce qu'on a pu bien ou mal faire, les petits détails qui nous ont échappé pour y porter plus attention au prochain coup.

Exemple : Durant un CTF, lorsqu'un challenge me fait télécharger des fichiers à analyser / exploiter, j'ai tendance à foncer sur le contenu du fichier, et j'ai déjà perdu des jours et des jours dans une fausse piste alors que l'indice était tout bêtement dans le nom, ou la date de création du fichier. Je me suis fait avoir deux fois sur ce point avant de me dire "Oops, l'auto feedback... :x "

Maintenant, je sais que j'ai ce problème régulièrement, donc c'est ce que je vérifie en premier... ^.^

#### Savoir demander de l'aide

Eh oui, parfois, même avec toutes ces bonnes pratiques, quand ça veut pas, ça >veut< pas. Donc savoir demander de l'aide est essentiel, mais pas toujours facile. Déjà, il faut oser. Mais même en osant, il y a plein de points à vérifier avant de faire sa demande.

**MUST** :

 - Expliquer le problème avec précision en précisant ce qui est bloquant ou non
 - Faire attention à ce qui est divulgable ou non (projet confidentiel, spoil de challenges, ...)
 - Expliquer ce qui a été tenté ou non, et ce que les tentatives ont donné comme résultat
 - Donner le contexte des tests (OS ? Logiciel ? Lieu ? Axiomes de départ ? Tout ce qui peut affecter la recherche ou le résultat en fait... Cas insoupçonné : l'heure ! :D)
 - Rester poli et courtois, toujours, et remercier du temps consacré, que l'aide ait été utile ou non... :)

**MUST NOT** :

 - "Sa march pa, de tt fason je compren pa. "
 - "Tu peux me donner la réponse ? "
 - "Tu peux le faire pour moi ? "
 - "J'ai tout tenté, donc c'est que c'est l'exo qui est faux" -> Du vécu... Oops partiel de Java... :<
 - Spammer quelqu'un en attente d'aide, il faut savoir se raisonner, bloquer un moment avant de demander... (Coucou Cyril, once again, sorry... :> )

### Epilogue

Voilà, avec ces quelques méthodes, vous voilà un peu mieux armé(e) pour la suite !

L'idée, ce n'est pas de les appliquer à la lettre, mais de les avoir comme 'guide' et de pouvoir s'appuyer dessus quand on patine, en sautant de l'une à l'autre jusqu'à ce que le problème se débloque de lui-même, et le plus souvent, ça marche !

Je ne dis en aucun cas que c'est l'unique approche à utiliser, car il y a bien des cas où elle ne peut ou ne doit s'appliquer, mais elle m'a tellement servie que je ne peux que vous conseiller de la garder en tête pour le moment propice ou elle vous permettra de ne pas vous noyer devant une tache un peu ardue.

En vous souhaitant une bonne non-prise de tête,
