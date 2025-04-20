#!/bin/bash

echo "Converting markdown to html"
HTML_CONTENT=$(pandoc -f markdown privacy_policy.md)
echo "Inserting content into privacy_policy.html"
sed -i "s|<privacy_policy_goes_here/>|$HTML_CONTENT|g" build/web/privacy_policy.html
