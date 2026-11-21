AS = as
LD = ld

OBJS = main.o \
       utils/print.o \
       utils/numbers.o \
       modules/system.o \
       modules/uptime.o \
       modules/memory.o \
       modules/cpu.o \
	   utils/colors.o \
	   utils/string.o

picofetch: $(OBJS)
	$(LD) $(OBJS) -o picofetch

%.o: %.s
	$(AS) --64 $< -o $@

clean:
	rm -f $(OBJS) picofetch

.PHONY: clean
