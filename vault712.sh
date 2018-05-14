#!/bin/bash
##Download on https://github.com/jackrack/Vault712

##Config setup
##GrinLog=/root/mw/grin/server/grin.log

##Rust installer function
rust_installer()
{
sudo apt-get update -y
sudo apt-get install build-essential cmake -y	
	
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
}

##Clang installer function
clang_installer()
{
sudo apt-get update
sudo apt-get install clang-3.8
}

##Libncurses & zlib1g installer function not yet activated
dependencies_installer()
{
sudo apt-get install libncurses5-dev libncursesw5-dev
sudo apt-get install zlib1g-dev
}

##Grin installer function
main_installer()
{
while true; do
    read -p "Do you wish to install Grin? "  yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
cd $HOME
mkdir mw/
cd mw
git clone https://github.com/mimblewimble/grin.git
cd grin
cargo build --verbose
main_menu
}

#Reinstall Grin
reinstall_grin()
{
rm -rf $HOME/mw
cd $HOME
mkdir mw/
cd mw
git clone https://github.com/mimblewimble/grin.git
cd grin
cargo build --verbose
main_menu
}

##Start node function
my_node()
{
cd $HOME/mw/grin/
export PATH=$HOME/mw/grin/target/debug:$PATH
grin
}

##Start spend balance function
my_spendbalance()
{
cd $HOME/mw/grin/
export PATH=/$HOME/mw/grin/target/debug/:$PATH
grin wallet info
echo "Press ENTER To Return"
read continues
}

##Start output function
my_outputs()
{
cd $HOME/mw/grin
export PATH=$HOME/mw/grin/target/debug/:$PATH
grin wallet outputs
echo "Press ENTER To Return"
read continue
}

##Start output function in detail
my_outputs_detailed()
{
cd $HOME/mw/grin
cat wallet.dat
echo "Press ENTER To Return"
read continue
}

##Function to send Grin to an ip address
sendgrinto_ip()
{
echo This option will send Grins to an IP address
cd $HOME/mw/grin/
export PATH=$HOME/mw/grin/target/debug:$PATH
read -p 'Please enter the ip address of recipient to send: ' sendipvar
read -p 'Please enter the amount of Grins to send: ' sendamountvar
grin wallet send -d http$sendipvar:13415 $sendamountvar
echo You have sent $sendamountvar Grins to $sendipvar
echo Press any key to return
read
}

##Start the main part of the application menu if Grin and prerequisites are installed
main_menu()
{

while :
do
    clear
   
	echo " "
	echo -e "Grin has been succesfully installed, please choose one of the options below\n"
	echo "MAIN OPTIONS"
	echo "1) Start Grin"
	echo "2) Shutdown all Grin Nodes & Servers"
	echo ""
	echo "GRIN DEBUG OPTIONS"
    echo "3) View Confirmed & Spendable Balance "
    echo "4) Show Individual Outputs"
    echo "5) Show Detailed Individual Outputs"
    echo ""
    echo "GRIN SEND & RECEIVE OPTIONS"
	echo "6) Send Grin to an IP"
    echo ""
    echo "OPTIONS"
    echo "7) Reinstall Grin (Latest Available)"
	echo "8) Exit"
	echo "====================================="
	
	read m_menu
	
	case "$m_menu" in
	
		1) option_1;;
		2) option_2;;
		3) option_3;;
		4) option_4;;
		5) option_5;;
		6) option_6;;
		7) option_7;;
		8) exit 0;;
		*) echo "Error, invalid input, press ENTER to go back"; read;;
	esac
done
}

option_1()
{
   ##export function, run a new shell starting Grin
   export -f my_node
   $(gnome-terminal --tab -e "bash -c 'my_node'")  
}

option_2()
{
	##shutdown any Grin process
	killall -9 grin
	main_menu
}

option_3()
{   
    ##export function, run a new shell
	export -f my_spendbalance
	$(gnome-terminal --tab -e "bash -c 'my_spendbalance'")
}

option_4()
{
    ##export function, run a new shell
	export -f my_outputs
	$(gnome-terminal --tab -e "bash -c 'my_outputs'")
	
}

option_5()
{
	##export function, run a new shell
	export -f my_outputs_detailed
	$(gnome-terminal --tab -e "bash -c 'my_outputs_detailed'")
}

option_6()
{
	##export function, run a new shell
	export -f sendgrinto_ip
	$(gnome-terminal --tab -e "bash -c 'sendgrinto_ip'")
	
}

option_7()
{
	export -f reinstall_grin
	$(gnome-terminal --tab -e "bash -c 'reinstall_grin'")
}

option_wait()
{
	echo This option will send Grins to Termbin and can be claimed by anyone that knows the url
	export PATH=$HOME/mw/grin/target/debug:$PATH
	read -p 'Please enter amount to send: ' amountvar
	grin wallet send -d $amountvar
	termbinvar="$(echo $amountvar | nc termbin.com 9999)"
	echo Share this url to allow someone to claim the output: "$termbinvar"
	echo Press any key to return
	read
	
}

##Check if Clang is installed
if [ "type -p clang-3.8" ];
then
	:
else
	clang_installer
fi

##Check if Rust is installed
if [ "type -p rustc" ];
then
     :
else 
     rust_installer
fi

##Check if Grin is installed
if [ -d "$HOME/mw/grin/" ];
then
    main_menu
else
    main_installer
fi
