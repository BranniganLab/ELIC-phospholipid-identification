#!/bin/bash

function template {
	local key=$1
	local val=$2
	local source=$3
	local sink=$4
	sed "s/$key/$val/g" $source > $sink
	return 1
}

