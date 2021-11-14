# WebmasterCMS - The CMS for Webmasters - Docker
*Lets you have a whale of a time building your website!*

### Overview

*This repository contains the file structure and and instructions for building your [wmcms](https://github.com/neonspectra/wmcms/) website as a Docker image.*

If you are not familiar with wmcms, please [check out the main repository](https://github.com/neonspectra/wmcms/) to get an overview of the project as a whole. The intent of this readme is to discuss the specifics of running wmcms as a Dockerised solution.

Building your wmcms website as a Dockerised solution is the recommended way to use wmcms.

### Docker Philosophy

wmcms uses an all-in-one Docker build philosophy which packages the site contents as part of the output Docker image. This means that you need to rebuild your Docker image every time you push new changes to your site. This also means that it would not make any sense to provide this Docker image as a prebuilt artefact on Dockerhub.

*Excuse me what? Haven't you heard of volumes? Isn't data supposed to live outside of your Docker image?*, you might be asking.

Well, I'm glad you asked. There are several reasons for using this architecture for the wmcms Docker image:
- Once you build a container image, you can deploy that image to as many systems or container registries as you want in one single step. No volume setup or messing around with environment variables necessary!
- Since the output of our Docker build is a single image, it is exceedingly simple to run it locally for testing.
 - wmcms relies on nginx to do the heavy lifting of formatting pages, so you cannot preview your site locally without spinning up an nginx instance to host it. Having a single Docker image gives you a seamless guarantee that the local preview of your site will be identical to how it is hosted in your live environment.
- Version control and continuous integration! Your site data can live in the same version-controlled repository as the build tools and files.
 - New posts to your site can constitute new version releases, and you can set up a CI pipeline against a single repository to automate the build process and push to a container registry. Need to roll your site back to a previous version? No problem! Just flip to another branch and launch one of your older images.

### Included Files

This repository contains several folders. I'll walk you through what each of them contains.
- `site`: This folder contains your webroot and nginx config file for the site. This is all user data, so these are the files that you need to edit to add new stuff to your site. Please review the main [wmcms](https://github.com/neonspectra/wmcms) repository for more information on what the individual files in here are and how to work with them. 
 - Make sure to set your server name in the nginx conf file, too!
- `docs`: This folder has some examples for tags that get styled by the site CSS and a template for making new posts.
 - Remember, posts in wmcms are meant to live in an individualised folder for the post rather than as a singular html file. Don't just copy the index.html file from the template post to make new posts; copy the whole folder and rename it!
- `tools`: This folder contains some bash scripts to help out with SEO.
 - `rsshelper.sh`: This script adds new sites to your rss feed. Make sure to edit the script options as described in the file comments. This script takes a live site URL as an argument, so you probably want to launch a local container of your site, run this script against your new page, then commit the updated rss file to your repository.
  - *Note: At some point I want to refactor this code to work without any arguments so that it is less fiddly and makes a one-click RSS feed*.
 - `sitemapper.sh`: This script builds a sitemap.xml of your site. Make sure to edit the script options as described in the file comments. Paths within your site's `config` directory are excluded from the sitemap since that path is not intended to be traversable on its own.

### Build

Building your wmcms container image is easy!

```
git clone https://github.com/neonspectra/wmcms-docker/
cd wmcms-docker
docker build -t nginx:wmcms .
```

### Launch

Running your wmcms site is *also* easy. Just expose your image on port 80 and point whatever ssl frontend you are using toward your container image. However, that's outside the scope of this documentation.

To launch your site locally to be accessible on http://localhost you can do:
```
docker run -d -p 80:80 nginx:wmcms
```

### Maintenance

Consider building out a continuous integration pipeline to automatically push new commits to your container registry or system hosting your website. 

The basic steps to put up a new post on your website is going to be something along these lines:
- Fork this repository or set up a new repository with code from this repository
- *[write your new post, build a container image locally, test it, and commit your code to your repo]*
- Use the rsshelper to add your new post to RSS
- User the sitemapper to build an updated sitemap
- Build your new container image and push to wherever you have your site hosted

