# QLI-Client running under ZLUDA

This Dockerfile and run script are all you need to run QLI-Client under ZLUDA for AMD GPUs. This image also supports CPU only and Nvidia GPUs, however is not space efficient for this purpose.

***This project is not affiliated with [Qubic](http://discord.gg/qubic) or [Qubic.li](https://qubic.li/). Please report any bugs related to the docker container here and miner specific bugs to the respective miner owners.***

## Usage

The following environment variables are required:
| Name           | Description                                                      | Options                                                                  | Default |
|----------------|------------------------------------------------------------------|--------------------------------------------------------------------------|---------|
| ACCESS_TOKEN    | Your Qubic.li pool access token                                 |                                                                          |         |
| WALLET_ADDRESS  | Your Qubic wallet payout address                                 |                                                                          |         |
| WORKER_NAME     | Your worker name/label visible in the pool                       |                                                                          |         | 
| THREAD_COUNT    | Number of CPU threads to use. Set to 0 to disable CPU Mining.                       |                                                                          |         | 
| USE_GPU         | Enables GPU Mining (Nvidia or AMD)                       |                                                                          |         | 
| USE_ZLUDA       | Enables ZLUDA for AMD GPU Mining                       |                                                                          |         | 
This image does not currently suppot the Payment ID parameter for the pool.

The following command starts the container with the specified parameters

`docker run --device=/dev/kfd --device=/dev/dri --group-add=video --security-opt seccomp=unconfined -e WALLET_ADDRESS=my-wallet-address -e WORKER_NAME=my-worker -e ACCESS_TOKEN=my-access-token -e THREAD_COUNT=12 -e USE_GPU=true -e USE_ZLUDA=true ghcr.io/BlockBlitz/qli-zluda:latest`

Or more favorably, via the included docker-compose file.

Qubic: GKLVMTZITKRXGEAKRCIFSNOHQWPDZNXJOAAEXMRIEFYQENRQZOTZBGMCWRAE
