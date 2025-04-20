#!/bin/bash

echo "Converting markdown to html"
pandoc -f markdown privacy_policy.md > temp.html

echo "Inserting content into privacy_policy.html"
sed -i '/<privacy_policy_goes_here\/>/r temp.html' build/web/privacy_policy.html
rm temp.html
