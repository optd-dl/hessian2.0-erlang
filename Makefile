EBIN_DIR=ebin
SOURCE_DIR=src
TEST_DIR=test
INCLUDE_DIR=include

compile:
	mkdir -p $(EBIN_DIR)
	erlc -I $(INCLUDE_DIR) -o $(EBIN_DIR) $(SOURCE_DIR)/*.erl
	erlc -I $(INCLUDE_DIR) -o $(EBIN_DIR) $(TEST_DIR)/*.erl

all: compile

clean:
	rm $(EBIN_DIR)/*.beam

