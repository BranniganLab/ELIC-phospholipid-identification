#!/bin/bash
mkdir logs
mv *.log ./logs/
mv *.err ./logs/
mv *.out ./logs/
mv FFTW* ./logs/

for group in step5 petopg pctopg petopc popc popg pope prod1 watmoveabf; do
mkdir $group
mv *$group* ./$group/
mv *po$(echo $group | cut -c2)$(echo $group | cut -c6)* ./$group/
done
