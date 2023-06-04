# slurm-workflow
slurm workflow management system 

# instructions
(cd into the appropriate directory)
1) Install dependencies
- ```pip install -r requirements.txt```
2) Install Jupyter Notebook
- ```sudo apt install jupyter-notebook```
3) Install MongoDB
- ```wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc |  gpg --dearmor | sudo tee /usr/share/keyrings/mongodb.gpg > /dev/null```
- ```echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list```
- ```sudo apt update```
- ```sudo apt install mongodb-org```
4) Start MongoDB
- `sudo service mongod start`
5) Check MongoDB status
- `service mongod status`
6) If it's not running:
- `sudo rm -rf /tmp/mongodb-27017.sock`
- `sudo service mongod start`
7) Install SLURM:
- `sh SLURM_Ubuntu_installation.sh`
8) Start SLURM:
- `sudo slurmctld`
9) Check SLURM status:
- `scontrol ping`
10) Submit jobs:
- `sbatch slurm_mongo.sh`
- `sbatch slurm_mongoreader.sh`
- `sbatch slurm_trainalgo.sh`
- `sbatch slurm_testalgo.sh`
11) Alternatively, run the scripts in Jupyter Notebook:
- `jupyter-notebook`

![image](https://github.com/d1by/slurm-workflow/assets/108338649/81a0490e-0454-4c8d-b71c-88ee9a56b77e)


![17a24b84-b8dd-43e4-bbe0-ffd4c59192c2](https://github.com/d1by/slurm-workflow/assets/108338649/33c25a2c-a166-42ff-81ae-d76fcc384974)
- [x] Data Pre-Processing
- [x] Data Storage & Management
- [x] Data Analysis
- [x] Data Visualization
- [x] Data Interpretation
