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
I created GarudRecon in 2022 but I deleted because some of api keys leaked here someone forked [GarudRecon](https://github.com/polling-repo-continua/GarudRecon)

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

## Usage

<details open>
  <summary><b>garudrecon -h</b></summary>

```
GarudRecon - Recon Automation Framework
A longer description that spans multiple lines and likely contains
examples and usage of using your application. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.

Usage:
  garudrecon [command]

Available Commands:
  install                 A brief description of your command
  smallscope              A brief description of your command
  mediumscope             A brief description of your command
  largescope              A brief description of your command
  cronjobs                A brief description of your command

Flags:
  -h, --help     help for garudrecon
  -v, --version  Show version

Use "garudrecon [command] --help" for more information about a command.
```
</details>


<details open>
  <summary><b>garudrecon smallscope -h</b></summary>

```
```
</details>


<details open>
  <summary><b>garudrecon mediumscope -h</b></summary>

```
This command utilizes a web scraping approach to collect subdomains of the specified domain.

Usage:
  garudrecon mediumscope [flags]

Flags:
  -rx, --recon-xss                      Run full recon with XSS checks"
  -rs, --recon-sqli                     Run full recon with SQLi checks"
  -rl, --recon-lfi                      Run full recon with LFI checks"
  -rst, --recon-subtakeover             Run full recon with Subdomain Takeover checks"
  -rr, --recon-rce                      Run full recon with RCE checks"
  -ri, --recon-iis                      Run full recon with IIS checks"
  -h, --help                            help for mediumscope

Example:
# Full recon
  garudrecon mediumscope -d dell.com

# Recon with XSS only
  garudrecon mediumscope -d dell.com -rx

# Recon with SQLi only
  garudrecon mediumscope -d dell.com -rs

# Exclude functions manually
  garudrecon mediumscope -d dell.com -ef "SUBFINDER,AMASS"

# Combined
  garudrecon mediumscope -d dell.com -rx -ef "AMASS"
```
</details>


<details open>
  <summary><b>garudrecon largescope -h</b></summary>

```
```
</details>


<details open>
  <summary><b>garudrecon cronjobs -h</b></summary>

```
This command utilizes a web scraping approach to collect subdomains of the specified domain.

Usage:
  garudrecon cronjobs [flags]

Flags:
  -d, --domain                  Domain to monitor
  -f, --function                Function to run (e.g. MONITOR_SUBDOMAIN)
  -h, --help                    help for cronjobs

Example:
  garudrecon cronjobs -d domain.com -f MONITOR_SUBDOMAIN
  garudrecon cronjobs -d domain.com -f MONITOR_PORTS
  garudrecon cronjobs -d domain.com -f MONITOR_ALIVESUBD
  garudrecon cronjobs -d domain.com -f MONITOR_JS
  garudrecon cronjobs -d domain.com -f MONITOR_JSLEAKS
```
</details>


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
