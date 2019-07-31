#!/bin/bash
set -o pipefail
me=$(basename ${0%%@@*})
full_me=${0%%@@*}
me_dir=$(dirname $(readlink -f ${0%%@@*}))

# FOR BEIHANG, DON'T FORGET EXTRA ARGUMENTS '--max_jobs_in_parallel' and '--num_proc_per_gpu'
#  --max_jobs_in_parallel 8 --num_proc_per_gpu 2

### CIFAR10 ###

# UNIFORM MIXUP/CIFAR10/CE/128BS/200E/12 RUNS
## uniform lambda (lam_parameters 1.0 1.0)
## gamma = lambda (gamma_parameters 1.0 1.0)
mini_regression.sh --num_simulations 12 -- --lam_parameters 1.0 1.0 --gamma_parameters 1.0 1.0 --dataset cifar10 --batch_size 128 --epoch 200

# BASELINE/CIFAR10/CE/128BS/200E/12 RUNS
## NO mixup
mini_regression.sh --num_simulations 12 -- --no_mixup --dataset cifar10 --batch_size 128 --epoch 200

# UNIFORM MIXUP/CIFAR10/NC(300)/128BS/200E/12 RUNS
## uniform lambda (lam_parameters 1.0 1.0)
## gamma = lambda (gamma_parameters 1.0 1.0)
mini_regression.sh --num_simulations 12 -- --lam_parameters 1.0 1.0 --gamma_parameters 1.0 1.0 --cosine_loss --label_dim 300 --dataset cifar10 --batch_size 128 --epoch 200

# BASELINE/CIFAR10/NC(300)/128BS/200E/12 RUNS
## NO mixup
mini_regression.sh --num_simulations 12 -- --no_mixup --cosine_loss --label_dim 300 --dataset cifar10 --batch_size 128 --epoch 200


### CIFAR100 ###

# UNIFORM MIXUP/CIFAR100/CE/128BS/200E/12 RUNS
## uniform lambda (lam_parameters 1.0 1.0)
## gamma = lambda (gamma_parameters 1.0 1.0)
mini_regression.sh --num_simulations 12 -- --lam_parameters 1.0 1.0 --gamma_parameters 1.0 1.0 --dataset cifar100 --batch_size 128 --epoch 200

# BASELINE/CIFAR100/CE/128BS/200E/12 RUNS
## NO mixup
mini_regression.sh --num_simulations 12 -- --no_mixup --dataset cifar100 --batch_size 128 --epoch 200

# UNIFORM MIXUP/CIFAR100/NC(700)/128BS/200E/12 RUNS
## uniform lambda (lam_parameters 1.0 1.0)
## gamma = lambda (gamma_parameters 1.0 1.0)
mini_regression.sh --num_simulations 12 -- --lam_parameters 1.0 1.0 --gamma_parameters 1.0 1.0 --cosine_loss --label_dim 700 --dataset cifar100 --batch_size 128 --epoch 200

# BASELINE/CIFAR100/NC(700)/128BS/200E/12 RUNS
## NO mixup
mini_regression.sh --num_simulations 12 -- --no_mixup --cosine_loss --label_dim 700 --dataset cifar100 --batch_size 128 --epoch 200


# Other modes that should be run (just not appropriate for sanity:)
# DAT
# Untied examples
# Dat transform examples

# A=0.9 MIXUP/CIFAR10/CE/128BS/200E/12 RUNS
## uniform lambda (lam_parameters 0.9 0.9)
## gamma = lambda (gamma_parameters 1.0 1.0)
mini_regression.sh --num_simulations 12 -- --lam_parameters 0.9 0.9 --gamma_parameters 1.0 1.0 --dataset cifar10 --batch_size 128 --epoch 200

# UNTIED 2.2,0.9 CIFAR10/CE/128BS/200E/12 RUNS
mini_regression.sh --num_simulations 12 -- --dat_transform --dat_parameters 2.2 0.9 --dataset cifar10 --batch_size 128 --epoch 200

# UNTIED 1.4,0.7 CIFAR100/CE/128BS/200E/12 RUNS
mini_regression.sh --num_simulations 12 -- --dat_transform --dat_parameters 1.4 0.7 --dataset cifar10 --batch_size 128 --epoch 200


# A=0.9 MIXUP/CIFAR10/NC(300)/128BS/200E/12 RUNS
## uniform lambda (lam_parameters 0.9 0.9)
## gamma = lambda (gamma_parameters 1.0 1.0)
mini_regression.sh --num_simulations 12 -- --lam_parameters 0.9 0.9 --gamma_parameters 1.0 1.0 --cosine_loss --label_dim 300 --dataset cifar10 --batch_size 128 --epoch 200

# UNTIED 2.2,0.9 CIFAR10/NC(300)/128BS/200E/12 RUNS
mini_regression.sh --num_simulations 12 -- --dat_transform --dat_parameters 2.2 0.9 --cosine_loss --label_dim 300 --dataset cifar10 --batch_size 128 --epoch 200

# UNTIED 1.4,0.7 CIFAR100/NC(700)/128BS/200E/12 RUNS
mini_regression.sh --num_simulations 12 -- --dat_transform --dat_parameters 1.4 0.7 --cosine_loss --label_dim 700 --dataset cifar100 --batch_size 128 --epoch 200