#!/bin/bash
# Install dependencies: apt-get install -y pcscd pcsc-tools libccid libpcsclite-dev python-pyscard
git clone https://github.com/osmocom/pysim
pushd pysim
python3 -m venv env
source env/bin/activate
pip install --upgrade pip
pip install wheel 
pip install -r requirements.txt
deactivate
popd

git clone https://github.com/herlesupreeth/sim-tools
pushd sim-tools
virtualenv -p python2 env
source env/bin/activate
pip install pycrypto pyscard
popd