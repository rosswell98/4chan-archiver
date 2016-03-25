#!/bin/bash
echo "Started at `date +%Y%m%d-%H%M%S`"
mkdir -p 4chan/{html,temp,content}

mkdir -p 4chan/temp/b/
mkdir -p 4chan/content/b/
mkdir -p 4chan/content/b/{png,jpg,gif,webm}
echo "Dumping: /b/"
wget --mirror -q -e robots=off -np http://boards.4chan.org/b/ -P 4chan/html/

echo "Extracting image list: /b/"
grep -ERho 'i.4cdn.org/b/[0-9]{13}\.(jpg|png|gif|jpeg|webm)' 4chan/html/boards.4chan.org/b/ > 4chan/b-img.txt

echo "Removing duplicates: /b/"
sort 4chan/b-img.txt | uniq > 4chan/b-clean.txt

echo "Downloading: /b/"
wget -q -i 4chan/b-clean.txt -P 4chan/temp/b/

echo "Cleaning: /b/"
rm 4chan/{b-img,b-clean}.txt
rm -rf 4chan/html/boards.4chan.org/b/

echo "Downloaded: `ls -1 4chan/temp/b/ |wc -l`"

echo "Moving to permanent folder: /b/"
mv 4chan/temp/b/*.png 4chan/content/b/png/
mv 4chan/temp/b/*.jpg 4chan/content/b/jpg/
mv 4chan/temp/b/*.gif 4chan/content/b/gif/
mv 4chan/temp/b/*.webm 4chan/content/b/webm/

echo "Removing content duplicates"
rm 4chan/content/*/*.[0-9]
yes 1 | fdupes -dq 4chan/content

echo -e "Finished at `date +%Y%m%d-%H%M%S`.\nTotal nomber of contents: `ls -1 4chan/content/* |wc -l`"
