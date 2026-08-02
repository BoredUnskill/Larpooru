(DISCLAIMER! Yes, this shit is made with AI, cuz' i a dummy who can't code. Maybe i will make another fork in future, but not now. If you hate AI, just don't use it, lol)
# Larpooru

Super-fast, lightweight flat-file Booru software, fork of [Xenooru](https://github.com/s-vhs/Xenooru/). Kept very minimalistic and simple but highly customizable and extendable.

Why i created this fork? Because original Xenooru wasn't finished, so i decided to done some thing with help of Claude.ai.
Yep, this shit is vibecoded, so use it on your own risk. I don't plan on maintaining this shit neither.

## Features

- It's a Booru: Account, Forum, Posting, Commenting, everything included!
- Moderation: All features you need to keep your Booru and its users healthy!
- Super fast: Designed for a fast performance and few dependencies!
- Template-engine: Creating and customize different themes has never been easier!
- Language-system: Create any language-file, translate it and users can use it!
- Flat-file Database: Easy to read, upgrade, edit and uses cache to accelerate the software!

## Installation

- Clone this repository
- Customize `/core/config.php`
- Make `/public/` the root-directory from the webserver
- Create an account
- The basic-installation is done, for further details, read the documentation

(p.s. if you use free hosting like InfinityFree, don't delete .htaccess file! delete it only if you have your own VPS or homelab)

## Documentation

[Documentation at the GitHub Wiki](https://github.com/s-vhs/Xenooru/wiki)

## Support

For support, email me at [thencametears@yandex.com](mailto:thencametears@yandex.com) or join the [Team H33T Support-Discord](https://discord.gg/uahG2fKVvg), my username on Discord is `Forsaken Maiden` or whatever, go figure it out yourself.

## Demo

[x3n00ru.h33t.moe](https://x3n00ru.h33t.moe) - Official Dead Instance of original Xenooru.

[lainxg.xo.je](https://lainxg.xo.je) - My Instance Of Larpooru

## License

[GPL-3.0 license](https://github.com/s-vhs/Xenooru/blob/main/LICENSE)

## Authors

- [@s-vhs](https://www.github.com/s-vhs)
- [@saintly2k](https://www.github.com/saintly2k)

## Technologies used

- [claviska/SimpleImage](https://github.com/claviska/SimpleImage) for Thumbnail-generation for images
- [JamesHeinrich/getID3](https://github.com/JamesHeinrich/getID3) to get Image/Video-dimensions and filesize
- [rakibtg/SleekDB](https://github.com/rakibtg/SleekDB) as Database-software
- [smarty-php/smarty](https://github.com/smarty-php/smarty) as template-engine
- [FFmpeg](https://ffmpeg.org) for Thumbnail-generation for videos
