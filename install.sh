#!/bin/bash
# On Linux, install dependencies: apt-get install -y pcscd pcsc-tools libccid libpcsclite-dev python-pyscard
git clone https://github.com/osmocom/pysim
pushd pysim
python3 -m venv env
source env/bin/activate
pip install --upgrade pip
pip install wheel 
pip install -r requirements.txt
deactivate
popd
# run with eg: pysim/env/bin/python3 pysim/pySim-read.py -p 0
git clone https://github.com/herlesupreeth/sim-tools
pushd sim-tools
virtualenv -p python2 env
source env/bin/activate
pip install pycrypto pyscard
popd

# run with eg: sim-tools/env/bin/python sim-tools/shadysim/shadysim.py --pcsc -t