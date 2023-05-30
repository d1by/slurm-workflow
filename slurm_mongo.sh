#!/bin/bash

#SBATCH --job-name=mongojob_%j
#SBATCH --output=mongojob_%j.out
#SBATCH --error=mongojob_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

numactl --interleave=all mongod --dbpath=database --bind_ip $(hostname -i) &
python3 csvToMng.py
