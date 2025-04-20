#!/bin/bash

echo "Converting markdown to html"
pandoc -f markdown privacy_policy.md > privacy_policy_content.html

echo "Output:"
cat privacy_policy_content.html

echo "Inserting content into privacy_policy.html"
sed -i 's|<privacy_policy_goes_here/>|'"$(cat privacy_policy_content.html)"'|g' build/web/privacy_policy.html
