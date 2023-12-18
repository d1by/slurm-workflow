#!/bin/bash

#SBATCH --job-name=testing_%j
#SBATCH --output=testing_%j.out
#SBATCH --error=testing_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

python3 scrape.py
