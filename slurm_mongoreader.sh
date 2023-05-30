#!/bin/bash

#SBATCH --job-name=mongoreaderjob_%j
#SBATCH --output=mongoreaderjob_%j.out
#SBATCH --error=mongoreaderjob_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

python3 mongoreader.py
