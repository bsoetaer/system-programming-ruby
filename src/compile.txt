swig -ruby delay.i
gcc -shared -o Delay.so delay.c delay_wrap.c -I/opt/rh/ruby193/root/usr/include/ -I/opt/rh/ruby193/root/usr/include/x86_64-linux -fPIC
