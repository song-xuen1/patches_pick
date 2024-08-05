#!/bin/bash

echo start get patches

base_commit="$1"
tips_commit="$2"

patches_dir="patches/"

debian_dir="debian/"
debian_master_dir="debian.master/"
debian_qcom_dir="debian.qcom/"
ubuntu_dir="ubuntu/"

match_tag="UBUNTU-SAUCE"

if [ -d "$patches_dir" ]; then
	echo patches path already exist
	rm -r $patches_dir
	mkdir -p "$patches_dir"base
else
	mkdir -p "$patches_dir"base
fi

git format-patch $base_commit..$tips_commit -o $patches_dir $debian_dir $debian_master_dir $debian_qcom_dir $ubuntu_dir 

for patch in "$patches_dir"*.patch; do
	filename="${patch##*/}"
	if [[ $filename == *$match_tag* ]]; then
		rm $patch
		echo remove patch which includes $match_tag : $patch
	fi
done

base_patch_dir="patches/base/"

git format-patch -1 $base_commit -o $base_patch_dir
