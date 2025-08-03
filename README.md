<h1 align="center">
  <img src="img/GarudRecon_banner2.png" alt="GarudRecon"></a>
</h1>

<p align="center">
<a href="#"><img src="https://madewithlove.org.in/badge.svg"></a>
<a href="https://ko-fi.com/rix4uni"><img src="https://img.shields.io/badge/buy%20me%20a%20ko--fi%20-donate-red"></a>
<a href="https://x.com/rix4uni"><img src="https://img.shields.io/badge/twitter-%40rix4uni-blue.svg"></a>
<a href="https://github.com/rix4uni/GarudRecon/issues"><img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat"></a>
<a href="https://github.com/rix4uni/GarudRecon/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>
<a href="#"><img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg"></a>
<a href="https://github.com/rix4uni?tab=followers"><img src="https://img.shields.io/badge/github-%40rix4uni-orange"></a>
</p>

## GarudRecon

An automated recon tool for asset discovery and vulnerability scanning using open-source tools. Supports XSS, SQLi, LFI, RCE, IIS, Open Redirect, Swagger UI, .git exposures and more.

## History
I created Garudrecon in 2022 but I deleted because some of api keys leaked here someone forked [Garudrecon](https://github.com/polling-repo-continua/GarudRecon)

After that i tried in python, golang but i did'nt liked "String Concatenation", so i came back to bash again.

### Referral Links

<p align="center">
<a href="https://m.do.co/c/43c704381b79" target="_blank">
<img src="img/referrals/digitalocean_200.png"/>
</a>
</p>

<p align="center">
<a href="https://login.linode.com/signup" target="_blank">
<img src="img/referrals/linode.png"/>
</a>
</p>

<p align="center">
<a href="https://cloud.ibm.com/docs/overview?topic=overview-tutorial-try-for-free" target="_blank">
<img src="img/referrals/ibm_cloud.png"/>
</a>
</p>

<p align="center">
<a href="https://aws.com" target="_blank">
<img src="img/referrals/aws.png"/>
</a>
</p>

<p align="center">
<a href="https://azure.com" target="_blank">
<img src="img/referrals/azure.png"/>
</a>
</p>

## Installation

### Docker
```

```

### Easy Install
```
bash <(curl -s https://raw.githubusercontent.com/rix4uni/GarudRecon/main/configure)
```

## Usage Examples

### smallscope

```bash
┌──(root㉿kali)-[/root/.garudrecon]
└─# bash smallcope.sh target.com
```

### mediumscope

```bash
┌──(root㉿kali)-[/root/.garudrecon]
└─# bash mediumscope.sh target.com
```

### largescope

```bash
┌──(root㉿kali)-[/root/.garudrecon]
└─# bash largescope.sh target.com
```

## Demo

## Operating Systems Supported

| OS         | Supported | Easy Install | Tested        |
| ---------- | --------- | ------------ | ------------- |
| Ubuntu     | Yes       | Yes          | Ubuntu 24.04  |
| Kali       | Yes       | Yes          | Kali 2025.2   |
| Debian     | Yes       | Yes          | No		    |
| Windows    | Yes       | Yes          | WSL Ubuntu 	|
| MacOS      | Yes       | Yes          | No    		|
| Arch Linux | Yes       | No           | No            |
|            |           |              |               |

## Change Values According to you systems ram

| NAME                 | 1GB RAM | 2GB RAM | 4GB RAM | 8GB RAM | Description                                                                                |
| -------------------- | ------- | ------- | ------- | ------- | ------------------------------------------------------------------------------------------ |
| IS_U_USING_VPS       | Yes     | Yes     | Yes     | Yes     | If you running this tool on vps change `IS_U_USING_VPS="FALSE" into IS_U_USING_VPS="TRUE"` |
| AMASS                | No      | Yes     | Yes     | Yes     |                                                                                            |
| BBOT                 | No      | Yes     | Yes     | Yes     |                                                                                            |
| FFUFBRUTE            | No      | Yes     | Yes     | Yes     | Got from https://x.com/ArmanSameer95/status/1680811916053078019                            |
| Screenshotting Tools | No      | Yes     | Yes     | Yes     |                                                                                            |
| VULNTECHX            | No      | No      | Yes     | Yes     | Finds Vuln Based on website tech                                                           |
| PYXSS                | No      | Yes     | Yes     | Yes     | Checks XSS False Positive                                                                  |
| GALER                | No      | No      | Yes     | Yes     |                                                                                            |

## Tools

### Subdomain Enumeration
- BugBountyData
- subfinder
- amass
- subdog
- xsubfind3r
- findomain
- chaos
- github-subdomains
- bbot
- oneforall
- shosubgo
- assetfinder
- haktrails
- haktrailsfree
- org2asn
- ipfinder
- ipranges
- arinrange
- spk
- analyticsrelationships
- udon
- builtwithsubs
- whoxysubs

### Certificate Transperency
- kaeferjaeger
- trickestcloud
- cero
- certinfo
- csprecon
- cspfinder
- jsubfinder
- dnsxbrute
- subwiz

### Subdomain Permutations
- altdns
- puredns
- alterx
- gotator
- dnsgen
- goaltdns
- ripgen
- dmut

### Subdomain Resolving
- puredns
- shuffledns
- massdns

### Subdomain DNS Enumeration
- dnsx

### Port Scanning
- naabu
- masscan
- rustscan
- nmap

### Subdomain Probing
- httpx

### Subdomain Bruteforcing
- subdomainfuzz

### VHOST Dicovery
- ffuf

### Favicon Lookup
- favinfo
- favirecon

### Screenshotting
- gowitness
- aquatone
- eyewitness
- httpx

### Directory Enumeration
- ffuf
- dirsearch
- feroxbuster
- wfuzz

### Email Enumeration
- emailfinder

### Url Crawling
- waymore
- hakrawler
- waybackurls
- katana
- gau
- gospider
- uforall
- cariddi
- urlfinder
- github-endpoints
- xurlfind3r
- xcrawl3r
- crawley
- GoLinkFinder
- galer
- gourlex
- pathfinder
- pathcrawler
- roboxtractor
- robotxt

### Google Dorking
- gorker

### JS Crawling
- subjs
- getJS
- jscrawler
- jsfinder
- javascript-deobfuscator
- linkfinder
- xnLinkFinder
- getjswords
- sourcemapper
- linx
- jsluice

### Hidden Parameter
- paramfinder
- msarjun
- x8

### Program Based Wordlist Generator
- cewl
- unfurl
- cook
- pydictor

### Subdomain Takeover
- subzy
- nuclei

### MX Takeover
- mx-takeover

### DNS takeover
- dnstake

### Zone Transfer
- dig

### Vulnerability Scanning
- ftpx
- sshx
- s3scanner
- vulntechx
- pvreplace
- xsschecker
- pyxss
- gosqli
- commix
- goop
- pdftotext
- trufflehog
- secretfinder
- mantra
- shortscan
- linkinspector
- brutespray

## Thanks 🙏
_Thanks for creating awesome tools [Thanks](docs/Thanks.md)_

## Mindmap/Workflow
_See Workflow in different format [Workflow](Workflow)_

<p align="center"> 
<a href="Workflow/Scope-Based-Recon.png" target="_blank"> 
<img src="Workflow/Scope-Based-Recon.png"/>
</a>  
</p>
