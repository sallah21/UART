del -f ex1.vvp
del -f ex1.vcd

iverilog -Wall -s EX1_tb -o ex1.vvp Rx.v Tx.v Clock.v ex1.v
if ERRORLEVEL 1 goto ON_ERROR

vvp ex1.vvp
if ERRORLEVEL 1 goto ON_ERROR
gtkwave ex1.gtkw

goto SIM_EXIT

:ON_ERROR
echo Terminating on error.

:SIM_EXIT

