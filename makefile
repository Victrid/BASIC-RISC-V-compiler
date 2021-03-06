.PHONY: all
all: lexer orderer cfgizer translator asmpreproc as riscv-core
	@echo "done"

riscv-core: simulator
	$(MAKE) -C simulator
	mv simulator/code riscv-core
	
lexer: src/lexer-bin.cpp src/lexer.cpp src/lexer.hpp
	g++ -O3 src/lexer-bin.cpp src/lexer.cpp -o lexer

orderer: src/ordos-bin.cpp src/ordos.cpp src/parser.cpp src/ordos.hpp src/parser.hpp
	g++ -O3 src/ordos-bin.cpp src/ordos.cpp src/parser.cpp -o orderer

cfgizer: src/parser.cpp src/ordos.cpp src/cfgize.cpp src/cfg-bin.cpp src/ordos.hpp src/parser.hpp
	g++ -O3 src/cfg-bin.cpp src/ordos.cpp src/parser.cpp src/cfgize.cpp -o cfgizer

translator: src/parser.cpp src/translator-bin.cpp src/translate.hpp src/parser.hpp
	g++ -O3 src/parser.cpp src/translator-bin.cpp -o translator

asmpreproc: src/preproc-bin.cpp src/preproc.hpp
	g++ -O3 src/preproc-bin.cpp -o asmpreproc

as: src/as-bin.cpp src/as.hpp
	g++ -O3 src/as-bin.cpp -o as

test_lexer: src/lexer.cpp src/test-lexer.cpp
	g++ -O3 src/lexer.cpp src/test-lexer.cpp -lgtest -o test_lexer

test_parser: src/lexer.cpp src/parser.cpp src/test-parser.cpp src/parser.hpp
	g++ -O3 src/lexer.cpp src/parser.cpp src/test-parser.cpp -lgtest -o test_parser

test_ordos: src/lexer.cpp src/parser.cpp src/ordos.cpp src/test-ordos.cpp src/ordos.hpp src/parser.hpp
	g++ -O3 src/lexer.cpp src/parser.cpp src/ordos.cpp src/test-ordos.cpp -lgtest -o test_ordos

test_cfg: src/lexer.cpp src/parser.cpp src/ordos.cpp src/cfgize.cpp src/test-cfg.cpp src/ordos.hpp src/parser.hpp
	g++ -O3 src/lexer.cpp src/parser.cpp src/ordos.cpp src/cfgize.cpp src/test-cfg.cpp -lgtest -o test_cfg

test_tr: src/lexer.cpp src/parser.cpp src/ordos.cpp src/cfgize.cpp src/test-trans.cpp src/ordos.hpp src/parser.hpp src/translate.hpp
	g++ -O3 src/lexer.cpp src/parser.cpp src/ordos.cpp src/cfgize.cpp src/test-trans.cpp -lgtest -o test_tr

.PHONY: test
test: test_lexer test_parser test_ordos test_cfg test_tr
	./test_lexer
	./test_parser
	./test_ordos
	./test_cfg
	./test_tr

.PHONY: unit_test*
unit_test_lexer: test_lexer
	./test_lexer

unit_test_parser: test_parser
	./test_parser

unit_test_ordos: test_ordos
	./test_ordos

unit_test_cfg: test_cfg
	./test_cfg

unit_test_tr: test_tr
	./test_tr

.PHONY: clean
clean:
	rm -f ./test
	rm -f ./test_*
	rm -f ./cfgizer
	rm -f ./lexer
	rm -f ./orderer
	rm -f ./translator
	rm -f ./asmpreproc
	rm -f ./as
	rm -f *.riscv
	rm -f *.xml
	rm -f *.asm
	rm -f ./riscv-core
	$(MAKE) -C simulator clean
	@echo "done"
	
case_test:
	./testscript/test.sh testfiles/testcases/basic_test
	./testscript/test.sh testfiles/testcases/op_test
	./testscript/test.sh testfiles/testcases/control_test
