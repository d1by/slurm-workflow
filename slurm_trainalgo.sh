#!/bin/bash

#SBATCH --job-name=train-ml-job_%j
#SBATCH --output=train-ml-job_%j.out
#SBATCH --error=train-ml-job_%j.err
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

echo training....
python3 ml_train.py     #train algo
echo plotting....
python3 plotter.py      #plot data
