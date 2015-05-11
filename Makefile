APP_FILES=$(shell find . -type f -name '*.lua')
LIT_VERSION=1.1.8
TARGET=example
LUVI?=./luvi
LIT?=./lit

all: $(TARGET)

$(TARGET): lit $(APP_FILES)
	./lit make

clean:
	rm -rf $(TARGET) lit luvi

lit:
	[ -x lit ] || curl -L https://github.com/luvit/lit/raw/${LIT_VERSION}/get-lit.sh | sh

lint:
	find . ! -path './deps/**' ! -path './tests/**' -name '*.lua' | xargs luacheck


.PHONY: clean lint lit
