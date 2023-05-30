#!/bin/bash

#SBATCH --job-name=job_%j
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00


python3 ml_train.py     #train algo
python3 plotter.py      #plot data
