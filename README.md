# SIM Multitool

This is a script for gluing together a few different SIM card related programs. It uses a database of SIM card key values which is not included. I built it for personal use so some assumptions are made about usage, but it should be simple to reconfigure.

Notable assumptions:
    - I always use PCSC devices, so all programs are called with `-p0`. Configure the `$READER_ARG` variable if this is not your use case.
    - I use a database of SIM card key values and keys are retrieved from it. The schema is described below if needed.

Still a work in progress.

## Installation
Install dependencies:
`apt-get install -y pcscd pcsc-tools libccid libpcsclite-dev python-pyscard`
Download and install:
`git clone https://github.com/BryanCoxwell/sim-multitool`
`cd sim-multitool`
`chmod +x install.sh`
`./install.sh`

This will install Osmocom's PySim, Shadysim, and Sysmo-Usim-Tool and set them up in their own virtual environments which the script calls them from. 

## Usage
All multitool really does is call the above installed programs and pass along the arguments as you would if you were calling the program directly. Where needed, the database is queried to pass the ADM1, KIC, KID, and KIK keys to allow you to only pass the values or install applets without needing to chase down keys first. 

For example:
  `./multi-tool write -i 001010000055510 -x 001 -y 01 -n TEST`
will call `./pySim-prog -a <ADM1> -i <IMSI> -x <MCC> -y <MNC> -n <PROVIDER NAME>`
where the ADM value is provided by the DB (by calling pySim-read and querying the DB for the card's ICCID)

NOTE: This script assumes using PCSC device 0 to write SIMS since that is uniformly my use case. If you need to change this, configure READER_ARG in the script.
```
Options:

help  | -h        This menu.
read  | -r        Read SIM. Uses pySim-read. Requires no arguments.
write | -w        Write SIM. Uses pySim-prog. Pass all arguments as you would to pySim-prog EXCEPT keys.
list  | -L        Lists applets on SIM. Uses Shadysim. Requires no arguments.
push  | -p        Push (load and install) applet to SIM. Uses Shadysim.
                  Pass all arguments as you would to Shadysim EXCEPT keys.
shell             Writes ADM1 key to local script named 'adm' and opens pySim-shell.
                  Run 'run_script adm' from pySim-shell to verify ADM1 key
simtool           Runs Sysmo-USIM-tool. Only passes ADM1.

```
## The database

A database might be overkill for a lot of folks, but if you want to use one, I set up my schema in a MySQL database for it as follows:
```
mysql> describe sim_cards;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| ICCID | char(19) | NO   | PRI | NULL    |       |
| IMSI  | char(15) | NO   | UNI | NULL    |       |
| ACC   | smallint | YES  |     | NULL    |       |
| PIN1  | int      | YES  |     | NULL    |       |
| PUK1  | int      | YES  |     | NULL    |       |
| PIN2  | int      | YES  |     | NULL    |       |
| PUK2  | int      | YES  |     | NULL    |       |
| KI    | char(32) | YES  |     | NULL    |       |
| OPC   | char(32) | YES  |     | NULL    |       |
| ADM1  | int      | YES  |     | NULL    |       |
| KIC1  | char(32) | YES  |     | NULL    |       |
| KIC2  | char(32) | YES  |     | NULL    |       |
| KID1  | char(32) | YES  |     | NULL    |       |
| KID2  | char(32) | YES  |     | NULL    |       |
| KIK1  | char(32) | YES  |     | NULL    |       |
| KIK2  | char(32) | YES  |     | NULL    |       |
+-------+----------+------+-----+---------+-------+
```
Then configure the `USER`, `PASSWORD`, and `HOST` variables in the `multi-tool` script to refect your credentials.