recap of what s there
- mass_dpl.yml is an irrelevant file that i first created to try ansible and yaml syntax
- VC1.yml is the actual playbook, 
- the test directory is the directory i use to test out the deployment playbook


okay so quick documentation:
how to download ansible:
its simple, just do:

sudo apt update
sudo apt install ansible

to use ssh u first generate they key pair on ur control node by using:

ssh-keygen -t ed25519 -C control node

then copy it to ur cients:

ssh-copy-id -i ~/.ssh/id_ed25519.pub user@ip

[to do every time you reboot the machine if u have a password on ur private key]before doing anything u should set your ssh id by :

ssh-add ~/.ssh/id_ed25519


(its better not to have a password on it cz that ll become tedious with time)


then you are all set to use ssh,after creating your inventory, you can test ansible connectivity by using the ping module:

ansible all --key-file ~/.ssh/id_ed25519 -i inventory -m ping


