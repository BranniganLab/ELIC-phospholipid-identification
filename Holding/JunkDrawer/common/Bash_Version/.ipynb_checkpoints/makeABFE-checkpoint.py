import os
import argparse

parser = argparse.ArgumentParser(description='Generate the needed files for running ABFE given a starting topology and structure.')
parser.add_argument('path', type=str, nargs='+',
                    help='path to the common directory')
parser.add_argument('template', type=str, help='path to the template directory')

args = parser.parse_args()




