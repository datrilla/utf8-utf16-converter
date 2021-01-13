
##Linux
CC=gcc
AR=ar

##for (int cont_index = size - 1; cont_index > 0; cont_index--) 
##if no use -std=c99  ,change it as   
##int cont_index; for (cont_index = size - 1; cont_index > 0; cont_index--) 

CFLAGS=-g -Wall   -std=c99 

top_d=./
install_d=./lib/


need_c_dir=$(install_d) 

lib_inc=-I$(top_d)converter/include/
lib_src=$(top_d)converter/src/
TEST_DIR=$(top_d)tester/test-cases/
src_test=$(top_d)tester/src/


SRC_INC= -I$(top_d)converter/src/   $(lib_inc)
all:       alllibs     mktest 
alllibs :  mkdirs      mklibcovutf
mkdirs :$(need_c_dir)
$(need_c_dir) :
	if [ ! -d $@ ];then mkdir -p $@;fi;
	

mklibcovutf:$(install_d)libcovutf.a 
$(install_d)libcovutf.a:$(lib_src)converter.c
	$(CC)   $(CFLAGS) $(SRC_INC)     -c $(lib_src)converter.c -o $(lib_src)converter.o
	$(AR)   rv libcovutf.a   $(lib_src)converter.o
	mv libcovutf.a    $(install_d)
mktest:mklibcovutf
	$(CC)    -o  $(TEST_DIR)tester $(CFLAGS)   $(lib_inc) $(src_test)test.c     -L$(install_d) -lcovutf  -lm       
clean  clear: 
	rm -f $(install_d)libcovutf.a
	rm -f $(lib_src)converter.o
	rm -f $(TEST_DIR)tester


checktest:  
	cd  $(TEST_DIR) 
	pwd  
	-cd  $(TEST_DIR) &&./tester utf16  two-way/chinese.utf16.txt      two-way/chinese.utf8.txt 
	-cd  $(TEST_DIR) &&./tester utf8    two-way/chinese.utf8.txt       two-way/chinese.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf16   two-way/emoji.utf16.txt        two-way/emoji.utf8.txt
	-cd  $(TEST_DIR) &&./tester utf8    two-way/emoji.utf8.txt         two-way/emoji.utf16.txt  
	-cd  $(TEST_DIR) &&./tester utf16   two-way/lorem_ipsum.utf16.txt  two-way/lorem_ipsum.utf8.txt
	-cd  $(TEST_DIR) &&./tester utf8    two-way/lorem_ipsum.utf8.txt   two-way/lorem_ipsum.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf16   two-way/bible.utf16.txt        two-way/bible.utf8.txt
	-cd  $(TEST_DIR) &&./tester utf8    two-way/bible.utf8.txt         two-way/bible.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf16   two-way/all.utf16.txt          two-way/all.utf8.txt
	-cd  $(TEST_DIR) &&./tester utf8    two-way/all.utf8.txt           two-way/all.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf8 utf8-to-utf16/overlong.utf8.txt         utf8-to-utf16/invalid.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf8 utf8-to-utf16/rogue.utf8.txt            utf8-to-utf16/invalid.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf8 utf8-to-utf16/surrogate.utf8.txt        utf8-to-utf16/invalid.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf8 utf8-to-utf16/truncated.utf8.txt        utf8-to-utf16/invalid.utf16.txt
	-cd  $(TEST_DIR) &&./tester utf16 utf16-to-utf8/unmatched_high.utf16.txt utf16-to-utf8/invalid.utf8.txt
	-cd  $(TEST_DIR) &&./tester utf16 utf16-to-utf8/unmatched_low.utf16.txt  utf16-to-utf8/invalid.utf8.txt
 
