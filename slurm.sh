#!/bin/bash

#SBATCH --job-name=job_%j
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

numactl --interleave=all mongod --dbpath=database --bind_ip $(hostname -i) &
python3 mongo.py
