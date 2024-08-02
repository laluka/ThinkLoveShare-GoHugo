---
author: "Laluka"
title: "New York, Datadog and I - Week 3 to 6"
slug: "new_york_datadog_and_i_week_3_to_6"
date: 2019-03-16
description: "Third article about my trip to New-York. Datadog parties, cool rooftop, visiting with Marine, api endpoints sanitization, vagrant and ansible, finding a home AGAIN... And pics!"
---


# Datadog parties

A few times a month, parties are organized either at work, or in cool places nearby by the company.
So far, I joined three times. Once to taste some whiskey, once to build our own terrarium and eat hand-made sushis, and once to go to a big-games bar. And every event was a huge success! :D

<img class="img_big" src="sushi.jpg", alt="sushi">
<img class="img_big" src="plant.jpg", alt="plant">

There are many interns, and the vibes are always chill / funny. I used to make fun of corporate culture, but in the end... It's not that bad when it's done the right way!

<img class="img_big" src="party_pics.jpg", alt="party_pics">

The games were pretty cool and so was the music (house / EDM), but damn, playing ping-pong midly drunk is hard!

<img class="img_big" src="party_pup_ping_ping.jpg", alt="party_pup_ping_ping">
<img class="img_big" src="party_pup_connect_four.jpg", alt="party_pup_connect_four">


# Game-night and rooftop

I've been invited by a friend to have a video-games night with her friends. We played a bit, enjoyer the -delicious- cocktails done by her boyfriend, and then went to a rooftop bar. It was entertaining, classy, but sadly, WAY TOO COLD outside to stay for long.

<img class="img_big" src="rooftop_mirror.jpg", alt="rooftop_mirror">
<img class="img_big" src="rooftop_outdoor.jpg", alt="rooftop_outdoor">

But the best part was... The urinals! You're in a good mood, had a few drinks, need to take a break, and you go in the restroom to find this super-cute candle-lighted place. How cute and unexpected is that? :')

<img class="img_big" src="rooftop_urinal.jpg", alt="rooftop_urinal">


# Visiting with Marine

It's all in the title: Marine came from the 1st to 10th of March. We visited many places and walked quite a lot even tho it was freezing outside. Every tourist take the same pictures, it's quite lame, don't you think? Well, I do. But hey who cares, here are ours! `¯\_(ツ)_/¯`

<img class="img_big" src="liberty_cliche.jpg", alt="liberty_cliche">
<img class="img_big" src="liberty_hug.jpg", alt="liberty_hug">

A few months ago, we saw this cool Netflix show 'Atypical' about an autistic teenager trying to figure out how life and relations work. There's a scene where he smiles, and someone explains him calmly and seriously that his smile should be only 70% of his current one to look great. In the show, he smiles... A bit like us (sadly, we're not as good as this actor). So this became our thing: If you don't look good enough, smile as hard as you can and hopefully you'll look weird enough to make the picture great again!

Anyway, if you haven't seen this show, you should give it a try! ;)

<img class="img_big" src="autistic_smile.jpg", alt="autistic_smile">

We went to times square, and also to the Top Of The Rock (mid-high building in front of Central Park). If was freezing in the street but once up there, there was no wind because of the glass panels, and the sun was hitting hard so it was really pleasant to stay for a while. And if you zoom a bit you'll notice... SMILE! :D

<img class="img_big" src="times_square.jpg", alt="times_square">
<img class="img_big" src="totr_smile.jpg", alt="totr_smile">

While going to the One World Trade Center (building constructed after the fall of the twin towers), we saw this gigantic monster, which is a shops + metro station place. Its looks crazy, it's huge outside, and even bigger inside!

<img class="img_big" src="monster_out.jpg", alt="monster_out">
<img class="img_big" src="monster_in.jpg", alt="monster_in">

Then we took a break to go to a Korean SPA. We were (well, mainly I was) a bit sick because of the weather, so the warmth was more than welcome. The view we had on New-York while in the extra hot swimming pool was super nice, but we were really shocked to realize that most of the folks in here were only posing and taking pictures. I mean, we took a bunch of pics for the memories, but some stayed for hours just taking the same picture over and over of themselves in the same pose, they seemed to not even care about the pool / sight, just the social-media fame, and it was... Strange...

<img class="img_big" src="spa_her.jpg", alt="spa_her">
<img class="img_big" src="spa_him.jpg", alt="spa_him">

A friend of mine joined us to visit the Natural Museum of History. We were a bit tired but really happy to follow him and see how amazed he was. I think that I liked the most this day was him and his happiness and not the museum itself! Julien, if you read this, don't change a thing, stay the grown-up child that you are, you rock! `^.^`

<img class="img_big" src="carayol.jpg", alt="carayol">
<img class="img_big" src="badass_tree.jpg", alt="badass_tree">

Last but not least, here's an extra-classy picture of New-York that Marine took the first day:

<img class="img_big" src="black_white_nyc.jpg", alt="black_white_nyc">


# Work related

Weeeeell, life's cool, but work matters too... Right?
I've been working on two main things:

### API endpoints input sanitization

Input sanitization is something important wherever you go, whatever you do. It basically means "Check that no one gives you erroneous nor malicious data". In life, we care: not eating rocks instead of fruits, not letting random people come in your house, or even wearing a condom. What comes inside needs to be whitelisted. It's exactly the same idea in security. Every time someone submits data to us, we sanitize it to be sure everything will be fine and that we're not attacked. To do so, we mainly use (in this project, as far as I know) a json schema that describes the expected inputs, and then we match the request data against it. If the request is malformed, we reject it.

While checking how some checks were done, I realized that the email validation only consisted in dummy checks.

```python
def validate_email(email):
    return isinstance(email, str) and "@" in str
```

I really felt like "WTF, this isn't enough AT ALL" and tried to create a pull request to improve that, but while digging in this github repository, I saw a closed issue on this topic, and this is what I found: A mind-blowing 5mn read!

Have fun, it's gold-certified material.

https://hackernoon.com/the-100-correct-way-to-validate-email-addresses-7c4818f24643


### Automated deployment of a vulnerable web-application

The work done here implies many pre-existing private repositories used in Datadog, so I can't explain everything, but it basically implies terraform scripts that will setup AWS accounts for us. The part I worked on was mainly using Ansible (cookbooks) and Vagrant for local testing (replace amazon EC2 instances).

Vagrant is a virtualization software that one can use for many things:

- Have a coding / hacking environment setup on any OS
- Have a VM that you can crash and trash anytime
- Do some infrastructure testing with many hosts
- So much more, honeypot, software behavior analysis, ...

Ansible is a super cool tool that helps you provision automatically different services and files on a local or remote system using cookbooks. Cookbooks contains just the description of what needs to be done, ansible does the rest, so it feels like "Configuration File As An Infra". It's super convenient and the code-base is pretty clean as it's developed by RedHat.

Here are some useful / interesting resources about them:

- https://www.vagrantup.com/
- https://www.ansible.com/
- https://sysadmincasts.com/episodes/43-19-minutes-with-ansible-part-1-4
- https://sysadmincasts.com/episodes/45-learning-ansible-with-vagrant-part-2-4
- https://sysadmincasts.com/episodes/46-configuration-management-with-ansible-part-3-4
- https://sysadmincasts.com/episodes/47-zero-downtime-deployments-with-ansible-part-4-4


# Finding a home AGAIN

My roommate boss had money. A lot of it, but it seems that he lost most of it in stock exchanges. So he `had` money. Thus his private pilot, cook and probably others employee has been fired. Adrian seems to be OK with that as he really likes nature, and New-York definitely isn't a great place for him, so he's on the road again, soon traveling around the world!

But this means for me that I have to either find a new roommate as soon as possible or leave the apartment by 1st of May. This sucks, I want to keep this place, so... If you know anyone looking for a peaceful and beautiful place to say near New-York... Let them know... M'okay?


# Random thoughts

Wherever you are, whoever you are, visio-conferences can and will fail at some point. It's super funny to have 30 engineers trying to fix a TV all together with live tips and laughs from remote workers!

<img class="img_big" src="video_conf.jpg", alt="video_conf">

While traveling to White plaines, I missed my train stop and arrived right to Valhalla. It felt really strange to reach valkyries paradise just like that in 5 minutes, just like that, by missing a single stop...

<img class="img_big" src="valhalla.jpg", alt="valhalla">

Later that day, we went by a painting course where some gems were waiting for us.

<img class="img_big" src="art.jpg", alt="art">
<img class="img_big" src="bob_ross.jpg", alt="bob_ross">

I hope that you had a great day / week / month, and if you did not, remember that for at least one people in earth,

<img class="img_big" src="one_in_a_melon.jpg", alt="one_in_a_melon">

See you (more or less) soon, take care! ;)


<h2 id="fr">French version</h2>


# Soirées Datadog

Plusieurs fois par mois, des soirées sont organisées par Datadog, soit dans les locaux, soit dans des endroits sympas à proximité l'entreprise. je n'ai pour le moment participé qu'à trois soirées. La première était une dégustation de whisky, la deuxième un workshop pour réaliser son terrarium et se régaler de sushis faits maison, et la dernière pour aller dans un bar à "grands jeux". Chaque événement fut un grand succès ! :D

<img class="img_big" src="sushi.jpg", alt="sushi">
<img class="img_big" src="plant.jpg", alt="plant">

Il y a beaucoup de stagiaires, et l'ambiance est toujours sympa / posée. J'avais pour habitude de pas mal me moquer des cultures d'entreprise, mais bon... Quand c'est bien fait, c'est quand même vachement bien ! :D

<img class="img_big" src="party_pics.jpg", alt="party_pics">

La soirée et les jeux (bien que classiques) étaient cool, la musique (house / EDM) aussi, mais gosh, jouer au ping-pong en ayant bu c'est pas simple !


<img class="img_big" src="party_pup_ping_ping.jpg", alt="party_pup_ping_ping">
<img class="img_big" src="party_pup_connect_four.jpg", alt="party_pup_connect_four">


# Soirée jeux-vidéo et rooftop

J'ai été invité par une collègue à une soirée jeux vidéo avec ses potes. Nous avons joué un peu, profité des délicieux cocktails faits par son copain, puis nous sommes allés dans un rooftop. C'était sympa, plutôt classe, mais malheureusement il faisait BEAUCOUP TROP FROID pour vraiment en profiter.

<img class="img_big" src="rooftop_mirror.jpg", alt="rooftop_mirror">
<img class="img_big" src="rooftop_outdoor.jpg", alt="rooftop_outdoor">

La meilleure partie de la soirée a quand même été... La découverte des urinoirs ! Imaginez vous,  de bonne humeur, après quelques verres... Besoin de faire une 'petite pause', après une petite recherche vous tombez sur ce lieu super mignon avec des bougies. Plutôt inattendu, et sacrément bien venu vu le froid ! :')

<img class="img_big" src="rooftop_urinal.jpg", alt="rooftop_urinal">


# Visite avec Marine

Tout est dans le titre : Marine est venue sur New-York du 1er au 10 Mars. Nous avons beaucoup visité et marché mqlgré un froid bien présent. Et oui... Tous les touristes prenent les mêmes photos, c'est assez nul... Vous ne trouvez pas ? Moi oui ! Enfin bref, voici les notres ! `¯\_(ツ)_/¯`

<img class="img_big" src="liberty_cliche.jpg", alt="liberty_cliche">
<img class="img_big" src="liberty_hug.jpg", alt="liberty_hug">

Il y a quelques mois, nous avons dévoré une super série Netflix 'Atypical'. Elle parle d'un ado autiste qui essaye de comprendre 'la vie' et de se faire aux relations humaines. Une scène nous a marquée, dans celle ci il offre un sourire béat, et quelqu'un lui explique gentiment mais avec sérieux que pour être plus harmonieux / moins choquant, il faudrait qu'il ne sourie qu'à environ 70% de son sourire actuel... Un peu comme nous (mais on est bien moins bon que l'acteur). C'est donc devenu notre private joke : si tu te sait moche, souris le plus fort possible pour qu'à défaut d'être beau, ce soit drole !

Si vous n'avez pas encore vu cette série, foncez ! ;)

<img class="img_big" src="autistic_smile.jpg", alt="autistic_smile">

Plus tard dans la semaine, nous sommes allés à Time Square, puis nous sommes montés au Top Of The Rock (building de taille mmoyenne / haute,  juste en face de Central Park). Il faisait froid dans la rue mais une fois là haut il n'y avait plus de vent du tout grâce aux panneaux de verre. Le soleil tapait -pour un jour d'hivers- assez fort donc c'était super agréable de pouvoir profiter de la vue sans geler sur place. Si vous zoomez un peu, vous pourez remarquer... Dat SMILE ! :D


<img class="img_big" src="times_square.jpg", alt="times_square">
<img class="img_big" src="totr_smile.jpg", alt="totr_smile">

En allant au One World Trace Center (building construit en remplacement des Tours Jumelles), nous avons vu cet immense monstre architectural qui est à la fois un centre commercial et une station de metro. C'est impressionant, c'est grand de l'extérieur, et encore plus vu de l'intérieur !

<img class="img_big" src="monster_out.jpg", alt="monster_out">
<img class="img_big" src="monster_in.jpg", alt="monster_in">

Ensuite nous avons fait une bonne pause dans un SPA coréen. Nous étions (bon, ok surtout moi) un peu malade à cause du froid, donc cette chaleur était plus que bien venue. La vue que nous avions sur New York depuis la piscine chauffée extérieue était magnifique mais nous avons été plutôt choqués en nous rendant compte que la majorité des gens autour de nous n'étaient là que pour prendre la pause et se prendre en photo... Certes, nous avons fait quelques  photos aussi, mais pendant 5mn. Ils taient très nombreux à passer des heures à prendre des selfies, identiques, dans la même pose, ils ne semblaient même pas profiter de la piscine et de la vue et se souciaient seulement de leur apparence et likes sur réseaux sociaux... Plutôt perturbant...


<img class="img_big" src="spa_her.jpg", alt="spa_her">
<img class="img_big" src="spa_him.jpg", alt="spa_him">

Un très bon ami nous a rejoint pour visiter le musée d'histoire naturelle. On était assez fatigués mais très heureux de le suivre et le voir s'émerveiller à chaque nouvelle salle. Je pense que ce que j'ai le plus aimé cette journée c'est ses réactions et sa bonne humeur constante plus que le musée ! Julien, si tu lis ça, ne change rien, t'es parfait ! `^.^`


<img class="img_big" src="carayol.jpg", alt="carayol">
<img class="img_big" src="badass_tree.jpg", alt="badass_tree">

Et pour finir, voici une photo très stylée de New-York que Marine a prise le premier jour :

<img class="img_big" src="black_white_nyc.jpg", alt="black_white_nyc">


# A propos du travail

Boooon, la vie est cool, mais le travail compte aussi... N'est-ce pas ?


### API endpoints input sanitization

L'input sanitization est quelque chose d'important où que vous alliez, quoi que vous fassiez. Cela signifie, en gros, qu'il est plus que judicieux de vérifier que personne ne donne (à manger) à votre programme de données erronées ou malveillantes. Dans la vie, nous faisons attention de ne pas manger un cailloux au lieu d'un fruit, de ne pas laisser entrer n'importe qui chez soi ou encore d'utiliser un preservatif en cas de rapport (Exemple tout a fait valide huhu). Ce qui est autorisé doit être whitelisté / authorisé, et refusé sinon. C'est la même idée en sécurité informatique. A chque fois que quelqu'un veut nous soumettre des données, nous les analysons pour nous assurer que tout est normal et que ce n'est pas une tentative d'attaque. Pour cela, nous utilisons principalement (pour ce projet du moins) un schéma json qui décrit les données attendues et les compare ensuite aux données de la requête. Si la requête n'est pas conforme, elle est rejetée, et on passe a la suivante.

En vérifiant comment certains checks étaient effectués, je me suis rendu compte que la validation d'un email se limite à la vérification suivante...


```python
def validate_email(email):
    return isinstance(email, str) and "@" in str
```

Réflexion immédiate "WTF, c'est pas assez, genre pas assez du tout !". J'ai donc voulu créer une pull requeste pour améliorer cela, mais en cherchant plus dans ce repo github, j'ai vu issue 'résolue' à sur ce sujet, et voilà ce que j'y ai trouvé : un article 1kr0y4ble (5mn) !

Profitez en bien, c'est vraiment du pain béni.

https://hackernoon.com/the-100-correct-way-to-validate-email-addresses-7c4818f24643


### Déploiement automatisé d'une application web vulnérable

Ce projet implique de nombreux repo privés utilisés à Datadog, donc je ne peux pas tout expliquer / montrer, mais il s'agit essentiellement de scripts terraform qui vont configurer ds environment dans des comptes AWS à notre place. La partie sur laquelle j'ai travaillé utilise principalement Ansible (cookbooks) et Vagrant pour les tests en local (remplacer les instances amazon EC2).

Vagrant est un logiciel de virtualisation que l'on peut utiliser pour beaucoup de choses :

- Avoir un environnement de développement / hack fonctionnant sur n'importe quel OS
- Avoir une machine virtuelle que vous pouvez détruire (Oops) et jeter à tout moment
- Effectuer des tests d'infrastructure avec de nombreux hôtes
- Bien plus encore, honeypot, analyse de comportement de logiciel, ...

Ansible est un outil également très bien fait, qui permet de provisionner automatiquement différents services et fichiers sur un système, local ou remote, en utilisant des cookbooks (livres de recettes). Les cookbooks contiennet la description de ce qui doit être fait, Ansible fait le reste, ca ressemble plus ou moins à du "Configuration File As An Infrastructure". C'est super pratique et la code-base est assez propre car elle est développée par RedHat.

Voici quelques ressources utiles / intéressantes :

- https://www.vagrantup.com/
- https://www.ansible.com/
- https://sysadmincasts.com/episodes/43-19-minutes-with-ansible-part-1-4
- https://sysadmincasts.com/episodes/45-learning-ansible-with-vagrant-part-2-4
- https://sysadmincasts.com/episodes/46-configuration-management-with-ansible-part-3-4
- https://sysadmincasts.com/episodes/47-zero-downtime-deployments-with-ansible-part-4-4


# Trouver une maison... ENCORE

Le patron de mon coloc avait de l'argent... Beaucoup. Mais il semble qu'il en ait perdu en bourse. Il `avait` donc de l'argent. Ainsi plusieurs employés (pilote privé, cuisinier et probablement d'autres...) ont été licensiés. Adrian n'a pas mal pris cette nouvelle car il aime la nature, et la vie new yorkaise n'est "pas vraiment" idéale pour ca... Alors il reprend la route et s'en va voyager de par le monde, là où le vent le porte.

De mon côté, je dois soit trouver un nouveau coloc le plus vite possible, soit quitter l'appartement avant le 1er Mai. C'est nul ! J'aimerais vraiment rester dans ce beau lieu donc... Si jamais vous connaissez quelqu'un qui cherche un endroit paisible et joli pas loin de New York... Faites passer le mot... M'okay ?


# Pensées diverses

Où que vous soyez, qui que vous soyez, les visioconférences peuvent et vont échoueront à un moment ou l'autre. C'est plutôt drôle d'avoir 30 ingénieurs qui essaient de réparer un téléviseur avec des conseils et rires en direct des télé-travailleurs ! :D

<img class="img_big" src="video_conf.jpg", alt="video_conf">

Alors que je me rendais à White Plaines, j'ai raté mon arrêt de train et je suis arrivé directement au Valhalla. C'était vraiment étrange d'atteindre le paradis des valkyries comme ça en 5 minutes, juste comme ca, en rattant un arrêt...

<img class="img_big" src="valhalla.jpg", alt="valhalla">

Plus tard dans la journée, nous sommes passés par une salle de cours de peinture où quelques perles nous attendaient.

<img class="img_big" src="art.jpg", alt="art">
<img class="img_big" src="bob_ross.jpg", alt="bob_ross">

J'espère que vous avez eu une belle journée / semaine / mois, et si ce n'est pas le cas, n'oubliez pas que :

<img class="img_big" src="one_in_a_melon.jpg", alt="one_in_a_melon">

A (plus ou moins) bientôt, prenez soin de vous ! ;)
